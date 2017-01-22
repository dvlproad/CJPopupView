/*
 * This file is part of the TRWebData package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "TRWebDataDownloader.h"
#import "AFNetworking.h"

static NSString *const kProgressCallbackKey = @"progress";
static NSString *const kCompletedCallbackKey = @"completed";

@interface TRWebDataDownloader ()

@property (strong, nonatomic) NSOperationQueue *downloadQueue;
@property (weak, nonatomic) NSOperation *lastAddedOperation;
@property (strong, nonatomic) NSMutableDictionary *URLCallbacks;
@property (strong, nonatomic) NSMutableDictionary *HTTPHeaders;
// This queue is used to serialize the handling of the network responses of all the download operation in a single queue
@property (SDDispatchQueueSetterSementics, nonatomic) dispatch_queue_t barrierQueue;

@end

@implementation TRWebDataDownloader


+ (TRWebDataDownloader *)sharedDownloader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        _executionOrder = TRWebDataDownloaderFIFOExecutionOrder;
        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.maxConcurrentOperationCount = 6;
        _URLCallbacks = [NSMutableDictionary new];
        _HTTPHeaders = [NSMutableDictionary dictionaryWithObject:@"image/webp,image/*;q=0.8" forKey:@"Accept"];
        _barrierQueue = dispatch_queue_create("com.hackemist.TRWebDataDownloaderBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        _downloadTimeout = 15.0;
    }
    return self;
}

- (void)dealloc {
    [self.downloadQueue cancelAllOperations];
    SDDispatchQueueRelease(_barrierQueue);
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    if (value) {
        self.HTTPHeaders[field] = value;
    }
    else {
        [self.HTTPHeaders removeObjectForKey:field];
    }
}

- (NSString *)valueForHTTPHeaderField:(NSString *)field {
    return self.HTTPHeaders[field];
}

- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads {
    _downloadQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}

- (NSUInteger)currentDownloadCount {
    return _downloadQueue.operationCount;
}

- (NSInteger)maxConcurrentDownloads {
    return _downloadQueue.maxConcurrentOperationCount;
}


- (id <TRWebDataOperation>)downloadImageWithURL:(NSURL *)url options:(TRWebDataDownloaderOptions)options progress:(TRWebDataDownloaderProgressBlock)progressBlock completed:(TRWebDataDownloaderCompletedBlock)completedBlock {
    
    NSLog(@"show image downloadImageWithURL %@", url);
    __block AFURLConnectionOperation *operation;
    __weak __typeof(self)wself = self;
    
    [self addProgressCallback:progressBlock andCompletedBlock:completedBlock forURL:url createCallback:^{
        NSTimeInterval timeoutInterval = wself.downloadTimeout;
        if (timeoutInterval == 0.0) {
            timeoutInterval = 15.0;
        }
        
        // In order to prevent from potential duplicate caching (NSURLCache + SDImageCache) we disable the cache for image requests if told otherwise
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:(options & TRWebDataDownloaderUseNSURLCache ? NSURLRequestUseProtocolCachePolicy : NSURLRequestReloadIgnoringLocalCacheData) timeoutInterval:timeoutInterval];
        request.HTTPShouldHandleCookies = (options & TRWebDataDownloaderHandleCookies);
        request.HTTPShouldUsePipelining = YES;
        if (wself.headersFilter) {
            request.allHTTPHeaderFields = wself.headersFilter(url, [wself.HTTPHeaders copy]);
        }
        //        else {
        //            request.allHTTPHeaderFields = wself.HTTPHeaders;
        //        }
        operation = [[AFURLConnectionOperation alloc] initWithRequest:request];
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            NSInteger receivedSize = (NSInteger)totalBytesRead;
            NSInteger expectedSize = (NSInteger)totalBytesExpectedToRead;
            TRWebDataDownloader *sself = wself;
            if (!sself) return;
            __block NSArray *callbacksForURL;
            dispatch_sync(sself.barrierQueue, ^{
                callbacksForURL = [sself.URLCallbacks[url] copy];
            });
            for (NSDictionary *callbacks in callbacksForURL) {
                TRWebDataDownloaderProgressBlock callback = callbacks[kProgressCallbackKey];
                if (callback) callback(receivedSize, expectedSize);
            }
        }];
        
        __weak __typeof(operation)woperation = operation;
        [operation setCompletionBlock:^{
            
            TRWebDataDownloader *sself = wself;
            if (!sself) return;
            AFURLConnectionOperation *soperation = woperation;
            if (!soperation) return;
            __block NSArray *callbacksForURL;
            dispatch_barrier_sync(sself.barrierQueue, ^{
                callbacksForURL = [sself.URLCallbacks[url] copy];
                [sself.URLCallbacks removeObjectForKey:url];
            });
            NSError *error = soperation.error;
            NSData *data = soperation.responseData;
            for (NSDictionary *callbacks in callbacksForURL) {
                TRWebDataDownloaderCompletedBlock callback = callbacks[kCompletedCallbackKey];
                if (callback) callback(data, error);
            }
            
        }];
        
        //        operation = [[wself.operationClass alloc] initWithRequest:request
        //                                                          options:options
        //                                                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //                                                             TRWebDataDownloader *sself = wself;
        //                                                             if (!sself) return;
        //                                                             __block NSArray *callbacksForURL;
        //                                                             dispatch_sync(sself.barrierQueue, ^{
        //                                                                 callbacksForURL = [sself.URLCallbacks[url] copy];
        //                                                             });
        //                                                             for (NSDictionary *callbacks in callbacksForURL) {
        //                                                                 TRWebDataDownloaderProgressBlock callback = callbacks[kProgressCallbackKey];
        //                                                                 if (callback) callback(receivedSize, expectedSize);
        //                                                             }
        //                                                         }
        //                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        //                                                            TRWebDataDownloader *sself = wself;
        //                                                            if (!sself) return;
        //                                                            __block NSArray *callbacksForURL;
        //                                                            dispatch_barrier_sync(sself.barrierQueue, ^{
        //                                                                callbacksForURL = [sself.URLCallbacks[url] copy];
        //                                                                if (finished) {
        //                                                                    [sself.URLCallbacks removeObjectForKey:url];
        //                                                                }
        //                                                            });
        //                                                            for (NSDictionary *callbacks in callbacksForURL) {
        //                                                                TRWebDataDownloaderCompletedBlock callback = callbacks[kCompletedCallbackKey];
        //                                                                if (callback) callback(image, data, error, finished);
        //                                                            }
        //                                                        }
        //                                                        cancelled:^{
        //                                                            TRWebDataDownloader *sself = wself;
        //                                                            if (!sself) return;
        //                                                            dispatch_barrier_async(sself.barrierQueue, ^{
        //                                                                [sself.URLCallbacks removeObjectForKey:url];
        //                                                            });
        //                                                        }];
        
        if (wself.username && wself.password) {
            operation.credential = [NSURLCredential credentialWithUser:wself.username password:wself.password persistence:NSURLCredentialPersistenceForSession];
        }
        
        if (options & TRWebDataDownloaderHighPriority) {
            operation.queuePriority = NSOperationQueuePriorityHigh;
        } else if (options & TRWebDataDownloaderLowPriority) {
            operation.queuePriority = NSOperationQueuePriorityLow;
        }
        
        [wself.downloadQueue addOperation:operation];
        if (wself.executionOrder == TRWebDataDownloaderLIFOExecutionOrder) {
            // Emulate LIFO execution order by systematically adding new operations as last operation's dependency
            [wself.lastAddedOperation addDependency:operation];
            wself.lastAddedOperation = operation;
        }
    }];
    
    return (id<TRWebDataOperation>)operation;
}

- (void)addProgressCallback:(TRWebDataDownloaderProgressBlock)progressBlock andCompletedBlock:(TRWebDataDownloaderCompletedBlock)completedBlock forURL:(NSURL *)url createCallback:(TRWebDataNoParamsBlock)createCallback {
    // The URL will be used as the key to the callbacks dictionary so it cannot be nil. If it is nil immediately call the completed block with no image or data.
    if (url == nil) {
        if (completedBlock != nil) {
            completedBlock(nil, nil);
        }
        return;
    }
    
    dispatch_barrier_sync(self.barrierQueue, ^{
        BOOL first = NO;
        if (!self.URLCallbacks[url]) {
            self.URLCallbacks[url] = [NSMutableArray new];
            first = YES;
        }
        
        // Handle single download of simultaneous download request for the same URL
        NSMutableArray *callbacksForURL = self.URLCallbacks[url];
        NSMutableDictionary *callbacks = [NSMutableDictionary new];
        if (progressBlock) callbacks[kProgressCallbackKey] = [progressBlock copy];
        if (completedBlock) callbacks[kCompletedCallbackKey] = [completedBlock copy];
        [callbacksForURL addObject:callbacks];
        self.URLCallbacks[url] = callbacksForURL;
        
        if (first) {
            createCallback();
        }
    });
}

- (void)setSuspended:(BOOL)suspended {
    [self.downloadQueue setSuspended:suspended];
}

@end
