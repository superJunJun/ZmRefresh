//
//  RCTScrollView+Refresh.m
//  ZmRefresh
//
//  Created by lijun on 2017/12/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "RCTScrollView+Refresh.h"
#import <React/UIView+React.h>
#import <React/RCTAssert.h>
#import <React/RCTUtils.h>
#import <objc/runtime.h>

@implementation UIScrollView (Refresh)


/**
 下拉刷新
 */
- (void)setRnRefreshView:(ZMRefreshControl *)rnRefreshView {
  objc_setAssociatedObject(self, @selector(rnRefreshView), rnRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)rnRefreshView {
  return objc_getAssociatedObject(self, @selector(rnRefreshView));
}

- (void)setRefreshViewControl:(ZMRefreshControl *)refreshView {
  if (self.rnRefreshView) {
    [self.rnRefreshView removeFromSuperview];
  }
  self.rnRefreshView = refreshView;
  [self addSubview:refreshView];
}

@end


@implementation RCTScrollView (Refresh)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    RCTSwapInstanceMethods([self class], @selector(insertReactSubview:atIndex:), @selector(replace_insertReactSubView:atIndex:));
    
    RCTSwapInstanceMethods([self class], @selector(removeReactSubview:), @selector(replace_removeReactSubview:));
  });
}

- (void)replace_insertReactSubView:(UIView *)view atIndex:(NSInteger )atIndex {
  if ([view isKindOfClass:[ZMRefreshControl class]]) {
    [super insertReactSubview:view atIndex:atIndex];
    
    if ([self.scrollView respondsToSelector:@selector(setRefreshViewControl:)]) {
      [self.scrollView performSelector:@selector(setRefreshViewControl:) withObject:view];
    }
  } else {
    [self replace_insertReactSubView:view atIndex:atIndex];
  }
}

- (void)replace_removeReactSubview:(UIView *)subView {
  if ([subView isKindOfClass:[ZMRefreshControl class]]) {
    [super removeReactSubview:subView];
    if ([self.scrollView respondsToSelector:@selector(setRefreshViewControl:)]) {
      [self.scrollView performSelector:@selector(setRefreshViewControl:) withObject:nil];
    }
  } else {
    [self replace_removeReactSubview:subView];
  }
}

@end
