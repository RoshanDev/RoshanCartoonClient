//
//  CustomTabBarController.m
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-4.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "CustomTabBarController.h"
#import "BookBagViewController.h"
#import "ClassifyViewController.h"
#import "DownLoadViewController.h"
#import "MoreViewController.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBar.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self _initSubView];
    [self _initTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_initSubView
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    self.homeVC = [[HomeViewController alloc]init];
    [array addObject:self.homeVC];
    
    BookBagViewController *bookBagVC = [[BookBagViewController alloc]init];
    [array addObject:bookBagVC];
    
    ClassifyViewController *classifyVC = [[ClassifyViewController alloc]init];
    [array addObject:classifyVC];
    
    DownLoadViewController *downLoadVC = [[DownLoadViewController alloc]init];
    [array addObject:downLoadVC];
    
    MoreViewController *moreVC = [[MoreViewController alloc]init];
    [array addObject:moreVC];
    
    NSMutableArray *navArray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[array objectAtIndex:i]];
        nav.navigationBar.hidden = YES;
        [navArray addObject:nav];
    }
    self.viewControllers = navArray;
    
}

- (void)_initTabBar
{
    _tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 568 - 49, 320, 49)];
    _tabBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tabBarView];
    
    NSArray *bgArray = @[@"home.png",@"bag.png",@"class.png",@"download.png",@"more.png"];
    NSArray *labelArray = @[@"首页",@"书包",@"分类",@"下载",@"更多"];
    for (int i = 0; i < bgArray.count; i++) {
        NSString *imageName = bgArray[i];
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        ThemeButton *btn = [[ThemeButton alloc]initWithImage:imageName];
        btn.frame = CGRectMake(i * 64 + 17, 0, 30, 30);
        btn.showsTouchWhenHighlighted = YES;
        btn.tag = i;
//        [btn setImage:[UIImage imageNamed:[bgArray objectAtIndex:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onSelecButton:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarView addSubview:btn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * 64 + 17, 35, 30, 10)];
        label.backgroundColor = [UIColor clearColor];
        label.text = [labelArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10.0f];
        [_tabBarView addSubview:label];
    }
    
    //遮挡动画的图片
    _shelter = [[ThemeButton alloc] initWithImage:@"background_img.png"];
    _shelter.frame = CGRectMake(0, 0, 64, 49);
//    _shelter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 49)];
    _shelter.userInteractionEnabled = NO;
    _shelter.alpha = 0.7;
//    _shelter.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_img"]];
    [_tabBarView addSubview:_shelter];
}

- (void)onSelecButton:(UIButton *)btn
{
    self.selectedIndex = btn.tag;
    
    float x = btn.frame.origin.x;
    [UIView animateWithDuration:0.3 animations:^{
        _shelter.frame = CGRectMake(x - 15, 0, 64, 49);
    }];
}

- (void)hideTabBar:(BOOL)hide
{
    self.tabBarView.hidden = hide;
    self.shelter.hidden = hide;
}


@end
