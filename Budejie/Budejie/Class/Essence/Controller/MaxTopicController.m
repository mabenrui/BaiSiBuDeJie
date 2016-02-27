//
//  MaxWordController.m
//  My百思不得姐
//
//  Created by Max on 16/2/20.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxTopicController.h"
#import "MaxTopicModel.h"
#import "MaxTopicCell.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

@interface MaxTopicController ()

//帖子数组
@property (nonatomic, copy) NSMutableArray *topics;
//当前页
@property (nonatomic, assign) NSInteger page;
//maxtime 加载分页需要这个参数
@property (nonatomic, copy) NSString *maxtime;

@end

static NSString *const topic = @"topic";

@implementation MaxTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableView];
    
    [self setRefresh];
}

- (void)setTableView
{
    self.view.backgroundColor = GlobalBg;
    
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = MaxTitleViewH + MaxTitleViewY;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //vc的tableView滚动条的内边距和tableView的内边距一致
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MaxTopicCell class]) bundle:nil] forCellReuseIdentifier:topic];
}


- (NSMutableArray *)topics{
    if (nil == _topics) {
        _topics = [NSMutableArray array];
    }
    
    return _topics;
}

- (void)setRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadNewTopics{
    
    //结束上啦
    [self.tableView.mj_footer endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    [[AFHTTPSessionManager manager] GET:BaseApi parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        //保存maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        NSArray *topics = [MaxTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics removeAllObjects];
        [self.topics addObjectsFromArray:topics];
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
        
        //清空页码
        //如果这行放在这个方法的第一行会出现问题
        //如果当前是第5页,我突然想刷新,下拉刷新(页码变0),但是加载失败了...
        //可是我刚刚明明在第5页,这个时候我再上啦加载,却从第1页开始加数据了....
        self.page = 0;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}
- (void)loadMoreTopics{
    //结束下拉
    [self.tableView.mj_header endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @"29";
    
    NSInteger page = self.page + 1;
    params[@"page"] = @(page);
    params[@"maxtime"] = self.maxtime;
    params[@"type"] = @(self.type);
    [[AFHTTPSessionManager manager] GET:BaseApi parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        //保存maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        NSArray *topics = [MaxTopicModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:topics];
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
        //请求成功时,页码+1
        self.page = page;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.tableView.mj_footer.hidden = self.topics.count == 0;
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MaxTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:topic];
    
    MaxTopicModel *model = self.topics[indexPath.row];
    
    cell.topic = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MaxTopicModel *topic = self.topics[indexPath.row];

    return topic.rowHeight;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    NSLog(@"didReceiveMemoryWarning");
}

@end
