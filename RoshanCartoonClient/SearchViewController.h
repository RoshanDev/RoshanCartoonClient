//
//  SearchViewController.h
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-22.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartoonTableView.h"
@interface SearchViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate>
@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIView *buttonBG;
@property (strong, nonatomic) CartoonTableView *searchTableView;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) NSMutableArray *searchArray;
@end
