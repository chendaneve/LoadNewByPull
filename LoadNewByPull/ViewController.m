//
//  ViewController.m
//  LoadNewByPull
//
//  Created by huway_iosdev on 16/1/20.
//  Copyright © 2016年 chend. All rights reserved.
//

#import "ViewController.h"
#import "PullTableViewToLoadViewController.h"
#import "PullWebViewToLoadNewViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上翻-下翻";
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //    [self.delegate removeNavButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    }
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.textLabel.text = dic[@"name"];
    NSURL *imageURL = [NSURL URLWithString: dic[@"imageUrl"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            cell.imageView.image = [UIImage imageWithData:imageData];
        });
    });
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PullTableViewToLoadViewController *vc = [[PullTableViewToLoadViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    PullWebViewToLoadNewViewController *vc = [[PullWebViewToLoadNewViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter
- (UITableView*)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    return _tableView;
}

- (NSArray*)dataArr {
    if (_dataArr) {
        return _dataArr;
    }
    _dataArr = @[@{@"name":@"详情页为tableView-MJRefresh",
                   @"imageUrl": @"http://ww1.sinaimg.cn/square/9e477db1gw1euzu61tt5cj20c707s74m.jpg"},
                 @{@"name":@"详情页为webView-MJRefresh",
                   @"imageUrl": @"http://ww2.sinaimg.cn/square/9e477db1gw1euzu61yi07j20c8083mxv.jpg"}];
    return _dataArr;
}
@end
