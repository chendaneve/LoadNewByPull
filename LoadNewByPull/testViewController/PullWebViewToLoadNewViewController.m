//
//  PullWebViewToLoadNewViewController.m
//  LoadNewByPull
//
//  Created by huway_iosdev on 16/1/21.
//  Copyright © 2016年 chend. All rights reserved.
//

#import "PullWebViewToLoadNewViewController.h"
#import "MJLoadNewNormalHeader.h"
#import "MJLoadNewNormalFooter.h"

@interface PullWebViewToLoadNewViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation PullWebViewToLoadNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Private Method
- (void)loadData {
    //TODO:data请求
}

//加载新的活动
- (void)loadNewActivityIsUp:(BOOL)isUp {
    
    CGAffineTransform offScreenUp = CGAffineTransformMakeTranslation(0, -self.view.frame.size.height);
    CGAffineTransform offScreenDown = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
    
    //生成新的View并传入数据
    PullWebViewToLoadNewViewController *toDetailVC = [[PullWebViewToLoadNewViewController alloc] init];
    
    //TODO:数据相关
    //    toDetailVC.data = data;
    
    
    UIView *toView = toDetailVC.view;
    toView.frame = self.view.bounds;
    
    //生成原View截图并添加到主View上
    UIView *fromView = [self.view snapshotViewAfterScreenUpdates:YES];
    [self.view addSubview:fromView];
    
    //将toView放置到屏幕之外并添加到主View上
    toView.transform = isUp ? offScreenUp : offScreenDown;
    [self.view addSubview:toView];
    [self addChildViewController:toDetailVC];
    
    //动画开始
    [UIView animateWithDuration:0.2 animations:^{
        //上一篇：fromView下滑出屏幕，新View滑入屏幕
        //下一篇：fromView上滑出屏幕，新View滑入屏幕
        fromView.transform = isUp ? offScreenDown : offScreenUp;
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //动画完成后清理底层webView，以及滑出屏幕的fromView，这里也有问题，多次加载新文章会每次留一层UIView 待解决
        [self.webView removeFromSuperview];
        [fromView removeFromSuperview];
    }];
}



#pragma mark - Getter
- (UIWebView*)webView {
    if (_webView) {
        return _webView;
    }
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    
    __weak typeof(self) _self = self;
    _webView.scrollView.header = [MJLoadNewNormalHeader headerWithRefreshingBlock:^{
        [_self loadNewActivityIsUp:YES];
    }];
    _webView.scrollView.footer = [MJLoadNewNormalFooter footerWithRefreshingBlock:^{
        [_self loadNewActivityIsUp:NO];
    }];
    
    [_webView loadHTMLString:@"" baseURL:[NSURL URLWithString:@""]];
    return _webView;
}

@end


