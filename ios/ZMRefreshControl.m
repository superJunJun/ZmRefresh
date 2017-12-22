//
//  ZMRefreshControl.m
//  ZmRefresh
//
//  Created by lijun on 2017/12/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ZMRefreshControl.h"
#import <React/RCTScrollView.h>
#import "RCTScrollView+Refresh.h"

#define kNavigationBarHeight 44

@interface ZMRefreshControl()<UIScrollViewDelegate>

@property (nonatomic, assign) UIEdgeInsets originInset;

@end

@implementation ZMRefreshControl {
  BOOL _initRefreshingState;
  BOOL _isInitialRender;
  BOOL _currentRefreshingState;
}

- (instancetype )init {
  if ([super init]) {
    self.frame = CGRectMake(0, 0, 0, 0);
    self.originInset = UIEdgeInsetsZero;
    self.triggerDistance = kNavigationBarHeight;
    
    _currentRefreshingState = NO;
    self.followScroll = YES;
  }
  return self;
}

-  (void)setRefreshView:(ZMRefreshView<ZMRefreshMotionProtocol> *)refreshView {
  if (self.refreshView) {
    [self.refreshView removeFromSuperview];
  }
  _refreshView = refreshView;
  [self addSubview:refreshView];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  if ([self.superview isKindOfClass:[UIScrollView class]]) {
    self.subScrollView = (UIScrollView *)self.superview;
    
    RCTScrollView *reactScrollView = (RCTScrollView *)self.subScrollView.superview;
    if ([reactScrollView respondsToSelector:@selector(addScrollListener:)]) {
      [reactScrollView addScrollListener:self];
    }
    
    CGFloat scrollViewWidth = self.subScrollView.frame.size.width;
    CGFloat refreshViewHeight = self.refreshView.frame.size.height;

    if (!self.followScroll) {
      self.frame = CGRectMake(reactScrollView.frame.origin.x, reactScrollView.frame.origin.y, scrollViewWidth, refreshViewHeight);
      [self.subScrollView.rnRefreshView removeFromSuperview];
      reactScrollView.backgroundColor = [UIColor clearColor];
      [reactScrollView.superview insertSubview:self.subScrollView.rnRefreshView belowSubview:reactScrollView];
    } else {
      self.frame = CGRectMake(0, -refreshViewHeight, scrollViewWidth, refreshViewHeight);
      [self.refreshView layoutSubviews];
    }
  }
}

#pragma mark -ZMRefreshMotionProtocol
/*
 * 松手前的拖拽
 * 松手后刷新
 * 开始刷新
 * 结束刷新
 * 刷新过程完成回到原点
 */

- (void)draggingBeforeRelease:(CGFloat )offSetY {
  if ([self.refreshView respondsToSelector: @selector(draggingBeforeReleaseWithOffset:)]) {
    [self.refreshView draggingBeforeReleaseWithOffset:offSetY];
  }
}

- (void)releaseToLoad:(CGFloat )offSetY {
  if ([self.refreshView respondsToSelector:@selector(draggingBeforeReleaseWithOffset:)]) {
    [self.refreshView draggingBeforeReleaseWithOffset:offSetY];
  }
}

- (void)releaseAndBeginRefreshing {
  if ([self.refreshView respondsToSelector:@selector(releaseAndBeginRefreshing)]) {
    [self.refreshView releaseAndBeginRefreshing];
  }
}

- (void)stopRefreshingAndBackToOrigin
{
  if ([self.refreshView respondsToSelector: @selector(stopRefreshingAndBackToOrigin)]) {
    [self.refreshView stopRefreshingAndBackToOrigin];
  }
}

- (void)endAll
{
  if ([self.refreshView respondsToSelector: @selector(endAll)]) {
    [self.refreshView endAll];
  }
}

/*
 * scrollview代理的对应代理方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (!_currentRefreshingState ) {
    if (scrollView.contentOffset.y <= -self.triggerDistance - scrollView.contentInset.top) {
      [self releaseToLoad: -scrollView.contentOffset.y - _originInset.top];
    } else {
      [self draggingBeforeRelease: -scrollView.contentOffset.y - _originInset.top];
    }
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  if (scrollView.contentOffset.y <= -self.triggerDistance - scrollView.contentInset.top) {
    [self beginRefreshing];
    _currentRefreshingState = self.refreshing;

    if (_onRefresh) {
      _onRefresh(nil);
    }
  }
}

/*
 * 刷新
 */
- (void)beginRefreshing {
  if (!_currentRefreshingState) {
    _currentRefreshingState = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
      [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.subScrollView.contentInset = UIEdgeInsetsMake(_originInset.top + self.triggerDistance, _originInset.left, _originInset.bottom - self.triggerDistance, _originInset.right);
        [self.subScrollView setContentOffset:CGPointMake(0, -self.subScrollView.contentInset.top) animated:NO];
                       }
       completion:^(BOOL finished) {
         [self releaseAndBeginRefreshing];
       }];
    });
  }
}

/*
 * 刷新结束
 */
- (void)endRefreshing
{
  [self stopRefreshingAndBackToOrigin];
  [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
   {
     self.subScrollView.contentInset = _originInset;
     
   } completion:^(BOOL finished) {
     _currentRefreshingState = NO;
     [self endAll];
   }];
}

- (void)setRefreshing:(BOOL)refreshing
{
  if (!refreshing && _initRefreshingState) {
    _initRefreshingState = NO;
  }
  
  if (_currentRefreshingState != refreshing) {
    
    if (refreshing) {
      if (_isInitialRender) {
        _initRefreshingState = refreshing;
      } else {
        [self beginRefreshing];
      }
    } else {
      [self endRefreshing];
    }
  }
}

@end
