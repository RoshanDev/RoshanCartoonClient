//
//  HomeViewController.h
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-4.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "RSCell.h"
@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) NSData *data;
//@property (strong, nonatomic) HomeModel *homeModel;
@property (strong, nonatomic) Model *model;
@property (strong, nonatomic) NSMutableArray *homeArray;
@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) UIScrollView *homeScrollView;
@property (strong, nonatomic) UIPageControl *homePageControl;
@property (strong, nonatomic) UITableView *homeTableView;

@end
