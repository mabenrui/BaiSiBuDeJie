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
#import "MaxTopicVoiceView.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>

@interface MaxTopicController () <MaxTopicVoiceViewDelegate>

//帖子数组
@property (nonatomic, copy) NSMutableArray *topics;
//当前页
@property (nonatomic, assign) NSInteger page;
//maxtime 加载分页需要这个参数
@property (nonatomic, copy) NSString *maxtime;

//正处于active的voiceView
@property (nonatomic, weak) MaxTopicVoiceView *activeVoiceView;
//active的topic
@property (nonatomic, weak) MaxTopicModel *activeTopic;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;

//音乐播放进度的监控,用来移除监控
@property (nonatomic, strong) id observer;

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

#pragma mark  ========== 下拉刷新
- (void)loadNewTopics{
    
    //结束上啦
    [self.tableView.mj_footer endRefreshing];
    
    //重置播发器
    [self.player pause];
    self.player = nil;
    self.playerItem = nil;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    [[AFHTTPSessionManager manager] GET:BaseApi parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        //保存maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
//        LLog(@"%@", responseObject);
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
#pragma mark  ========== 上啦加载
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

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (model.type == MaxTopicTypeVoice) {
        cell.voiceView.delegate = self;
        
        if (model.isActive == YES) {
            [cell.voiceView playAction];
        }else{
            [cell.voiceView playEnd];
        }
    }
    
    cell.topic = model;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MaxTopicModel *topic = self.topics[indexPath.row];

    return topic.rowHeight;
}

- (AVPlayer *)createPlayer:(NSString *)str
{
    NSURL *uri = [NSURL URLWithString:str];
    self.playerItem = [[AVPlayerItem alloc]initWithURL:uri];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];

    return self.player;
}

#pragma mark  ========== MaxTopicVoiceViewDelegate 音乐代理

- (void)voiceView:(MaxTopicVoiceView *)voiceView clickPlayButton:(UIButton *)button{
    if (self.activeVoiceView && self.activeVoiceView != voiceView) {
        [self.activeVoiceView playerDidEnd];
    }else if (self.activeVoiceView == voiceView){
        self.activeTopic.isActive = NO;
    }
    self.activeTopic = voiceView.topic;
    self.activeVoiceView = voiceView;
    
    UIImage *pause = [UIImage imageNamed:@"playButtonPause"];
    UIImage *play = [UIImage imageNamed:@"playButtonPlay"];
    
    if (! voiceView.topic.isActive) {
        if (self.observer) {
            [self.player pause];
            [self.player removeTimeObserver:self.observer];
        }
        
        self.player = [self createPlayer:voiceView.topic.voiceuri];
        
        [button setImage:pause forState:UIControlStateNormal];
        
        //播放button滑动到左边
        if (button.x > MaxMargin) {
            [UIView animateWithDuration:0.2 animations:^{
                CGFloat delta = kWidth / 2 - button.width / 2 - MaxMargin;
                button.transform = CGAffineTransformMakeTranslation(-1*delta, 0);
            } completion:^(BOOL finished) {
                [voiceView playAction];
            }];
        }
        __weak MaxTopicController *weak = self;
        __weak MaxTopicVoiceView *weakVoice = voiceView;
        self.observer = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            CGFloat currenTime = weak.playerItem.currentTime.value / weak.playerItem.currentTime.timescale;
            CGFloat duration = weak.playerItem.duration.value / weak.playerItem.duration.timescale;
            
            NSString *str = [NSString stringWithFormat:@"%02ld:%02ld", (NSInteger)currenTime/60, (NSInteger)currenTime%60];
            [weakVoice changeProgressString:str];
            [weakVoice changeProgressValue:currenTime/duration];
        }];
        
        voiceView.topic.isVoicePlaying = YES;
        voiceView.topic.isActive = YES;
        
        [self.player play];
    }else if (voiceView.topic.isVoicePlaying){
        //暂停音乐
        [self.player pause];
        voiceView.topic.isVoicePlaying = NO;
        
        [button setImage:play forState:UIControlStateNormal];
    }else if (! voiceView.topic.isVoicePlaying){
        //play音乐
        [self.player play];
        voiceView.topic.isVoicePlaying = YES;
        
        [button setImage:pause forState:UIControlStateNormal];
    }
}

- (void)voiceView:(MaxTopicVoiceView *)voiceView beforeChangeProgress:(UISlider *)sender{
    [self.player pause];
}
- (void)voiceView:(MaxTopicVoiceView *)voiceView changePlayProgress:(UISlider *)sender{
    CGFloat duration = self.playerItem.duration.value / self.playerItem.duration.timescale;
    [self.player seekToTime:CMTimeMake(duration * sender.value, 1)];
}
- (void)voiceView:(MaxTopicVoiceView *)voiceView afterChangeProgress:(UISlider *)sender{
    [self.player play];
}






















@end
