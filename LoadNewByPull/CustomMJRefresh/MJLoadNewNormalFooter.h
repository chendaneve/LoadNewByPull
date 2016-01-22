//
//  MJLoadNewNormalFooter.h
//  huodonghui
//
//  Created by huway_iosdev on 16/1/20.
//  Copyright © 2016年 geone. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface MJLoadNewNormalFooter : MJRefreshBackStateFooter

@property (weak, nonatomic, readonly) UIImageView *arrowView;

- (void)updateTitle:(NSString*)title;
@end
