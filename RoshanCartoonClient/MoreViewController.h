//
//  MoreViewController.h
//  自定义TabBar
//
//  Created by 方辉 on 13-10-23.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackViewController.h"
#import "ContactViewController.h"
#import "AboutViewController.h"

@interface MoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) NSArray *titles;

@end
