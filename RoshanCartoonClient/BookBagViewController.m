//
//  BookBagViewController.m
//  自定义TabBar
//
//  Created by 方辉 on 13-10-23.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "BookBagViewController.h"
#import "Model.h"
#import "RSCell.h"
#import "SDImageView+SDWebCache.h"
#import "FMDatabaseAdditions.h"
#import "DetailViewController.h"
#import "ThemeButton.h"


@interface BookBagViewController ()

@end

@implementation BookBagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.bookBagDatabase = [Model shareBookDataBase];
    }
    return self;
}

+ (BookBagViewController *)shareBookBagViewController
{
    static BookBagViewController *bookBagVC = nil;
    if (bookBagVC == nil) {
        bookBagVC = [[BookBagViewController alloc]init];
    }
    return bookBagVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.bookBagDatabase = [Model shareBookDataBase];
    self.bookBagTableView.rowHeight = 112;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailDataOver:) name:@"DetailVCData" object:nil];
    //分隔长条图片
    ThemeButton *navImageView = [[ThemeButton alloc] initWithImage:@"nav_image1@2x.png"];
    navImageView.frame = CGRectMake(0, 55, 320, 4);
    navImageView.userInteractionEnabled = NO;
    [self.view addSubview:navImageView];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self _initData];
    [self.bookBagTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_initData
{
    if ([self.bookBagDatabase open]) {
//        NSLog(@"成功打开数据库");
        if (![self.bookBagDatabase tableExists:@"bookBagTable"]) {
            NSString *creatTable = @"CREATE TABLE bookBagTable(name text,authorname text,category text,eimg blob,id text,info text,read_url text)";
            if ([self.bookBagDatabase executeUpdate:creatTable]) {
//                NSLog(@"创建收藏表格成功");
            }
        }
        //查询表中数据赋值给数据源
        NSString *selectSql = @"SELECT * FROM bookBagTable";
        FMResultSet *result = [self.bookBagDatabase executeQuery:selectSql];
        NSString *tempIdStr = nil;
        NSString *tempnameStr = nil;
        NSString *tempauthorStr = nil;
        NSString *tempcategoryStr = nil;
        NSData *tempeimgData = nil;
        NSString *tempinfoStr = nil;
        NSString *tempread_urlStr = nil;
        NSMutableArray *tempArray = [NSMutableArray array];
        while ([result next]) {
            tempIdStr = [result stringForColumn:@"id"];
            tempnameStr = [result stringForColumn:@"name"];
            tempauthorStr = [result stringForColumn:@"authorname"];
            tempcategoryStr = [result stringForColumn:@"category"];
            tempeimgData = [result dataForColumn:@"eimg"];
            tempinfoStr = [result stringForColumn:@"info"];
            tempread_urlStr = [result stringForColumn:@"read_url"];
            if (tempread_urlStr.length == 0) {
                NSLog(@"没有阅读链接");
                return;
            }
            NSDictionary *dic = @{@"id": tempIdStr,
                                  @"name": tempnameStr,
                                  @"authorname": tempauthorStr,
                                  @"category": tempcategoryStr,
                                  @"eimg": tempeimgData,
                                  @"info": tempinfoStr,
                                  @"read_url": tempread_urlStr};
            [tempArray addObject:dic];
        }
        _bookBagArray = [NSMutableArray arrayWithArray:tempArray];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bookBagArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    RSCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[RSCell alloc]init];
    }
//    [cell.coverImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/%@",[[self.bookBagArray objectAtIndex:indexPath.row] objectForKey:@"eimg"]]]];
    cell.coverImageView.image = [UIImage imageWithData:[[self.bookBagArray objectAtIndex:indexPath.row] objectForKey:@"eimg"]];
    cell.nameLabel.text = [[self.bookBagArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.authorLabel.text = [[self.bookBagArray objectAtIndex:indexPath.row] objectForKey:@"authorname"];
    cell.categoryLabel.text = [[self.bookBagArray objectAtIndex:indexPath.row] objectForKey:@"category"];
    return cell;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除数据
    NSString *idstr = [[self.bookBagArray objectAtIndex:indexPath.row] objectForKey:@"id"];
//    NSLog(@"id = %@",idstr);
    if ([self.bookBagDatabase executeUpdate:@"DELETE FROM bookBagTable WHERE id = ?",idstr]) {
//        NSLog(@"删除成功");
    }
    [self.bookBagArray  removeObjectAtIndex:indexPath.row];
    //更新UI
    [self.bookBagTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[Model shareModel] parseDetailData:[[self.bookBagArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
}

#pragma mark - 通知中心方法
- (void)detailDataOver:(NSNotification *)notification
{
    NSDictionary *dic = (NSDictionary *)notification.object;
    [self performSelectorOnMainThread:@selector(goForwardToDetailVC:) withObject:dic waitUntilDone:YES];
}

- (void)goForwardToDetailVC:(NSDictionary *)tempDic
{
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.dic = tempDic;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
