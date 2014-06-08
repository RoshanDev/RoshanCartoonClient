//
//  ThemeViewController.m
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-24.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeManager.h"
#import "ThemeButton.h"


@interface ThemeViewController ()

@end

@implementation ThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //取得所有的主题名
        themes = [[ThemeManager shareInstance].themesPlist allKeys];
        self.title = @"主题切换";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self _initSubView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 59, 320, 568 - 59) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)_initSubView
{
    //标题label
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(113, 20, 95, 30)];
    titleLabel.text = @"主题";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    self.backButton = [[ThemeButton alloc] initWithBackground:@"back@2x.png"];
    self.backButton.frame = CGRectMake(20, 20, 30, 30);
    self.backButton.showsTouchWhenHighlighted = YES;
    [self.backButton addTarget:self action:@selector(backToPreviousVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];

    
    //分隔长条图片
    ThemeButton *navImageView = [[ThemeButton alloc] initWithImage:@"nav_image1@2x.png"];
    navImageView.frame = CGRectMake(0, 55, 320, 4);
    navImageView.userInteractionEnabled = NO;
    [self.view addSubview:navImageView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return themes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"themeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        UILabel *textLabel = [UIFactory createLabel:kThemeListLabel];
        UILabel *textLabel = [[UILabel alloc]init];
        textLabel.frame = CGRectMake(10, 10, 200, 30);
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        textLabel.tag = 2013;
        [cell.contentView addSubview:textLabel];
    }
    
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:2013];
    //当前cell中的主题名
    NSString *name = themes[indexPath.row];
    textLabel.text = name;
    
    //当前使用的主题名称
    NSString *themeName = [ThemeManager shareInstance].themeName;
    if (themeName == nil) {
        themeName = @"默认";
    }
    
    //比较cell中的主题名和当前使用的主题名是否相同
    if ([themeName isEqualToString:name]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

//切换主题
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //主题名称
    NSString *themeName = themes[indexPath.row];
    if ([themeName isEqualToString:@"默认"]) {
        themeName = nil;
    }
    
    //保存主题到本地
    [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:kThemeName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [ThemeManager shareInstance].themeName = themeName;
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNofication object:themeName];
    
    //刷新列表
    [tableView reloadData];
}

#pragma mark - 返回按钮响应事件
-(void)backToPreviousVC:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
