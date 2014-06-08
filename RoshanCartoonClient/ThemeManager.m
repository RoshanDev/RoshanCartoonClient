//
//  ThemeManager.m
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-24.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager
static ThemeManager *themeManager = nil;
+ (ThemeManager *)shareInstance
{
    if (themeManager == nil) {
        @synchronized(self)
        {
            themeManager = [[ThemeManager alloc]init];
        }
    }
    return themeManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *themePath = [[NSBundle mainBundle] pathForResource:@"RoshanTheme" ofType:@"plist"];
        self.themesPlist = [[NSDictionary alloc]initWithContentsOfFile:themePath];
        self.themeName = nil;
    }
    return self;
}

-(NSString *)getThemePath
{
    if (self.themeName == nil) {
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        return resourcePath;
    }
    //取得主题路径，如：Skin/green1
    NSString *themePath = [self.themesPlist objectForKey:_themeName];
    //程序包的根路径
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    //完整的主题包路径
//    NSString *path = [resourcePath stringByAppendingString:themePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@",resourcePath,themePath];
    return path;
}


//返回当前主体下，图片名对应图片
- (UIImage *)getThemeImage:(NSString *)imageName
{
    if (imageName.length == 0) {
        return nil;
    }
    //获取主题目录
    NSString *themePath = [self getThemePath];
    //image在当前主题的路径
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",themePath,imageName];
//    NSString *imagePath = [themePath stringByAppendingString:imageName];
//    NSLog(@"imagePath=%@",imagePath);
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self) {
        if (themeManager == nil) {
            themeManager = [super allocWithZone:zone];
        }
    }
    return themeManager;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return self;
}

+ (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
    
}

- (id)autorelease
{
    return self;
}

@end
