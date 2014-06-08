//
//  CustomTabBarController.h
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-4.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "ThemeButton.h"

@interface CustomTabBarController : UITabBarController

@property (nonatomic, retain) UIView * tabBarView;
@property(nonatomic, retain) ThemeButton * shelter;
@property (nonatomic, retain) HomeViewController *homeVC;

- (void)hideTabBar:(BOOL)hide;

@end
