//
//  DetailViewController.h
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-6.
//  Copyright (c) 2013年 方辉. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "BookBagViewController.h"
#import "SinaWeibo.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "YXApi.h"
#import "YXApiObject.h"

#import "Model.h"
#import "ReadViewController.h"
#import "SDWebDataManager.h"
#import "ThemeButton.h"

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,SinaWeiboDelegate,SDWebDataManagerDelegate>

//返回按钮
@property (strong, nonatomic) ThemeButton *backButton;
@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) UITableView *chapterTableView;
@property (strong, nonatomic) UITableView *commentTableView;
@property (strong, nonatomic) BookBagViewController *bookBagVC;
@property (strong, nonatomic) SinaWeibo *sinaWeibo;
@property (retain, nonatomic) Model *model;
@property (retain, nonatomic) ReadViewController *readVC;
@property (retain, nonatomic) NSArray *commences;
@property (retain, nonatomic) NSArray *chapters;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailInfoTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *detailSegment;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareString;
@property (nonatomic, copy) NSString *webpageUrl;

+ (DetailViewController *)shareDetailViewController;
- (IBAction)collect:(id)sender;
- (IBAction)selectFunction:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)download:(id)sender;


@end
