//
//  ThemeViewController.h
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-24.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeButton.h"

@interface ThemeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *themes;
}

@property (retain, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ThemeButton *backButton;

@end
