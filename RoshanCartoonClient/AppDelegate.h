//
//  AppDelegate.h
//  RoshanCartoonClient
//
//  Created by 方辉 on 14-5-22.
//  Copyright (c) 2014年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelcomeViewController.h"
#import "SinaWeibo.h"
#import "WXApi.h"
#import "YXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,YXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WelcomeViewController *welcomeVC;

@end
