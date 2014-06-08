//
//  SearchViewController.m
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-22.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#define buttonwidth 40
#define buttonheight 30
#import "SearchViewController.h"
#import "Model.h"
#import "MBProgressHUD.h"
#import "DetailViewController.h"
#import "Model.h"
#import "ThemeButton.h"


@interface SearchViewController ()

@end

@implementation SearchViewController

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
    [self _initSubView];
    self.searchTableView.delegate = self;
}

- (void)_initSubView
{
    //标题label
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(113, 20, 95, 30)];
    titleLabel.text = @"搜索";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];

    //返回按钮
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 30, 30)];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    self.backButton.showsTouchWhenHighlighted = YES;
    [self.backButton addTarget:self action:@selector(backToPreviousVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];

    
    //分隔长条图片
    ThemeButton *navImageView = [[ThemeButton alloc] initWithImage:@"nav_image1@2x.png"];
    navImageView.frame = CGRectMake(0, 55, 320, 4);
    navImageView.userInteractionEnabled = NO;
    [self.view addSubview:navImageView];
    
    //SearchButton
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchButton.frame = CGRectMake(270, 60, 30, 30);
    [self.searchButton setImage:[UIImage imageNamed:@"search1.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.searchButton];
    [self.searchButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    
    //搜索栏
    self.searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.searchTextField.center = CGPointMake(160, 75);
    self.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchTextField.keyboardType = UIKeyboardAppearanceDefault;
    self.searchTextField.placeholder = @"请按作者名搜索";
    self.searchTextField.delegate = self;
    [self.view addSubview:self.searchTextField];
    
    //button背景图
    self.buttonBG = [[UIView alloc]initWithFrame:CGRectMake(0,59 + 160, 320, 210)];
    [self.view addSubview:self.buttonBG];
    
    //搜索结果列表
    self.searchTableView = [[CartoonTableView alloc]initWithFrame:CGRectMake(0, 100, 320, 400) style:UITableViewCellStyleDefault];
    [self.view addSubview:self.searchTableView];
    self.searchTableView.hidden = YES;
    
    [self generateRandomButton];
}

- (void)generateRandomButton
{
    /*
    NSMutableArray *rectArray = [NSMutableArray arrayWithCapacity:self.searchArray.count];
    CGRect rect = CGRectZero;
    for (int j = 0; j < self.searchArray.count; j++) {
        do {
            int x,y;
            x = arc4random() % 301;
            y = arc4random() % 370 + 60;
            if ((x + buttonwidth < 300) && (y + buttonheight < 460)) {
                
            }
             rect = CGRectMake(0, 0, buttonwidth, buttonheight);
            
        } while (![rectArray containsObject:[NSValue valueWithCGRect:rect]] && (rect.origin.x + buttonwidth ));
    }
     */
//    int i = 1;
    int nameNum;
    NSMutableArray *namesNum = [NSMutableArray arrayWithCapacity:9];
    
    for (int i = 0; i < 9; i++) {
        do {
            nameNum = arc4random() % 9;
            [namesNum addObject:[NSString stringWithFormat:@"%d",nameNum]];
        } while (![namesNum containsObject:[NSString stringWithFormat:@"%d",nameNum]]);
    }
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(30 + buttonwidth * i, 100 + buttonheight * j, buttonwidth, buttonheight);
            NSString *str =[self.searchArray objectAtIndex:[[namesNum  objectAtIndex:(i * 3 + j)] intValue]];
            NSLog(@"str=%@",str);
            [button setTitle: str forState:UIControlStateNormal];
            [self.buttonBG addSubview:button];
            button.tag = i * 3 + j + 2000;
            [button addTarget:self action:@selector(hotSearchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)hotSearchButtonPressed:(UIButton *)btn
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDataOver:) name:@"searchData" object:nil];
    [[Model shareModel] parseSearchData:[self.searchArray objectAtIndex:btn.tag - 2000]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)search:(UIButton *)button
{
    [self.searchTextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDataOver:) name:@"searchData" object:nil];
    [[Model shareModel] parseSearchData:self.searchTextField.text];
}

- (void)searchDataOver:(NSNotification *)notification
{
    NSMutableArray *searchArray = (NSMutableArray *)notification.object;
    if (searchArray.count == 0) {
        MBProgressHUD *hint = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hint];
        hint.labelText = @"没有搜索到相关作品";
        hint.mode = MBProgressHUDModeText;
//        hint.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"close.png"]];
        [hint showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hint removeFromSuperview];
        }];
    }else {
        self.searchTableView.data = searchArray;
        self.searchTableView.hidden = NO;
        self.buttonBG.hidden = YES;
        [self.searchTableView reloadData];
    }
}

//#pragma mark -UITextField delegate
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self.searchTextField resignFirstResponder];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view != self.searchTextField) {
        [self.searchTextField resignFirstResponder];
    }
}

#pragma mark - 返回按钮响应事件
-(void)backToPreviousVC:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailDataOver:) name:@"DetailVCData" object:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[Model shareModel] parseDetailData:[[self.searchTableView.data objectAtIndex:indexPath.row] objectForKey:@"id"]];
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
    [self.navigationController pushViewController:detailVC animated:NO];
}

@end
