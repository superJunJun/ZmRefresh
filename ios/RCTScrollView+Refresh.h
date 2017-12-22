//
//  RCTScrollView+Refresh.h
//  ZmRefresh
//
//  Created by lijun on 2017/12/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//
#import <React/RCTScrollView.h>
#import "ZMRefreshControl.h"
@interface UIScrollView (Refresh)

@property (nonatomic, strong) ZMRefreshControl * rnRefreshView;

@end

@interface RCTScrollView (Refresh)

@end
