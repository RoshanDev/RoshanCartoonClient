//
//  DownloadCell.h
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-30.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "Model.h"
@interface DownloadCell : UITableViewCell<ASIHTTPRequestDelegate>
@property (nonatomic, strong) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *coverImageView;
@property (strong, nonatomic) ASINetworkQueue *networkQueue;
@property (strong, nonatomic) NSDictionary *cartoonDic;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIButton *startOrPausebutton;
@property (strong, nonatomic) Model *model;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) int totalPage;
- (void)getCartoonTotalPageCount;
- (void)download;
@end
