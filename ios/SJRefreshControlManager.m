//
//  SJRefreshControlManager.m
//  ZmRefresh
//
//  Created by lijun on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "SJRefreshControlManager.h"
#import "SJRefreshControl.h"

@implementation SJRefreshControlManager
RCT_EXPORT_MODULE();

- (SJRefreshControl *)view
{
  return [SJRefreshControl new];
}

@end
