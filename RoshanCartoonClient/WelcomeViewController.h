//
//  WelcomeViewController.h
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-4.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CustomTabBarController.h"
#import "Model.h"
@interface WelcomeViewController : UIViewController
@property (retain, nonatomic) MBProgressHUD *loadHUD;
@property (retain, nonatomic) Model *model;
@property (retain, nonatomic) CustomTabBarController *customTabBarC;
@end
