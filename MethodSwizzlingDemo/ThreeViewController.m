//
//  ThreeViewController.m
//  MethodSwizzlingDemo
//
//  Created by canoejun on 2020/6/13.
//  Copyright © 2020 canoejun. All rights reserved.
//

#import "ThreeViewController.h"
#import "FourViewController.h"

@interface ThreeViewController ()

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 100, 75);
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(__push2NextController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)__push2NextController{
    FourViewController *fourVC = [[FourViewController alloc] init];
    [self.navigationController pushViewController:fourVC animated:YES];
}

@end
