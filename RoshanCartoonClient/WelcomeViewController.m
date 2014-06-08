//
//  WelcomeViewController.m
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-4.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "WelcomeViewController.h"
#import "HomeViewController.h"
#import "GDataXMLNode.h"
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

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
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeDataOver:) name:@"homeData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rankListDataOver:) name:@"rankList" object:nil];

    self.model = [Model shareModel];
    [self.model parseHomeData];
    [self.model parseRankListData];
    
    [self _initSubView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_initSubView
{
    UIImageView *loadImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 90, 320, 300)];
    loadImgV.image = [UIImage imageNamed:@"welcome.jpg"];
    [self.view addSubview:loadImgV];
    
    //加载提示
    UIView *loadBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    loadBGView.center = CGPointMake(160, 520);
    [self.view addSubview:loadBGView];
    
    self.loadHUD = [MBProgressHUD showHUDAddedTo:loadBGView animated:YES];
    self.loadHUD.labelText = @"正在加载";
    [self.loadHUD show:YES];
}

- (void)homeDataOver:(NSNotification *)nf
{
    if (self.model.homeDataArray != nil &&self.model.rankListDataArray) {
        CustomTabBarController *customTabBarC = [[CustomTabBarController alloc]init];
        [self presentViewController:customTabBarC animated:NO completion:^{
            NSLog(@"-------");
        }];
    }
}

- (void)rankListDataOver:(NSNotification *)nf
{
//    self.model = [Model shareModel];
//    NSLog(@"self.model.rankListDataArray1=%@",self.model.rankListDataArray);
//    CustomTabBarController *customTabBarC = [[CustomTabBarController alloc]init];
//    [customTabBarC.homeVC.homeTableView reloadData];
//    
    if (self.model.homeDataArray != nil &&self.model.rankListDataArray) {
        self.customTabBarC = [[CustomTabBarController alloc]init];
        [self presentViewController:self.customTabBarC animated:NO completion:^{
            NSLog(@"+++++++");
        }];
    }
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"homeData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"rankList" object:nil];
}


@end
