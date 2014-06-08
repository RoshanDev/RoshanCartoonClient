//
//  AppDelegate.m
//  RoshanCartoonClient
//
//  Created by 方辉 on 14-5-22.
//  Copyright (c) 2014年 方辉. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h"
#import "DetailViewController.h"
#import "ThemeManager.h"
@implementation AppDelegate

- (void)_initTheme
{
    NSString *themeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
    [[ThemeManager shareInstance] setThemeName:themeName];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [WXApi registerApp: @"wx86899f732c6fea7f"];
    [YXApi registerApp:@"yx246c06c78b0a4674ac7bb231a1f6d0b9"];

    //设置主题
    [self _initTheme];
    
    GuideViewController *guideVC = [[GuideViewController alloc]init];
    self.welcomeVC = [[WelcomeViewController alloc]init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isNotFirst = [userDefaults boolForKey:@"isNotFirst"];
    NSLog(@"是否不是第一次 = %@",isNotFirst?@"是":@"否");
    
    if (isNotFirst) {
        self.window.rootViewController = guideVC;
    }else {
        self.window.rootViewController = _welcomeVC;
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //com.tencent.mqq//com.tencent.xin
    //  NSLog(@"sourceApplication=%@",sourceApplication);
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([sourceApplication isEqualToString:@"com.yixin.yixin"]) {
        return [YXApi handleOpenURL:url delegate:self];
    }else {
        return NO;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -WXApi Delegate
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        //        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        //        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        alert.tag = 1000;
        //        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        //        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        //        WXMediaMessage *msg = temp.message;
        //
        //        //显示微信传过来的内容
        //        WXAppExtendObject *obj = msg.mediaObject;
        //
        //        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        //        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        //        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        //        NSString *strMsg = @"这是从微信启动的消息";
        //
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        //        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        //        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alert show];]
        // NSLog(@"%@",strMsg);
    }
}


#pragma mark -
#pragma mark - YXApiDelegate method
- (void)onReceiveRequest: (YXBaseReq *)req {
    if ([req isKindOfClass:[ShowMessageFromYXReq class]]) {
        ShowMessageFromYXReq* reciveReq = (ShowMessageFromYXReq*)req;
        //        if(reciveReq.message != nil && [reciveReq.message isKindOfClass:[YXAppExtendObject class]]){
        //            YXAppExtendObject* msg = (YXAppExtendObject*)reciveReq.message;
        //            [self showAlert:[NSString stringWithFormat:@"url:%@\nextendinfo:%@", msg.url, msg.extInfo]];
        //        }
        //  NSLog(@"%d", reciveReq.type);
    }
}

- (void)onReceiveResponse: (YXBaseResp *)resp {
    if([resp isKindOfClass:[SendMessageToYXResp class]])
    {
        //        SendMessageToYXResp *sendResp = (SendMessageToYXResp *)resp;
        //  NSLog(@"%d, %@", sendResp.code, sendResp.errDescription);
    }
}


@end
