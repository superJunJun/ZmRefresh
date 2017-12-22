//
//  ZMRefreshView.h
//  ZmRefresh
//
//  Created by lijun on 2017/12/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZMRefreshMotionProtocol <NSObject>

- (void)draggingBeforeReleaseWithOffset:(CGFloat)offset;
- (void)releaseAndBeginRefreshing;
- (void)stopRefreshingAndBackToOrigin;
- (void)endAll;
- (CGFloat)triggerDistance;

@end

@interface ZMRefreshView : UIView

@end
