//
//  ThemeManager.h
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-24.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kThemeDidChangeNofication @"kThemeDidChangeNofication"

@interface ThemeManager : NSObject
//当前使用的主题名称
@property (nonatomic, copy) NSString *themeName;
@property (nonatomic, retain) NSDictionary *themesPlist;

+ (ThemeManager *)shareInstance;

//返回当前主体下，图片名对应图片
- (UIImage *)getThemeImage:(NSString *)imageName;
-(NSString *)getThemePath;

@end
