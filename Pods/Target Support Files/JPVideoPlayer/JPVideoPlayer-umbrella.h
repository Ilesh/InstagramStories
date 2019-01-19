#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JPResourceLoadingRequestTask.h"
#import "JPVideoPlayer.h"
#import "JPVideoPlayerCache.h"
#import "JPVideoPlayerCacheFile.h"
#import "JPVideoPlayerCachePath.h"
#import "JPVideoPlayerCompat.h"
#import "JPVideoPlayerControlViews.h"
#import "JPVideoPlayerDownloader.h"
#import "JPVideoPlayerKit.h"
#import "JPVideoPlayerManager.h"
#import "JPVideoPlayerProtocol.h"
#import "JPVideoPlayerResourceLoader.h"
#import "JPVideoPlayerSupportUtils.h"
#import "UITableView+WebVideoCache.h"
#import "UITableViewCell+WebVideoCache.h"
#import "UIView+WebVideoCache.h"

FOUNDATION_EXPORT double JPVideoPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char JPVideoPlayerVersionString[];

