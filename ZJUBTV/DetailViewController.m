//
//  DetailViewController.m
//  ZJUBTV
//
//  Created by GreysTone on 10/31/15.
//  Copyright © 2015 GreysTone. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNavigationBar{
    //创建一个导航栏
    UINavigationBar *navigationBar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44+20)];
    UIImageView* videoImage = [[UIImageView alloc] init];    //navigationBar.tintColor=[UIColor whiteColor];
    [self.view addSubview:navigationBar];
    [self.view addSubview:videoImage];
    //创建导航控件内容
    UINavigationItem *navigationItem=[[UINavigationItem alloc]initWithTitle:@"Web Chat"];
    
    //左侧添加登录按钮
    UIBarButtonItem *loginButton=[[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(login)];
    
    navigationItem.leftBarButtonItem=loginButton;
    
    //添加内容到导航栏
    [navigationBar pushNavigationItem:navigationItem animated:NO];
}

- (void)login{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
