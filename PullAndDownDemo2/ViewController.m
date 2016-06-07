//
//  ViewController.m
//  PullAndDownDemo2
//
//  Created by 马浩哲 on 16/6/7.
//  Copyright © 2016年 junanxin. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WKWebView.h>
#import "MJRefresh.h"
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIScrollView *titleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadSubviews];
}

-(void)loadSubviews
{
    _titleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    UILabel *firstTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    firstTitle.text = @"第一部分";
    [_titleView addSubview:firstTitle];
    UILabel *secondTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 160, 44)];
    secondTitle.text = @"第二部分";
    [_titleView addSubview:secondTitle];
    
    firstTitle.textAlignment = NSTextAlignmentCenter;
    secondTitle.textAlignment = NSTextAlignmentCenter;
    
    self.navigationItem.titleView = _titleView;
    
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT*2)];
    [self.view addSubview:_bgView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_bgView addSubview:_tableView];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT+64, SCREENWIDTH, SCREENHEIGHT-64)];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    _scrollView = _webView.scrollView;
    _scrollView.delegate = self;
    [_bgView addSubview:_webView];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"下拉进入上一页" forState:MJRefreshStateIdle];
    [header setTitle:@"释放进入上一页" forState:MJRefreshStatePulling];
    [header setTitle:@"正在进入上一页" forState:MJRefreshStateRefreshing];
    _webView.scrollView.mj_header = header;
}

-(void)loadNewData
{
    [_webView.scrollView.mj_header endRefreshing];
    [UIView animateWithDuration:0.8 animations:^{
        CGRect frame = _bgView.frame;
        frame.origin.y = 0;
        _bgView.frame = frame;
        _titleView.contentOffset = CGPointMake(0, 0);
    }];
}

#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%li",indexPath.row];
    return cell;
}

#pragma mark - scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        
        if (_tableView.contentOffset.y - _tableView.contentSize.height +SCREENHEIGHT > 100 && scrollView.isDragging == NO) {
            [UIView animateWithDuration:0.8 animations:^{
                CGRect frame = _bgView.frame;
                frame.origin.y = -SCREENHEIGHT;
                _bgView.frame = frame;
                _titleView.contentOffset = CGPointMake(0, 44);
            }];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
