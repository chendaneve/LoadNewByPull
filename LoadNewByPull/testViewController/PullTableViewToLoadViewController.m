//
//  PullTableViewToLoadViewController.m
//  LoadNewByPull
//
//  Created by huway_iosdev on 16/1/21.
//  Copyright © 2016年 chend. All rights reserved.
//

#import "PullTableViewToLoadViewController.h"
#import "MJLoadNewNormalHeader.h"
#import "MJLoadNewNormalFooter.h"

@interface PullTableViewToLoadViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJLoadNewNormalHeader *headerRefreshView;
@property (nonatomic, strong) MJLoadNewNormalFooter *footerRefreshView;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSInteger numOfData;

@end

@implementation PullTableViewToLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"内容为TableView";
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    
    self.numOfData = 2;
    
    [self loadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.index== 0) {//已经是第一篇了,
        [_headerRefreshView updateTitle:@"已经是第一篇了"];
        [_footerRefreshView updateTitle:@"载入下一篇"];
    }
    else if (self.index >= self.numOfData-1) { //已经是最后一篇了
        [_headerRefreshView updateTitle:@"载入上一篇"];
        [_footerRefreshView updateTitle:@"已经是最后一篇了"];
    }
    else {
        [_headerRefreshView updateTitle:@"载入上一篇"];
        [_footerRefreshView updateTitle:@"载入下一篇"];
    }
}

#pragma mark - Private Method
- (void)loadData {
    //TODO:data请求
}

//加载新的活动
- (void)loadNewActivityIsUp:(BOOL)isUp {
    if (isUp && self.index== 0) {//已经是第一篇了,
        return;
    }
    else if (!isUp && self.index >= self.numOfData-1) { //已经是最后一篇了
        return;
    }
    
    
    if (isUp) {
        self.index--;
    }
    else {
        self.index++;
    }
    
    CGAffineTransform offScreenUp = CGAffineTransformMakeTranslation(0, -self.view.frame.size.height);
    CGAffineTransform offScreenDown = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
    
    //生成新的View并传入数据
    PullTableViewToLoadViewController *toDetailVC = [[PullTableViewToLoadViewController alloc] init];
    
    //TODO:数据相关
//    toDetailVC.data = data;
    toDetailVC.index = self.index;
    
    
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
        //动画完成后清理底层tableView，以及滑出屏幕的fromView，这里也有问题，多次加载新文章会每次留一层UIView 待解决
        [self.tableView removeFromSuperview];
        [fromView removeFromSuperview];
    }];
}



#pragma mark - Getter
- (UITableView*)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner"]];
    
    _tableView.header = self.headerRefreshView;
    _tableView.footer = self.footerRefreshView;
    return _tableView;
}

- (MJLoadNewNormalHeader*)headerRefreshView {
    if (_headerRefreshView) {
        return _headerRefreshView;
    }
    __weak typeof(self) _self = self;
    _headerRefreshView = [MJLoadNewNormalHeader headerWithRefreshingBlock:^{
        if (_self.index == 0) {
            [_headerRefreshView updateTitle:@"已经是第一篇了"];
            [_self.tableView.header endRefreshing];
            return;
        }
        [_headerRefreshView updateTitle:@"载入上一篇"];
        [_self.tableView.header endRefreshing];
        [_self loadNewActivityIsUp:YES];
    }];

    return _headerRefreshView;
}

- (MJLoadNewNormalFooter*)footerRefreshView {
    if (_footerRefreshView) {
        return _footerRefreshView;
    }
    __weak typeof(self) _self = self;
    _footerRefreshView = [MJLoadNewNormalFooter footerWithRefreshingBlock:^{
        if (self.index >= self.numOfData-1) { //已经是最后一篇了
            [_headerRefreshView updateTitle:@"已经是最后一篇了"];
            [_self.tableView.footer endRefreshing];
            return;
        }
        [_self.tableView.footer endRefreshing];
        [_self loadNewActivityIsUp:NO];
    }];
    
    return _footerRefreshView;
}
@end

