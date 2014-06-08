//
//  ContactViewController.h
//  RoshanCartoonClient
//
//  Created by 方辉 on 14-6-7.
//  Copyright (c) 2014年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeButton.h"

@interface ContactViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) ThemeButton *backButton;
@property (strong, nonatomic) NSArray *contents;
@end
