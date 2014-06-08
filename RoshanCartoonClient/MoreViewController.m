//
//  MoreViewController.m
//  自定义TabBar
//
//  Created by 方辉 on 13-10-23.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeViewController.h"
#import "ThemeButton.h"


@interface MoreViewController ()

@end

@implementation MoreViewController

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
    _titles = @[@"主题设置",@"意见反馈",@"联系开发者",@"关于"];
    [self _initSubView];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 59, 320, 568 - 59) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
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
    titleLabel.text = @"更多";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    //分隔长条图片
    ThemeButton *navImageView = [[ThemeButton alloc] initWithImage:@"nav_image1@2x.png"];
    navImageView.frame = CGRectMake(0, 55, 320, 4);
    navImageView.userInteractionEnabled = NO;
    [self.view addSubview:navImageView];
    
}
#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    if (indexPath.row == 0) {
//        cell.textLabel.text = @"主题";
//    }
    cell.textLabel.text = [_titles objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        [self.navigationController pushViewController:themeVC animated:YES];
    }else if (indexPath.row == 1) {
        [self launchMailApp];
        
//        FeedbackViewController *feedbakcVC = [[FeedbackViewController alloc] init];
//        [self.navigationController pushViewController:feedbakcVC animated:YES];
    }else if (indexPath.row == 2) {
        ContactViewController *contactVC = [[ContactViewController alloc] init];
        [self.navigationController pushViewController:contactVC animated:YES];
    }else if (indexPath.row == 3) {
        AboutViewController *aboutVC = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

-(void)launchMailApp
{
    NSMutableString *mailUrl = [[NSMutableString alloc]init];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"1083254162@qq.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
//    //添加抄送
//    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
//    
//    //添加密送
//    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
//    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
//    //添加主题
//    [mailUrl appendString:@"&subject=意见反馈"];
//    //添加邮件内容
//    [mailUrl appendString:@"&body=<b>email</b> body!"];
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}
@end
