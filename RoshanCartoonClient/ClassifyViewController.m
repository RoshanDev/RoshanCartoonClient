//
//  ClassifyViewController.m
//  自定义TabBar
//
//  Created by 方辉 on 13-10-23.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "ClassifyViewController.h"
#import "SINavigationMenuView.h"
#import "RSCell.h"
#import "DetailViewController.h"
#import "SDImageView+SDWebCache.h"
#import "ThemeButton.h"


@interface ClassifyViewController ()

@end

@implementation ClassifyViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ClassDataOver:) name:@"ClassVCData" object:nil];

    _categoryTableView.rowHeight = 112;
    //分隔长条图片
    ThemeButton *navImageView = [[ThemeButton alloc] initWithImage:@"nav_image1@2x.png"];
    navImageView.frame = CGRectMake(0, 55, 320, 4);
    navImageView.userInteractionEnabled = NO;
    [self.view addSubview:navImageView];

    _model = [Model shareModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseCategoryDataOver:) name:@"category" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseCategoryDetailDataOver:) name:@"categoryDetailInfo" object:nil];
    [_model parseCategoryData];

//    SINavigationMenuView *menu = [[SINavigationMenuView alloc]initWithFrame:CGRectMake(10, 20, 300, 400) title:@"漫画详情"];
//    [menu displayMenuInView:self.view];
//    menu.items = array;
//    menu.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SIMenuTable delegate
- (void)didBackgroundTap
{
    [_menu hide];
}
- (void)didSelectItemAtIndex:(NSUInteger)index
{
    [_model parseCategoryDetailInfoData:[[_model.categoryDataArray objectAtIndex:index] objectForKey:@"link"]];
    [_menu hide];
}

- (IBAction)showCategory:(id)sender {
    if (_menuIsShow) {
        [_menu hide];
        _menuIsShow = !_menuIsShow;
    }else {
        [self.view addSubview:_menu];
        [_menu show];
        _menuIsShow = !_menuIsShow;
    }
}

#pragma mark - 通知的方法
- (void)parseCategoryDataOver:(NSNotification *)nf
{
    _categoryArray = [NSMutableArray array];
    for (NSDictionary *dic in _model.categoryDataArray) {
        [_categoryArray addObject:[dic objectForKey:@"name"]];
    }
    _menu = [[SIMenuTable alloc]initWithFrame:CGRectMake(10, 60, 300, 400) items:_categoryArray];
    _menu.menuDelegate = self;
    _menuIsShow = NO;
    [_menu hide];
    
    [_model parseCategoryDetailInfoData:[[_model.categoryDataArray objectAtIndex:0] objectForKey:@"link"]];
}

- (void)parseCategoryDetailDataOver:(NSNotification *)nf
{
    _categoryDetailArray = (NSMutableArray *)nf.object;
    [_categoryTableView reloadData];
}


#pragma mark -UITableView delegate dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _categoryDetailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    RSCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[RSCell alloc]init];
    }
    [cell.coverImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/%@",[[_categoryDetailArray objectAtIndex:indexPath.row] objectForKey:@"eimg"]]]];

    cell.nameLabel.text = [[_categoryDetailArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.authorLabel.text = [[_categoryDetailArray objectAtIndex:indexPath.row] objectForKey:@"authorname"];
    cell.categoryLabel.text = [[_categoryDetailArray objectAtIndex:indexPath.row] objectForKey:@"category"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[Model shareModel] parseClassData:[[_categoryDetailArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
//    DetailViewController *detailVC = [[DetailViewController alloc]init];
//    detailVC.dic = [_categoryDetailArray objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:detailVC animated:YES];

}

#pragma mark - 通知中心方法
- (void)ClassDataOver:(NSNotification *)notification
{
    NSDictionary *dic = (NSDictionary *)notification.object;
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.dic = dic;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
