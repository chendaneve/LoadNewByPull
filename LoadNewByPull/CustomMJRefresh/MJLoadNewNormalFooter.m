//
//  MJLoadNewNormalFooter.m
//  huodonghui
//
//  Created by huway_iosdev on 16/1/20.
//  Copyright © 2016年 geone. All rights reserved.
//

#import "MJLoadNewNormalFooter.h"



@interface MJLoadNewNormalFooter()
{
    __unsafe_unretained UIImageView *_arrowView;
}
//@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation MJLoadNewNormalFooter
#pragma mark - 构造方法
+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJLoadNewNormalFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    
    [cmp updateTitle:@"载入下一篇"];
    [cmp setTitle:@"已是最后一个" forState:MJRefreshStateNoMoreData];
    return cmp;
}
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MJLoadNewNormalFooter *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    
    [cmp updateTitle:@"载入下一篇"];
    [cmp setTitle:@"已是最后一个" forState:MJRefreshStateNoMoreData];
    return cmp;
}

#pragma mark - 懒加载子控件
- (UIImageView *)arrowView
{
    if (!_arrowView) {
        UIImage *image = [UIImage imageNamed:MJRefreshSrcName(@"arrow.png")] ?: [UIImage imageNamed:MJRefreshFrameworkSrcName(@"arrow.png")];
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}

#pragma mark - 公共方法
- (void)updateTitle:(NSString*)title {
    [self setTitle:title forState:MJRefreshStateIdle];
    [self setTitle:title forState:MJRefreshStatePulling];
    [self setTitle:title forState:MJRefreshStateRefreshing];
}

#pragma makr - 重写父类的方法
- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        arrowCenterX -= 100;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.mj_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            
            self.arrowView.hidden = NO;
        } else {
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
        }
    } else if (state == MJRefreshStatePulling) {
        self.arrowView.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformIdentity;
        }];
    } else if (state == MJRefreshStateRefreshing) {
        self.arrowView.hidden = YES;
    } else if (state == MJRefreshStateNoMoreData) {
        self.arrowView.hidden = YES;
    }
}

@end
