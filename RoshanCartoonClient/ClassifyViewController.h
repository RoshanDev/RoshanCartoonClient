//
//  ClassifyViewController.h
//  自定义TabBar
//
//  Created by 方辉 on 13-10-23.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMenuTable.h"
#import "Model.h"

@interface ClassifyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SIMenuDelegate>
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSMutableArray *categoryDetailArray;
@property (strong, nonatomic) SIMenuTable *menu;
@property (assign, nonatomic) BOOL menuIsShow;
@property (strong, nonatomic) Model *model;

- (IBAction)showCategory:(id)sender;
@end
