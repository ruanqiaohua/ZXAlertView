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
    
    ZXAlertView *alertView = [ZXAlertView alertWithTitle:nil message:@"这是一个很长很长的消息列表这是一个很长很长的消息列表这是一个很长很长的消息列表这是一个很长很长的消息列表这是一个很长很长的消息列表"];
    [alertView addActionWithTitle:@"取消"];
    [alertView addActionWithTitle:@"知道了"];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
