//
//  ReadViewController.h
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-15.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeButton.h"
@interface ReadViewController : UIViewController

@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) ThemeButton *backButton;
@property (strong, nonatomic) UIImageView *contentImageView;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIButton *previousButton;
@property (strong, nonatomic) UISlider *progressSlider;
@property (strong, nonatomic) UIView *topView;
@property (assign, nonatomic) int currentPage;
@end
