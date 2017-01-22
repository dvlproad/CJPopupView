/*
 * This file is part of the TRWebData package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "TRWebDataCompat.h"
#import "TRWebDataOperation.h"
#import "TRWebDataDownloader.h"
#import "TRWebDataCache.h"

typedef NS_OPTIONS(NSUInteger, TRWebDataOptions) {
    /**
     * By default, when a URL fail to be downloaded, the URL is blacklisted so the library won't keep trying.
     * This flag disable this blacklisting.
     */
    TRWebDataRetryFailed = 1 << 0,
    
    /**
     * By default, image downloads are started during UI interactions, this flags disable this feature,
     * leading to delayed download on UIScrollView deceleration for instance.
     */
    TRWebDataLowPriority = 1 << 1,
    
    /**
     * This flag disables on-disk caching
     */
    TRWebDataCacheMemoryOnly = 1 << 2,
    
    /**
     * This flag enables progressive download, the image is displayed progressively during download as a browser would do.
     * By default, the image is only displayed once completely downloaded.
     */
    TRWebDataProgressiveDownload = 1 << 3,
    
    /**
     * Even if the image is cached, respect the HTTP response cache control, and refresh the image from remote location if needed.
     * The disk caching will be handled by NSURLCache instead of TRWebData leading to slight performance degradation.
     * This option helps deal with images changing behind the same request URL, e.g. Facebook graph api profile pics.
     * If a cached image is refreshed, the completion block is called once with the cached image and again with the final image.
     *
     * Use this flag only if you can't make your URLs static with embeded cache busting parameter.
     */
    TRWebDataRefreshCached = 1 << 4,
    
    /**
     * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
     * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
     */
    TRWebDataContinueInBackground = 1 << 5,
    
    /**
     * Handles cookies stored in NSHTTPCookieStore by setting
     * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
     */
    TRWebDataHandleCookies = 1 << 6,
    
    /**
     * Enable to allow untrusted SSL ceriticates.
     * Useful for testing purposes. Use with caution in production.
     */
    TRWebDataAllowInvalidSSLCertificates = 1 << 7,
    
    /**
     * By default, image are loaded in the order they were queued. This flag move them to
     * the front of the queue and is loaded immediately instead of waiting for the current queue to be loaded (which
     * could take a while).
     */
    TRWebDataHighPriority = 1 << 8,
    
    /**
     * By default, placeholder images are loaded while the image is loading. This flag will delay the loading
     * of the placeholder image until after the image has finished loading.
     */
    TRWebDataDelayPlaceholder = 1 << 9,
    
    /**
     * We usually don't call transformDownloadedImage delegate method on animated images,
     * as most transformation code would mangle it.
     * Use this flag to transform them anyway.
     */
    TRWebDataTransformAnimatedImage = 1 << 10,
    /**
     */
    TRWebDataWaitSaveDiskCompletion = 1 << 11,
};

typedef void(^TRWebDataCompletionBlock)(NSData *data, NSError *error, TRWebDataCacheType cacheType, NSURL *imageURL);

//typedef void(^TRWebDataCompletionWithFinishedBlock)(NSData *data, NSError *error, TRWebDataCacheType cacheType, BOOL finished, NSURL *imageURL);

typedef NSString *(^TRWebDataCacheKeyFilterBlock)(NSURL *url);


@class TRWebDataManager;

@protocol TRWebDataManagerDelegate <NSObject>

@optional

/**
 * Controls which image should be downloaded when the image is not found in the cache.
 *
 * @param imageManager The current `TRWebDataManager`
 * @param imageURL     The url of the image to be downloaded
 *
 * @return Return NO to prevent the downloading of the image on cache misses. If not implemented, YES is implied.
 */
- (BOOL)dataManager:(TRWebDataManager *)dataManager shouldDownloadDataForURL:(NSURL *)dataURL;


@end

/**
 * The TRWebDataManager is the class behind the UIImageView+WebCache category and likes.
 * It ties the asynchronous downloader (TRWebDataDownloader) with the image cache store (TRWebDataCache).
 * You can use this class directly to benefit from web image downloading with caching in another context than
 * a UIView.
 *
 * Here is a simple example of how to use TRWebDataManager:
 *
 * @code
 
 TRWebDataManager *manager = [TRWebDataManager sharedManager];
 [manager downloadImageWithURL:imageURL
 options:0
 progress:nil
 completed:^(UIImage *image, NSError *error, TRWebDataCacheType cacheType, BOOL finished, NSURL *imageURL) {
 if (image) {
 // do something with image
 }
 }];
 
 * @endcode
 */
@interface TRWebDataManager : NSObject

@property (weak, nonatomic) id <TRWebDataManagerDelegate> delegate;

@property (strong, nonatomic, readonly) TRWebDataCache *dataCache;
@property (strong, nonatomic, readonly) TRWebDataDownloader *imageDownloader;


/**
 * Returns global TRWebDataManager instance.
 *
 * @return TRWebDataManager shared instance
 */
+ (TRWebDataManager *)sharedManager;

/**
 * The cache filter is a block used each time SDWebImageManager need to convert an URL into a cache key. This can
 * be used to remove dynamic part of an image URL.
 *
 * The following example sets a filter in the application delegate that will remove any query-string from the
 * URL before to use it as a cache key:
 *
 * @code
 
 [[SDWebImageManager sharedManager] setCacheKeyFilter:^(NSURL *url) {
 url = [[NSURL alloc] initWithScheme:url.scheme host:url.host path:url.path];
 return [url absoluteString];
 }];
 
 * @endcode
 */
@property (nonatomic, copy) TRWebDataCacheKeyFilterBlock cacheKeyFilter;

/**
 * Downloads the image at the given URL if not present in cache or return the cached version otherwise.
 *
 * @param url            The URL to the image
 * @param options        A mask to specify options to use for this request
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed.
 *
 *   This parameter is required.
 *
 *   This block has no return value and takes the requested UIImage as first parameter.
 *   In case of error the image parameter is nil and the second parameter may contain an NSError.
 *
 *   The third parameter is an `TRWebDataCacheType` enum indicating if the image was retrived from the local cache
 *   or from the memory cache or from the network.
 *
 *   The last parameter is set to NO when the TRWebDataProgressiveDownload option is used and the image is
 *   downloading. This block is thus called repetidly with a partial image. When image is fully downloaded, the
 *   block is called a last time with the full image and the last parameter set to YES.
 *
 * @return Returns an NSObject conforming to TRWebDataOperation. Should be an instance of TRWebDataDownloaderOperation
 */
- (id <TRWebDataOperation>)downloadDataWithURL:(NSURL *)url
                                         options:(TRWebDataOptions)options
                                        progress:(TRWebDataDownloaderProgressBlock)progressBlock
                                       completed:(TRWebDataCompletionBlock)completedBlock;


/**
 * Cancel all current opreations
 */
- (void)cancelAll;

/**
 * Check one or more operations running
 */
- (BOOL)isRunning;


@end
