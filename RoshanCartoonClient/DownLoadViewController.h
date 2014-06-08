//
//  DownLoadViewController.h
//  自定义TabBar
//
//  Created by 方辉 on 13-10-23.
//  Copyright (c) 2013年 方辉. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DownloadCell.h"

@class ASINetworkQueue;
@interface DownLoadViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *downloadTableView;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) ASINetworkQueue *networkQueue;
@property (strong, nonatomic) NSMutableDictionary *downloadDic;
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *huaID;

@end
