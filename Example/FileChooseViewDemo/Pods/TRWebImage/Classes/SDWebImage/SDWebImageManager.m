/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageManager.h"
#import <objc/message.h>

#import "TRWebDataManager.h"

@interface SDWebImageCombinedOperation : NSObject <SDWebImageOperation>

@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;
@property (copy, nonatomic) SDWebImageNoParamsBlock cancelBlock;
@property (strong, nonatomic) NSOperation *cacheOperation;

@end

@interface SDWebImageManager ()

@property (strong, nonatomic, readwrite) TRWebDataCache *imageCache;
@property (strong, nonatomic, readwrite) TRWebDataDownloader *imageDownloader;
@property (strong, nonatomic) NSMutableSet *failedURLs;
@property (strong, nonatomic) NSMutableArray *runningOperations;

@end

@implementation SDWebImageManager

+ (id)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        _imageCache = [TRWebDataCache sharedDataCache];
        _imageDownloader = [TRWebDataDownloader sharedDownloader];
        _failedURLs = [NSMutableSet new];
        _runningOperations = [NSMutableArray new];
    }
    return self;
}


- (NSString *)cacheKeyForURL:(NSURL *)url {
    return [url absoluteString];
}


- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(SDWebImageOptions)options
                                        progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                       completed:(SDWebImageCompletionWithFinishedBlock)completedBlock {
    

    // Invoking this method without a completedBlock is pointless
    NSAssert(completedBlock != nil, @"If you mean to prefetch the image, use -[TRWebDataPrefetcher prefetchURLs] instead");
    
    // Very common mistake is to send the URL using NSString object instead of NSURL. For some strange reason, XCode won't
    // throw any warning for this type mismatch. Here we failsafe this error by allowing URLs to be passed as NSString.
    if ([url isKindOfClass:NSString.class]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    
    // Prevents app crashing on argument type error like sending NSNull instead of NSURL
    if (![url isKindOfClass:NSURL.class]) {
        url = nil;
    }
    
    __block SDWebImageCombinedOperation *operation = [SDWebImageCombinedOperation new];
    __weak SDWebImageCombinedOperation *weakOperation = operation;
    
    BOOL isFailedUrl = NO;
//    @synchronized (self.failedURLs) {
//        isFailedUrl = [self.failedURLs containsObject:url];
//    }
    
    if (!url || (!(options & TRWebDataRetryFailed) && isFailedUrl)) {
        dispatch_main_sync_safe(^{
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
            completedBlock(nil, error, SDImageCacheTypeNone, YES, url);
        });
        return operation;
    }
    
    @synchronized (self.runningOperations) {
        [self.runningOperations addObject:operation];
    }
    NSString *key = [self cacheKeyForURL:url];
    
    operation.cacheOperation = [self.imageCache queryDiskCacheForKey:key done:^(NSData *data, TRWebDataCacheType cacheType) {
        if (operation.isCancelled) {
            @synchronized (self.runningOperations) {
                [self.runningOperations removeObject:operation];
            }
            
            return;
        }
        
        if ((!data || options & TRWebDataRefreshCached) && (![self.delegate respondsToSelector:@selector(imageManager:shouldDownloadImageForURL:)] || [self.delegate imageManager:self shouldDownloadImageForURL:url])) {
            if (data && options & TRWebDataRefreshCached) {
                dispatch_main_sync_safe(^{
                    // If image was found in the cache bug TRWebDataRefreshCached is provided, notify about the cached image
                    // AND try to re-download it in order to let a chance to NSURLCache to refresh it from server.
                    completedBlock([UIImage imageWithData:data], nil, (SDImageCacheType)cacheType, YES, url);
                });
            }
            
            // download if no image or requested to refresh anyway, and download allowed by delegate
            TRWebDataDownloaderOptions downloaderOptions = 0;
            if (options & TRWebDataLowPriority) downloaderOptions |= TRWebDataDownloaderLowPriority;
            if (options & TRWebDataProgressiveDownload) downloaderOptions |= TRWebDataDownloaderProgressiveDownload;
            if (options & TRWebDataRefreshCached) downloaderOptions |= TRWebDataDownloaderUseNSURLCache;
            if (options & TRWebDataContinueInBackground) downloaderOptions |= TRWebDataDownloaderContinueInBackground;
            if (options & TRWebDataHandleCookies) downloaderOptions |= TRWebDataDownloaderHandleCookies;
            if (options & TRWebDataAllowInvalidSSLCertificates) downloaderOptions |= TRWebDataDownloaderAllowInvalidSSLCertificates;
            if (options & TRWebDataHighPriority) downloaderOptions |= TRWebDataDownloaderHighPriority;
            if (data && options & TRWebDataRefreshCached) {
                // force progressive off if image already cached but forced refreshing
                downloaderOptions &= ~TRWebDataDownloaderProgressiveDownload;
                // ignore image read from NSURLCache if image if cached but force refreshing
                downloaderOptions |= TRWebDataDownloaderIgnoreCachedResponse;
            }
            id <TRWebDataOperation> subOperation = [self.imageDownloader downloadImageWithURL:url options:downloaderOptions progress:progressBlock completed:^(NSData *data, NSError *error) {
                if (weakOperation.isCancelled) {
                    // Do nothing if the operation was cancelled
                    // See #699 for more details
                    // if we would call the completedBlock, there could be a race condition between this block and another completedBlock for the same object, so if this one is called second, we will overwrite the new data
                }
                else if (error) {
                    dispatch_main_sync_safe(^{
                        if (!weakOperation.isCancelled) {
                            completedBlock(nil, error, SDImageCacheTypeNone, YES, url);
                        }
                    });
                    
                    if (error.code != NSURLErrorNotConnectedToInternet && error.code != NSURLErrorCancelled && error.code != NSURLErrorTimedOut) {
                        @synchronized (self.failedURLs) {
                            [self.failedURLs addObject:url];
                        }
                    }
                }
                else {
                    BOOL waitForSave = !(options & TRWebDataWaitSaveDiskCompletion);
                    if (waitForSave){
                        [self.imageCache storeData:data forKey:key toDisk:YES withBlock:^(NSString *filePath) {
                            if (!weakOperation.isCancelled) {
                                completedBlock([UIImage imageWithData:data], nil, SDImageCacheTypeNone, YES, url);
                            }
                        }];
                    }else{
                        BOOL cacheOnDisk = !(options & TRWebDataCacheMemoryOnly);
                        if (data) {
                            [self.imageCache storeData:data forKey:key toDisk:cacheOnDisk];
                            dispatch_main_sync_safe(^{
                                if (!weakOperation.isCancelled) {
                                    completedBlock([UIImage imageWithData:data], nil, SDImageCacheTypeNone, YES, url);
                                }
                            });
                        }
                    }
                    
                }
                
                @synchronized (self.runningOperations) {
                    [self.runningOperations removeObject:operation];
                }
            }];
            operation.cancelBlock = ^{
                [subOperation cancel];
                
                @synchronized (self.runningOperations) {
                    [self.runningOperations removeObject:weakOperation];
                }
            };
        }
        else if (data) {
            dispatch_main_sync_safe(^{
                if (!weakOperation.isCancelled) {
                    completedBlock([UIImage imageWithData:data], nil, (SDImageCacheType)cacheType, YES, url);
                }
            });
            @synchronized (self.runningOperations) {
                [self.runningOperations removeObject:operation];
            }
        }
        else {
            // Image not in cache and download disallowed by delegate
            dispatch_main_sync_safe(^{
                if (!weakOperation.isCancelled) {
                    completedBlock(nil, nil, SDImageCacheTypeNone, YES, url);
                }
            });
            @synchronized (self.runningOperations) {
                [self.runningOperations removeObject:operation];
            }
        }
    }];
    
    return operation;
}


- (void)cancelAll {
    [[TRWebDataManager sharedManager] cancelAll];
}

- (BOOL)isRunning {
    return [[TRWebDataManager sharedManager] isRunning];
}

@end


@implementation SDWebImageCombinedOperation

- (void)setCancelBlock:(SDWebImageNoParamsBlock)cancelBlock {
    // check if the operation is already cancelled, then we just call the cancelBlock
    if (self.isCancelled) {
        if (cancelBlock) {
            cancelBlock();
        }
        _cancelBlock = nil; // don't forget to nil the cancelBlock, otherwise we will get crashes
    } else {
        _cancelBlock = [cancelBlock copy];
    }
}

- (void)cancel {
    self.cancelled = YES;
    if (self.cacheOperation) {
        [self.cacheOperation cancel];
        self.cacheOperation = nil;
    }
    if (self.cancelBlock) {
        self.cancelBlock();
        
        // TODO: this is a temporary fix to #809.
        // Until we can figure the exact cause of the crash, going with the ivar instead of the setter
//        self.cancelBlock = nil;
        _cancelBlock = nil;
    }
}

@end


@implementation SDWebImageManager (Deprecated)

// deprecated method, uses the non deprecated method
// adapter for the completion block
- (id <SDWebImageOperation>)downloadWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedWithFinishedBlock)completedBlock {
    return [self downloadImageWithURL:url
                              options:options
                             progress:progressBlock
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (completedBlock) {
                                    completedBlock(image, error, cacheType, finished);
                                }
                            }];
}

@end
