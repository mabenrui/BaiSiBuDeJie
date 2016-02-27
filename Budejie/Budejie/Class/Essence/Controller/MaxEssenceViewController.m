//
//  MaxEssenceViewController.m
//  My百思不得姐
//
//  Created by Max on 16/2/1.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxEssenceViewController.h"
#import "MaxRecommendTagController.h"
#import "MaxTopicController.h"

#define titleTag 50

@interface MaxEssenceViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *indicator;
@property (nonatomic, weak) UIButton *currentButton;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation MaxEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setChildController];
    
    //设置导航栏
    [self customeNav];
    
    //设置顶部标签栏
    [self customTitleView];
    
    //设中间scrollView;
    [self customContentView];
}

/**
 * 设置子控制器
 */
- (void)setChildController{
    MaxTopicController *all = [[MaxTopicController alloc]init];
    all.type = 1;
    [self addChildViewController:all];
    
    MaxTopicController *voice = [[MaxTopicController alloc]init];
    voice.type = 31;
    [self addChildViewController:voice];
    
    MaxTopicController *video = [[MaxTopicController alloc]init];
    video.type = 41;
    [self addChildViewController:video];
    
    MaxTopicController *picture = [[MaxTopicController alloc]init];
    picture.type = 10;
    [self addChildViewController:picture];
    
    MaxTopicController *word = [[MaxTopicController alloc]init];
    word.type = 29;
    [self addChildViewController:word];
}

/**
 * 导航条
 */
- (void)customeNav{
    self.view.backgroundColor = GlobalBg;
    
    //设置导航栏内容
    //initWithImage会使imageView的尺寸和image一样
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //左边的按钮
    UIBarButtonItem *item = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    self.navigationItem.leftBarButtonItem = item;
}
/**
 * 顶部的titleView
 */
- (void)customTitleView{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, 35)];
    
    //0.5的透明度,是半透明的背景色,不是背景半透明
    //背景半透明,那它的子控件也会半透明
//    titleView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    //底部红色指示器
    UIView *indicator = [UIView new];
    indicator.height = 2;
    indicator.y = titleView.height - indicator.height;
    indicator.backgroundColor = [UIColor redColor];
    [titleView addSubview:indicator];
    self.indicator = indicator;
    
    NSArray *titleTags = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    
    NSInteger count = titleTags.count;
    CGFloat width = titleView.width / count;
    CGFloat height = titleView.height;
    
    for (int i = 0; i < count; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.tag = i + titleTag;
        button.frame = CGRectMake(i*width, 0, width, height);
        [button setTitle:titleTags[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [titleView addSubview:button];
        
        //让按钮内部的label按照文字的长度来计算长度
        //虽然上面button已经设置了title但是布局并没有立刻生成
        //所以第一次默认选中,下面的红线不出现,因为没有宽度
        [button.titleLabel sizeToFit];
        
        //默认选中第一个
        if(i == 0){
            [self titleClick:button];
        }
    }
}
/**
 * 中间的scrollView
 */
- (void)customContentView{
    
    //不要自动调整inset
    //因为系统会自动调节tableView 64的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.frame = self.view.bounds;
    contentView.contentSize = CGSizeMake(self.childViewControllers.count * contentView.width, 0);
    contentView.pagingEnabled = YES;
    contentView.delegate = self;
    
    //注意这里是insertSubview 不是addSubview
    //因为上面设置内边距,用到self.titleView.frame,所以需要先创建titleView
    //所以后创建的contentView如果直接addSubview,会遮挡住titleView
    //所以就insertView把contentView放最下面
    [self.view insertSubview:contentView atIndex:0];
    
    self.contentView = contentView;
    
    //添加第一个子控制器
    [self scrollViewDidEndScrollingAnimation:contentView];
    
}

- (void)titleClick:(UIButton *)button{
    
    //修改按钮状态
    //用disable是为了避免多次重复点击已经选中的标签
    button.enabled = NO;
    self.currentButton.enabled = YES;
    self.currentButton = button;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.indicator.width = button.titleLabel.width;
        self.indicator.centerX = button.centerX;
    }];
    
    CGPoint offset = self.contentView.contentOffset;
    offset.x = (button.tag - titleTag) * self.view.width;
    [self.contentView setContentOffset:offset animated:YES];
}

- (void)tagClick{
    MaxRecommendTagController *tagController = [MaxRecommendTagController new];
    
    [self.navigationController pushViewController:tagController animated:YES];
}

#pragma mark  ========== UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //算出索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    //取出子控制器
    UIViewController *viewController = self.childViewControllers[index];
    
    viewController.view.x = index * scrollView.width;
    viewController.view.y = 0; //默认为20
    viewController.view.height = scrollView.height; //默认比屏高少20
    
    //设置scrollView的内边距
    //内边距放在对应的vc里面设置,而不是在外面统一设置
    //因为这个内边距是tableView的属性,无法保证以后这里扩展的时候,还是tableViewController
//    CGFloat bottom = self.tabBarController.tabBar.height;
//    CGFloat top = CGRectGetMaxY(self.titleView.frame);
//    viewController.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
//    
//    //vc的tableView滚动条的内边距和tableView的内边距一致
//    viewController.tableView.scrollIndicatorInsets = viewController.tableView.contentInset;

    //把子控制器view添加到scrollView上
    [scrollView addSubview:viewController.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:(UIButton *)[self.titleView viewWithTag:(index + titleTag)]];
}





@end
