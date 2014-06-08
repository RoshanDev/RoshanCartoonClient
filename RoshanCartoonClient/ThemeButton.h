//
//  ThemeButton.h
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-24.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

//Normal状态下的图片名称
@property(nonatomic,copy)NSString *imageName;

//background状态下的背景图片名称
@property(nonatomic,copy)NSString *backgroundImageName;

- (id)initWithImage:(NSString *)imageName;

- (id)initWithBackground:(NSString *)backgroundImageName;


@end
