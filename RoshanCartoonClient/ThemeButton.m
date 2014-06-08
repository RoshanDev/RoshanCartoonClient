//
//  ThemeButton.m
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-24.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"
@implementation ThemeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithImage:(NSString *)imageName
{
    self = [self init];
    if (self) {
        self.imageName = imageName;
    }
    return self;
}

- (id)initWithBackground:(NSString *)backgroundImageName
{
    self = [self init];
    if (self) {
        self.backgroundImageName = backgroundImageName;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNofication object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark - NSNotification action
//切换主题的通知
- (void)themeNotification:(NSNotification *)notification {
    [self loadThemeImage];
}

//加载图片
- (void)loadThemeImage {
    ThemeManager *themeManager = [ThemeManager shareInstance];
    UIImage *image = [themeManager getThemeImage:_imageName];
    [self setImage:image forState:UIControlStateNormal];
    UIImage *backImage = [themeManager getThemeImage:_backgroundImageName];
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
}

#pragma mark - setter  设置图片名后，重新加载该图片名对应的图片
- (void)setImageName:(NSString *)imageName {
    if (_imageName != imageName) {
        [_imageName release];
        _imageName = [imageName copy];
    }
    //重新加载图片
    [self loadThemeImage];
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName {
    if (_backgroundImageName != backgroundImageName) {
        [_backgroundImageName release];
        _backgroundImageName = [backgroundImageName copy];
    }
    //重新加载图片
    [self loadThemeImage];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
