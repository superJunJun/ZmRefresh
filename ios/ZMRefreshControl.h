//
//  ZMRefreshControl.h
//  ZmRefresh
//
//  Created by lijun on 2017/12/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
#import "ZMRefreshView.h"

@interface ZMRefreshControl : UIView

@property (nonatomic,assign) BOOL refreshing;
@property (nonatomic,assign) BOOL followScroll;
@property (nonatomic,copy) RCTDirectEventBlock onRefresh;

@property (nonatomic,assign) CGFloat triggerDistance;
@property (nonatomic,weak) UIScrollView *subScrollView;
@property (nonatomic,weak) ZMRefreshView <ZMRefreshMotionProtocol> *refreshView;

@end
