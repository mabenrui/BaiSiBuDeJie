//
//  MaxRecommendViewController.m
//  My百思不得姐
//
//  Created by Max on 16/2/6.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxRecommendViewController.h"
#import "MaxRecommendTypeModel.h"
#import "MaxRecommendUserModel.h"
#import "MaxRecommendTypeCell.h"
#import "MaxRecommendUserCell.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <MJRefresh.h>

@interface MaxRecommendViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) NSMutableArray *types;
@property (nonatomic, copy) NSMutableDictionary *params;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, weak) IBOutlet UITableView *typeTableView;
@property (nonatomic, weak) IBOutlet UITableView *userTableView;

@end

@implementation MaxRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableView];
    
    //MJ刷新控件
    [self setRefresh];
    
    //加载左侧type
    [self loadLeftType];
}

- (void)loadLeftType{
    //发送请求
    //这些参数key和value参考接口文档
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    
    NSString *urlString = @"http://api.budejie.com/api/api_open.php";
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self.manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //隐藏指示器
        [SVProgressHUD dismiss];
        
        //这个方法是MJExtension的,字典数组转化成模型数组
        self.types = [MaxRecommendTypeModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //刷新tableView
        [self.typeTableView reloadData];
        
        //默认选中第一个type
        [self.typeTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        //请求默认选中的type对应的数据
        [self.userTableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //指示器显示加载失败
        [SVProgressHUD showErrorWithStatus:@"加载信息失败"];
    }];
}

- (AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
}

- (void)setTableView{
    self.view.backgroundColor = GlobalBg;
    self.title = @"推荐关注";
    
    //注册
    [self.typeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MaxRecommendTypeCell class]) bundle:nil] forCellReuseIdentifier:@"types"];
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MaxRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:@"user"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.typeTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.typeTableView.contentInset;
    self.userTableView.rowHeight = 70;
    
    //显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
}
- (void)setRefresh{
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.userTableView.mj_footer.hidden = YES;
    
}
#pragma mark  ========== 加载用户数据
- (void)loadNew{
    MaxRecommendTypeModel *type = self.types[self.typeTableView.indexPathForSelectedRow.row];
    
    //第一次请求时,设置当前页码1
    type.currentPage = 1;
    
    //清空type下的数据,防止多次下拉刷新加载同样的数据
    [type.users removeAllObjects];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(type.id);
    params[@"page"] = @(type.currentPage);
    self.params = params;
    
    NSString *urlString = @"http://api.budejie.com/api/api_open.php";
    [self.manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //发请求获取数据后,追加数据
        //因为会不断追加数据,可能内存消耗越来越多
        //不过SDWebImage内部已经有对应的处理:系统会发出内存警告的通知,SDWebImage会清空所有缓存
        //清空缓存调用的是clearMemory方法,在SDImageCache.h中,可以搜索UIApplicationDidReceiveMemoryWarningNotification
        NSArray *users = [MaxRecommendUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [type.users addObjectsFromArray:users];
        
        //保存对应类别的数据总数
        type.total = [responseObject[@"total"] integerValue];
        
        //这行是为了解决快速点击多个type时,只处理最后一个type
        //比如点击typeA后,又迅速的点击了typeB,这时只处理typeB数据
        //因为点击typeA后,上面会生成一个params(认为是paramsA),然后赋值给self.params
        //然后typeA的success的blockA会复制一份paramsA在blockA内部,等待请求成功时,会执行blockA
        //在blockA执行之前,用户又迅速点击了typeB,自然也就生成了paramsB,这时self.params再次被赋值,覆盖了上次赋值
        //这时,blockA里面的self.params和params已经不相等了,所以blockA会return
        //这行代码没有放在block的首行,是为了不浪费请求来的数据,这样放在reload之前即可
        if (![self.params isEqualToDictionary:params]) return;
        
        [self.userTableView reloadData];
        
        //结束header刷新
        [self.userTableView.mj_header endRefreshing];
        
        //这里检测footer是因为,可能全部数据只有一页
        [self checkFooterStatus];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (![self.params isEqualToDictionary:params]) return;
        
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
        
        [self.userTableView.mj_header endRefreshing];
    }];
}
- (void)loadMore{
    MaxRecommendTypeModel *type = self.types[self.typeTableView.indexPathForSelectedRow.row];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(type.id);
    params[@"page"] = @(++type.currentPage);
    self.params = params;
    
    NSString *urlString = @"http://api.budejie.com/api/api_open.php";
    [self.manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //发请求获取数据后,追加数据
        //因为会不断追加数据,可能内存消耗越来越多
        //不过SDWebImage内部已经有对应的处理:系统会发出内存警告的通知,SDWebImage会清空所有缓存
        //清空缓存调用的是clearMemory方法,在SDImageCache.h中,可以搜索UIApplicationDidReceiveMemoryWarningNotification
        NSArray *users = [MaxRecommendUserModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [type.users addObjectsFromArray:users];
        
        if (![self.params isEqualToDictionary:params]) return;
        
        [self.userTableView reloadData];
        
        [self checkFooterStatus];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (![self.params isEqualToDictionary:params]) return;
        
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
        
        [self.userTableView.mj_footer endRefreshing];
    }];
}
#pragma mark  ========== 检测footer状态
- (void)checkFooterStatus{
    MaxRecommendTypeModel *model = self.types[self.typeTableView.indexPathForSelectedRow.row];
    
    //如果没有这行,第一次加载某type时,会有"上啦加载"这类的信息
    self.userTableView.mj_footer.hidden = model.users.count == 0;

    //加载完毕
    if (model.total == model.users.count) {
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        //结束刷新状态
        [self.userTableView.mj_footer endRefreshing];
    }
}

#pragma mark  ========== UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.typeTableView) {
        return self.types.count;
    }else{
        //左侧type选中的indexPath = self.typeTableView.indexPathForSelectedRow
        //而type里面有users是保存着对应type曾经加载过的数据
        MaxRecommendTypeModel *type = self.types[self.typeTableView.indexPathForSelectedRow.row];
        
        //这里检测footer
        //footer是公用的,如果第一次点击的typeA下的数据多,没加载完,footer是"点击或上拉加载更多"
        //这个时候再去点击某个typeB数据少的,只有一页的那种,这个时候footer又变成 NoMore 状态
        //然后在点第一次那个typeA数据多的,footer还是noMore状态
        //因为这个时候typeA下users.count有值,会reload,自动调用这个tableView的方法
        //所以这一检测footer状态来修正footer改为"点击或上拉加载更多"
        //这似乎不合适,因为reload,这个tableView方法会调用多次,也就多次检测,不科学
        //为什么不直接在didSelected那个tableView方法中检测呢
        //[self checkFooterStatus];
        
        return type.users.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.typeTableView) {
        MaxRecommendTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"types"];
        cell.model = self.types[indexPath.row];
        
        return cell;
    }else{
        MaxRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
        MaxRecommendTypeModel *type = self.types[self.typeTableView.indexPathForSelectedRow.row];
        cell.model = type.users[indexPath.row];
        
        return cell;
    }
}

#pragma mark  ========== UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MaxRecommendTypeModel *model = self.types[indexPath.row];
    
    //type.users.count为真表示,曾经加载过这个type的数据,直接刷新tableView
    //上面UITableViewDataSource的2个方法都是以选中的type为基准,所以刷新tableView就是对应的type数据
    if(model.users.count){
        [self checkFooterStatus];
        
        [self.userTableView reloadData];
        
    }else{
        //立刻刷新tableView
        //目的是:如果网络慢,选中新的type时,不会立即显示对应type的信息,而是上个type的信息,容易产生"数据已经加载完毕"的错觉
        [self.userTableView reloadData];
        
        //第一次选中type时,立刻进入下拉刷新状态,也就是调用loadNew
        [self.userTableView.mj_header beginRefreshing];
    }
}

#pragma mark  ========== 销毁控制器
- (void)dealloc{
    //当前控制器销毁时,取消所有请求
    //因为请求发出后,如果突然退出这个控制器,请求里面的block还存在
    //而block里面会访问控制器,这个如果控制器已经销毁了,程序会崩溃
    [self.manager.operationQueue cancelAllOperations];
}

@end
