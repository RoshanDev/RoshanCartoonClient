//
//  ContactViewController.m
//  RoshanCartoonClient
//
//  Created by 方辉 on 14-6-7.
//  Copyright (c) 2014年 方辉. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

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
    //标题label
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(113, 20, 95, 30)];
    titleLabel.text = @"联系我们";
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
    _contents = @[@"QQ:1083254162", @"邮箱:1083254162@qq.com", @"电话:15529267397"];
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, 568 - 60) style:UITableViewStyleGrouped];
    [self.view addSubview:tableview];
    tableview.delegate = self;
    tableview.dataSource = self;
    
}

#pragma mark - 返回按钮响应事件
-(void)backToPreviousVC:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *flag = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    cell.textLabel.text = [_contents objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contents.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
