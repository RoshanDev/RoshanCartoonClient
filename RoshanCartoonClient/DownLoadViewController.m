//
//  DownLoadViewController.m
//  自定义TabBar
//
//  Created by 方辉 on 13-10-23.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "DownLoadViewController.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "SDImageView+SDWebCache.h"
#import "ThemeButton.h"


@interface DownLoadViewController ()

@end

@implementation DownLoadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.downloadDic = [[NSMutableDictionary alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDownloadView:) name:@"download" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self _initSubView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_initSubView
{
    //标题label
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(113, 20, 95, 30)];
    titleLabel.text = @"下载";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    
    //分隔长条图片
    ThemeButton *navImageView = [[ThemeButton alloc] initWithImage:@"nav_image1@2x.png"];
    navImageView.frame = CGRectMake(0, 55, 320, 4);
    navImageView.userInteractionEnabled = NO;
    [self.view addSubview:navImageView];

    //下载列表
    self.downloadTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 59, 320, 568 - 59) style:UITableViewStylePlain];
    self.downloadTableView.rowHeight = 112;
    [self.view addSubview:self.downloadTableView];
    self.downloadTableView.dataSource = self;
    self.downloadTableView.delegate = self;
}


#pragma mark - 返回按钮响应事件
-(void)backToPreviousVC:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)getCurrentPageName:(int)currentPageCount
{
    NSString *pageName = [NSString stringWithFormat:@"%d0",currentPageCount - 1];
    int numberOfZero = 5 - (int)pageName.length;
    while (numberOfZero != 0) {
        pageName = [NSString stringWithFormat:@"0%@",pageName];
        numberOfZero--;
    }
    pageName = [NSString stringWithFormat:@"k%@",pageName];
    return pageName;
}

#pragma mark - 通知方法
- (void)reloadDownloadView:(NSNotification *)notification
{
    NSDictionary *dic = (NSDictionary *)notification.object;
    [self.downloadDic setValue:dic forKey:[NSString stringWithFormat:@"cartoon-%lu",(unsigned long)self.downloadDic.count]];
    [self.downloadTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.downloadDic.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *flag = @"downCell";
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    if (cell == nil) {
        cell = [[DownloadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    cell.cartoonDic = [self.downloadDic objectForKey:[NSString stringWithFormat:@"cartoon-%ld",(long)indexPath.row]];
    [cell.startOrPausebutton setTitle:@"暂停" forState:UIControlStateNormal];
    cell.nameLabel.text =[[self.downloadDic objectForKey:[NSString stringWithFormat:@"cartoon-%ld",(long)indexPath.row]] objectForKey:@"name"];
    [cell.coverImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/%@",[cell.cartoonDic objectForKey:@"eimg"]]]];
    [cell getCartoonTotalPageCount];
    [cell download];
    return cell;
}

@end
