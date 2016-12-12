//
//  OneViewController.m
//  自定义导航控制器的push动画
//
//  Created by jack xu on 16/12/7.
//  Copyright © 2016年 jack xu. All rights reserved.
//

#import "OneViewController.h"
#import "TwoViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 40);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}

-(void)push{
    
    TwoViewController *twoView = [[TwoViewController alloc]init];
    twoView.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:twoView animated:YES];
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

@end
