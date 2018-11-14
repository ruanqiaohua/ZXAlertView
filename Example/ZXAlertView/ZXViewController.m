//
//  ZXViewController.m
//  ZXAlertView
//
//  Created by ruanqiaohua on 11/14/2018.
//  Copyright (c) 2018 ruanqiaohua. All rights reserved.
//

#import "ZXViewController.h"
#import "ZXAlertView.h"

@interface ZXViewController ()

@end

@implementation ZXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    ZXAlertView *alertView = [ZXAlertView alertWithTitle:@"这是一个标题" message:@"这是一个标题"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitle:@"知道了" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [alertView addButton:button block:^(ZXAlertView * _Nonnull alert) {
        [alert hidden];
    }];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
