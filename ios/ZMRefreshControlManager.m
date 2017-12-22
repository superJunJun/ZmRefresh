//
//  ZMRefreshControlManager.m
//  ZmRefresh
//
//  Created by lijun on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ZMRefreshControlManager.h"
#import "ZMRefreshControl.h"

@implementation ZMRefreshControlManager

RCT_EXPORT_MODULE();

- (ZMRefreshControl *)view {
  return [ZMRefreshControl new];
}

RCT_EXPORT_VIEW_PROPERTY(onRefresh, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(refreshing, BOOL)

@end
