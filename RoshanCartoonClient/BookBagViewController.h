//
//  BookBagViewController.h
//  自定义TabBar
//
//  Created by 方辉 on 13-10-23.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
@interface BookBagViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *bookBagArray;
@property (strong, nonatomic) FMDatabase *bookBagDatabase;
@property (weak, nonatomic) IBOutlet UITableView *bookBagTableView;

+ (BookBagViewController *)shareBookBagViewController;
@end
