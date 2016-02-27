//
//  MaxRecommendTagController.m
//  My百思不得姐
//
//  Created by Max on 16/2/18.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxRecommendTagController.h"
#import "MaxRecommendTagModel.h"
#import "MaxRecommendTagCell.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>

@interface MaxRecommendTagController ()

@property (nonatomic, copy) NSMutableArray *tags;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

static NSString *RecommendTag = @"tag";

@implementation MaxRecommendTagController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableView];
    
    [self loadTags];
}

- (void)setTableView{
    self.title = @"推荐标签";
    self.view.backgroundColor = GlobalBg;
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MaxRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:RecommendTag];
}

- (void)loadTags{
    //指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    //发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"c"] = @"topic";
    params[@"action"] = @"sub";
    
    [self.manager GET:BaseApi parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        LLog(@"%@", responseObject);
        self.tags = [MaxRecommendTagModel mj_objectArrayWithKeyValuesArray:responseObject];
        //请求完成取消遮罩
        [SVProgressHUD dismiss];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"请求数据错误"];
    }];
}

- (NSMutableArray *)tags{
    if (_tags == nil) {
        _tags = [NSMutableArray array];
    }
    
    return _tags;
}
- (AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MaxRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:RecommendTag forIndexPath:indexPath];
    cell.recommendTag = self.tags[indexPath.row];
    
    return cell;
}

- (void)dealloc{
    
    [self.manager.operationQueue cancelAllOperations];
}
 
@end
 
