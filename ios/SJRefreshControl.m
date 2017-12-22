//
//  SJRefreshControl.m
//  ZmRefresh
//
//  Created by lijun on 2017/12/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "SJRefreshControl.h"
#import "SJRefreshView.h"

@implementation SJRefreshControl

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.refreshView = [[SJRefreshView alloc] init];
    self.followScroll = NO;
  }
  return self;
}

@end
