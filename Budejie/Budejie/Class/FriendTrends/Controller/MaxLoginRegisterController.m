//
//  MaxLoginRegisterController.m
//  My百思不得姐
//
//  Created by Max on 16/2/18.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MaxLoginRegisterController.h"

@interface MaxLoginRegisterController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end

@implementation MaxLoginRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeContactAdd];
    b.layer.cornerRadius = 5;
    b.layer.masksToBounds = YES;
}
- (IBAction)showLoginRegister:(UIButton *)sender {
    
    //显示注册
    if (self.leftMargin.constant == 0) {
        self.leftMargin.constant = - self.view.width;
        [sender setTitle:@"已有账号?" forState:UIControlStateNormal];
    }else{
        //显示登录
        self.leftMargin.constant = 0;
        [sender setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

//当前控制器状态栏为白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)buttonClose {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
