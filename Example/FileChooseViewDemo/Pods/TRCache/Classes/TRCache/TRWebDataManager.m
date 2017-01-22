/*
 * This file is part of the TRWebData package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "TRWebDataManager.h"
#import <objc/message.h>


@interface TRWebDataCombinedOperation : NSObject <TRWebDataOperation>

@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;
@property (copy, nonatomic) TRWebDataNoParamsBlock cancelBlock;
@property (strong, nonatomic) NSOperation *cacheOperation;

@end

@interface TRWebDataManager ()

@property (strong, nonatomic, readwrite) TRWebDataCache *dataCache;
@property (strong, nonatomic, readwrite) TRWebDataDownloader *imageDownloader;
@property (strong, nonatomic) NSMutableSet *failedURLs;
@property (strong, nonatomic) NSMutableArray *runningOperations;

@end

@implementation TRWebDataManager

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
        _dataCache = [self createCache];
        _imageDownloader = [TRWebDataDownloader sharedDownloader];
        _failedURLs = [NSMutableSet new];
        _runningOperations = [NSMutableArray new];
    }
    return self;
}

- (TRWebDataCache *)createCache {
    return [TRWebDataCache sharedDataCache];
}


- (NSString *)cacheKeyForURL:(NSURL *)url {
    if (self.cacheKeyFilter) {
        return self.cacheKeyFilter(url);
    }
    else {
        return [url absoluteString];
    }
}

- (id <TRWebDataOperation>)downloadDataWithURL:(NSURL *)url
                                       options:(TRWebDataOptions)options
                                      progress:(TRWebDataDownloaderProgressBlock)progressBlock
                                     completed:(TRWebDataCompletionBlock)completedBlock {
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
    
    __block TRWebDataCombinedOperation *operation = [TRWebDataCombinedOperation new];
    __weak TRWebDataCombinedOperation *weakOperation = operation;
    
    BOOL isFailedUrl = NO;
//    @synchronized (self.failedURLs) {
//        isFailedUrl = [self.failedURLs containsObject:url];
//    }
    
    if (!url || (!(options & TRWebDataRetryFailed) && isFailedUrl)) {
        dispatch_main_sync_safe(^{
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
            completedBlock(nil, error, TRWebDataCacheTypeNone, url);
        });
        return operation;
    }
    
    @synchronized (self.runningOperations) {
        [self.runningOperations addObject:operation];
    }
    NSString *key = [self cacheKeyForURL:url];
    
    operation.cacheOperation = [self.dataCache queryDiskCacheForKey:key done:^(NSData *data, TRWebDataCacheType cacheType) {
        if (operation.isCancelled) {
            @synchronized (self.runningOperations) {
                [self.runningOperations removeObject:operation];
            }
            
            return;
        }
        
        if ((!data || options & TRWebDataRefreshCached) && (![self.delegate respondsToSelector:@selector(dataManager:shouldDownloadDataForURL:)] || [self.delegate dataManager:self shouldDownloadDataForURL:url])) {
            if (data && options & TRWebDataRefreshCached) {
                dispatch_main_sync_safe(^{
                    // If image was found in the cache bug TRWebDataRefreshCached is provided, notify about the cached image
                    // AND try to re-download it in order to let a chance to NSURLCache to refresh it from server.
                    completedBlock(data, nil, cacheType, url);
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
                            completedBlock(nil, error, TRWebDataCacheTypeNone, url);
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
                        [self.dataCache storeData:data forKey:key toDisk:YES withBlock:^(NSString *filePath) {
                            if (!weakOperation.isCancelled) {
                                completedBlock(data, nil, TRWebDataCacheTypeNone, url);
                            }
                        }];
                    }else{
                        BOOL cacheOnDisk = !(options & TRWebDataCacheMemoryOnly);
                        if (data) {
                            [self.dataCache storeData:data forKey:key toDisk:cacheOnDisk];
                            dispatch_main_sync_safe(^{
                                if (!weakOperation.isCancelled) {
                                    completedBlock(data, nil, TRWebDataCacheTypeNone, url);
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
                    completedBlock(data, nil, cacheType, url);
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
                    completedBlock(nil, nil, TRWebDataCacheTypeNone, url);
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
    @synchronized (self.runningOperations) {
        NSArray *copiedOperations = [self.runningOperations copy];
        [copiedOperations makeObjectsPerformSelector:@selector(cancel)];
        [self.runningOperations removeObjectsInArray:copiedOperations];
    }
}

- (BOOL)isRunning {
    return self.runningOperations.count > 0;
}

@end


@implementation TRWebDataCombinedOperation

- (void)setCancelBlock:(TRWebDataNoParamsBlock)cancelBlock {
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

