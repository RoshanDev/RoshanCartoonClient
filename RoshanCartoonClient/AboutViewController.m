//
//  AboutViewController.m
//  RoshanCartoonClient
//
//  Created by 方辉 on 14-6-7.
//  Copyright (c) 2014年 方辉. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //标题label
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(113, 20, 95, 30)];
    titleLabel.text = @"关于";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    self.backButton = [[ThemeButton alloc] initWithBackground:@"back@2x.png"];
    self.backButton.frame = CGRectMake(20, 20, 30, 30);
    self.backButton.showsTouchWhenHighlighted = YES;
    [self.backButton addTarget:self action:@selector(backToPreviousVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    
    //分隔长条图片
    ThemeButton *navImageView = [[ThemeButton alloc] initWithImage:@"nav_image1@2x.png"];
    navImageView.frame = CGRectMake(0, 55, 320, 4);
    navImageView.userInteractionEnabled = NO;
    [self.view addSubview:navImageView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, 300, 368)];
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:17];
    textView.text = @"\n说明:2014毕设\n版本:1.0.0\n指导老师:靳钊\n学生:方辉";

    [self.view addSubview:textView];
}

#pragma mark - 返回按钮响应事件
-(void)backToPreviousVC:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
