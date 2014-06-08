//
//  HomeViewController.m
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-4.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "HomeViewController.h"
#import "SDImageView+SDWebCache.h"
#import "DetailViewController.h"
#import "SearchViewController.h"
#import "ThemeButton.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = NO;
    self.title = @"首页";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailDataOver:) name:@"DetailVCData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hotSearchDataOver:) name:@"HotSearch" object:nil];
    self.model = [Model shareModel];
    [self _initSubview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_initSubview
{
    //tableView
    self.homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,59 + 160, 320, 568 - 59 - 160)];
    [self.view addSubview:self.homeTableView];
    self.homeTableView.rowHeight = 112;
    self.homeTableView.dataSource = self;
    self.homeTableView.delegate = self;
    
    //SearchButton
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchButton.frame = CGRectMake(257, 20, 30, 30);
    [self.searchButton setImage:[UIImage imageNamed:@"search1.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.searchButton];
    [self.searchButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    
    //scrollView
    self.homeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 59, 320, 160)];
    [self.view addSubview:self.homeScrollView];
    self.homeScrollView.showsHorizontalScrollIndicator = NO;
    self.homeScrollView.showsVerticalScrollIndicator = NO;
    self.homeScrollView.pagingEnabled = YES;
    self.homeScrollView.userInteractionEnabled = YES;
    self.homeScrollView.contentSize = CGSizeMake(320 * self.model.homeDataArray.count, 153);
    self.homeScrollView.delegate = self;
    for (int i = 0; i < self.model.homeDataArray.count; i++) {
        UIImageView *backGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20 + 320 * i, 3, 280, 153)];
        backGroundImageView.image = [UIImage imageNamed:@"background_img"];
        backGroundImageView.layer.cornerRadius = 10;
        backGroundImageView.layer.masksToBounds = YES;
        backGroundImageView.userInteractionEnabled = YES;
        [self.homeScrollView addSubview:backGroundImageView];
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(30, 5, 220, 120)];
        [imgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/%@",[[self.model.homeDataArray objectAtIndex:i] objectForKey:@"eimg"]]]];
//        imgV.tag = 1000 + i;
        imgV.userInteractionEnabled = YES;
        [backGroundImageView addSubview:imgV];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(30, 5, 220, 120)];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(getDetailInfo:) forControlEvents:UIControlEventTouchUpInside];
        [backGroundImageView addSubview:button];
    }
    
    //pageControl
    self.homePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, 59 + 140, 100, 10)];
    self.homePageControl.currentPage = 0;
    self.homePageControl.numberOfPages = self.model.homeDataArray.count;
    [self.homePageControl addTarget:self action:@selector(changeImageView:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.homePageControl];
    
    //分隔长条图片
    ThemeButton *navImageView = [[ThemeButton alloc] initWithImage:@"nav_image1@2x.png"];
    navImageView.frame = CGRectMake(0, 55, 320, 4);
    navImageView.userInteractionEnabled = NO;
    [self.view addSubview:navImageView];

}

#pragma mark -UITableView dataSource delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    RSCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[RSCell alloc]init];
    }
    [cell.coverImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/%@",[[self.model.rankListDataArray objectAtIndex:indexPath.row] objectForKey:@"eimg"]]]];
    cell.nameLabel.text = [[self.model.rankListDataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.authorLabel.text = [[self.model.rankListDataArray objectAtIndex:indexPath.row] objectForKey:@"authorname"];
    cell.categoryLabel.text = [[self.model.rankListDataArray objectAtIndex:indexPath.row] objectForKey:@"category"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.rankListDataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[Model shareModel] parseDetailData:[[self.model.rankListDataArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"漫画排行";
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

- (void)hotSearchDataOver:(NSNotification *)notification
{
    NSMutableArray *array = (NSMutableArray *)notification.object;
    [self performSelectorOnMainThread:@selector(goForwardToSearchVC:) withObject:array waitUntilDone:YES];
}
- (void)goForwardToSearchVC:(NSMutableArray *)array
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    searchVC.searchArray = array;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - pageControl 方法
- (void)changeImageView:(id)sender
{
    int page = self.homePageControl.currentPage;
    CGRect frame = self.homeScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.homeScrollView scrollRectToVisible:frame animated:NO];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)ascrollView{
    int page = self.homeScrollView.contentOffset.x/320;
    self.homePageControl.currentPage = page;
}

/*
 //触摸
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 {
 UITouch *touch = [touches anyObject];//touch.view != self.homeScrollView &&
 if (touch.view != self.homeTableView && touch.view != self.homePageControl && touch.view != self.view) {
 int i = touch.view.tag - 1000;
 }
 }
 */

//点击scrollView响应事件
- (void)getDetailInfo:(UIButton *)btn
{
    [[Model shareModel] parseDetailData:[[self.model.homeDataArray objectAtIndex:(btn.tag - 1000)] objectForKey:@"id"]];
}

#pragma mark -search button响应方法
- (void)search:(UIButton *)button
{
    [[Model shareModel] parseHotSearchData];
}


@end
