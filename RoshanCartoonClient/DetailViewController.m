//
//  DetailViewController.m
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-6.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "constant.h"
#import "RSCell.h"
#import "SDImageView+SDWebCache.h"
#import "FMDatabaseAdditions.h"
#import "MBProgressHUD.h"
#import "ThemeButton.h"
#import "Reachability.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

+ (DetailViewController *)shareDetailViewController
{
    static DetailViewController *detailVC = nil;
    if (detailVC == nil) {
        detailVC = [[DetailViewController alloc]init];
    }
    return detailVC;
}

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
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.welcomeVC.customTabBarC hideTabBar:YES];
    _shareTitle = @"iPhone漫画客户端";
    _shareString = [NSString stringWithFormat:@"小伙伴们快来试试iPhone漫画客户端~\(≧▽≦)/~啦啦啦！我正在看%@",[self.dic objectForKey:@"name"]];
    _webpageUrl = @"https://github.com/pibao2013/RoshanCartoonClient";
    [self _initSubView];
    
    //阅读界面注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestReadVCDataOver:) name:@"readVCData" object:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _commences = [[Model shareModel] parseCommentData:[self.dic objectForKey:@"id"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.commentTableView reloadData];
        });
    });
    _chapters = @[[NSString stringWithFormat:@"%@第一话",[self.dic objectForKey:@"name"]]];
//    _commences = [[Model shareModel] parseCommentData:[self.dic objectForKey:@"id"]];
//    [self.commentTableView reloadData];

    
    self.chapterTableView.dataSource = self;
    self.chapterTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.coverImageView.userInteractionEnabled = YES;
}
//初始化子视图
- (void)_initSubView
{
//    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 30, 30)];
//    [self.backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    self.backButton = [[ThemeButton alloc] initWithBackground:@"back@2x.png"];
    self.backButton.frame = CGRectMake(20, 20, 30, 30);
    self.backButton.showsTouchWhenHighlighted = YES;
    [self.backButton addTarget:self action:@selector(backToPreviousVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    //打开图片的交互
    self.coverImageView.userInteractionEnabled = YES;
    
    self.chapterTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 246, 320, 568 - 242) style:UITableViewStylePlain];
    [self.view addSubview:self.chapterTableView];
    self.chapterTableView.tag = 10000;
    self.chapterTableView.hidden = YES;
    
    self.commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 246, 320, 568 - 242) style:UITableViewStylePlain];
    [self.view addSubview:self.commentTableView];
    self.commentTableView.tag = 10001;
    self.commentTableView.hidden = YES;
    
    NSString *urlStr = [self.dic objectForKey:@"eimg"];
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/%@",urlStr]];
    [self.coverImageView setImageWithURL:url];
    
    self.nameLabel.text = [self.dic objectForKey:@"name"];
    NSString *author = [self.dic objectForKey:@"authorname"];
    if (author.length == 0) {
        author = @"匿名";
    }
    self.authorLabel.text = author;
    self.categoryLabel.text = [self.dic objectForKey:@"category"];
    
    NSString *info = [self.dic objectForKey:@"info"];
    if (info.length == 0) {
        info = @"暂无简介，等待补充……";
    }
    self.detailInfoTextView.text = info;
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

-(void)backToPreviousVC:(UIButton *)button
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.welcomeVC.customTabBarC hideTabBar:NO];
    [self.navigationController popViewControllerAnimated:NO];
}

//收藏功能
- (IBAction)collect:(id)sender {
    _bookBagVC = [BookBagViewController shareBookBagViewController];
    NSLog(@"_bookBagVC.bookBagDatabase=%@",_bookBagVC.bookBagDatabase);
    if ([_bookBagVC.bookBagDatabase open]) {
//        NSLog(@"成功打开数据库");
        if (![_bookBagVC.bookBagDatabase tableExists:@"bookBagTable"]) {
            NSString *creatTable = @"CREATE TABLE bookBagTable(name text,authorname text,category text,eimg blob,id text,info text,read_url text)";
            if ([_bookBagVC.bookBagDatabase executeUpdate:creatTable]) {
//                NSLog(@"创建收藏表格成功");
            }
        }
        //查询表中是否已包含该漫画书数据
        NSString *selectSql = @"SELECT * FROM bookBagTable";
        FMResultSet *result = [_bookBagVC.bookBagDatabase executeQuery:selectSql];
        NSString *tempIdStr = nil;
        NSMutableArray *tempArray = [NSMutableArray array];
        while ([result next]) {
            tempIdStr = [result stringForColumn:@"id"];
            [tempArray addObject:tempIdStr];
        }
        if (![tempArray containsObject:[self.dic objectForKey:@"id"]]) {
            
            
//            NSString *author = [self.dic objectForKey:@"authorname"];
//            if (author.length == 0) {
//                author = @"匿名";
//            }
//            NSString *info = [self.dic objectForKey:@"info"];
//            if (info.length == 0) {
//                info = @"暂无简介，等待补充……";
//            }
            
//            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectZero];
//            [imgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/%@",[self.dic objectForKey:@"eimg"]]]];
//            NSData *imgData = UIImagePNGRepresentation(imgV.image);
            SDWebDataManager *sdWebDataManager = [SDWebDataManager sharedManager];
            [sdWebDataManager downloadWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/%@",[self.dic objectForKey:@"eimg"]]] delegate:self refreshCache:YES retryFailed:YES];
            }else {
            NSLog(@"已经收藏过了");
            MBProgressHUD *hint = [[MBProgressHUD alloc]initWithView:self.view];
            [self.view addSubview:hint];
            hint.labelText = @"已经收藏过了";
            hint.mode = MBProgressHUDModeText;
            
            [hint showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [hint removeFromSuperview];
            }];
        }
    }else {
        NSLog(@"未能成功打开");
        MBProgressHUD *hint = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hint];
        hint.labelText = @"未能成功打开数据库";
        hint.mode = MBProgressHUDModeText;
        
        [hint showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hint removeFromSuperview];
        }];
    }
}


- (void)webDataManager:(SDWebDataManager *)dataManager didFinishWithData:(NSData *)aData isCache:(BOOL)isCache
{
    NSString *insertSql = @"INSERT INTO bookBagTable(name,authorname,category,eimg,id,info,read_url) VALUES(?,?,?,?,?,?,?)";
    
    if ([_bookBagVC.bookBagDatabase executeUpdate:insertSql,[self.dic objectForKey:@"name"],[self.dic objectForKey:@"authorname"],[self.dic objectForKey:@"category"],aData,[self.dic objectForKey:@"id"],[self.dic objectForKey:@"info"],[self.dic objectForKey:@"read_url"]]) {
        
        [_bookBagVC.bookBagArray addObject:self.dic];
        
        MBProgressHUD *hint = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hint];
        hint.labelText = @"收藏成功";
        hint.mode = MBProgressHUDModeText;
        [hint showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hint removeFromSuperview];
        }];
    }else {
        MBProgressHUD *hint = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hint];
        hint.labelText = @"收藏失败";
        hint.mode = MBProgressHUDModeText;
        [hint showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hint removeFromSuperview];
        }];
        //                NSLog(@"收藏失败");
    }
}

#pragma mark - 按钮响应方法
- (IBAction)selectFunction:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if (seg.selectedSegmentIndex == 0) {
        self.detailInfoTextView.hidden = NO;
        self.chapterTableView.hidden = YES;
        self.commentTableView.hidden = YES;
    }else if (seg.selectedSegmentIndex == 1) {
        self.detailInfoTextView.hidden = YES;
        self.chapterTableView.hidden = NO;
        self.commentTableView.hidden = YES;
        [self.chapterTableView reloadData];
    }else if (seg.selectedSegmentIndex == 2) {
        self.detailInfoTextView.hidden = YES;
        self.chapterTableView.hidden = YES;
        self.commentTableView.hidden = NO;
    }
}

#pragma mark - 分享
- (IBAction)share:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"分享"
        delegate:self
        cancelButtonTitle:@"取消"
        destructiveButtonTitle:nil
        otherButtonTitles:@"微信好友",@"微信朋友圈", @"易信好友", @"易信朋友圈", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

#pragma mark - 下载
- (IBAction)download:(id)sender {
    NSMutableDictionary *downloadDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"downloadDic"]];
    if ([downloadDic objectForKey:[self.dic objectForKey:@"id"]]) {
        MBProgressHUD *hint = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hint];
        hint.labelText = @"已经下载了";
        hint.mode = MBProgressHUDModeText;
        [hint showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hint removeFromSuperview];
        }];
        return;
    }
    else if (downloadDic == nil) {
        downloadDic = [NSMutableDictionary dictionary];
        [downloadDic setObject:self.dic forKey:[self.dic objectForKey:@"id"]];
        [[NSUserDefaults standardUserDefaults] setObject:downloadDic forKey:@"downloadDic"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"download" object:self.dic];
    }else {
        [downloadDic setObject:self.dic forKey:[self.dic objectForKey:@"id"]];
        [[NSUserDefaults standardUserDefaults] setObject:downloadDic forKey:@"downloadDic"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"download" object:self.dic];
    }
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else if (buttonIndex == 0) {
        /**
         self.sinaWeibo = [[SinaWeibo alloc]initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
        if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
        {
            _sinaWeibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
            _sinaWeibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
            _sinaWeibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        }
        //若直接在这儿调用[_sinaWeibo logIn]，授权页面则会一闪而过，得延迟一段时间，而且不能短了
        [self performSelector:@selector(sinaLog) withObject:nil afterDelay:0.5];
         */
        [self shareNewsToWeiXin:0];
    }else if (buttonIndex == 1) {
        [self shareNewsToWeiXin:1];
    }else if (buttonIndex == 2) {
        [self shareNewsToYiXin:0];
    }else if (buttonIndex == 3) {
        [self shareNewsToYiXin:1];
    }
}

#pragma mark --- 分享新闻到微信
/**
 *  分享新闻到微信
 *
 *  @param scene 0 好友， 1 朋友圈
 */
- (void)shareNewsToWeiXin:(int)scene
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = _shareTitle;
        message.description = _shareString;
        [message setThumbImage:[UIImage imageNamed:@"HBicon.png"]];
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = _webpageUrl;
        message.mediaObject = ext;
        req.bText = NO;
        req.message = message;
        //            req.text = _shareString;
        req.scene = scene;
        [WXApi sendReq:req];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"目前您的微信版本过低或未安装微信,需要安装微信才能使用" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

#pragma mark --- 分享新闻到易信
/**
 *  分享新闻到易信
 *
 *  @param scene 0 好友， 1 朋友圈
 */
- (void)shareNewsToYiXin:(int)scene
{
    if ([YXApi isYXAppInstalled] && [YXApi isYXAppSupportApi]) {
        YXWebpageObject *pageObject = [YXWebpageObject object];
        pageObject.webpageUrl = _webpageUrl;
        YXMediaMessage *message = [YXMediaMessage message];
        message.title = _shareTitle;
        message.description = _shareString;
        NSData *thumImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"HBicon.png"], 1.f);
        [message setThumbData:thumImageData];
        message.mediaObject = pageObject;
        SendMessageToYXReq *req = [[SendMessageToYXReq alloc] init];
        req.bText = NO;
        req.scene = scene;
        req.message = message;
        [YXApi sendReq:req];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"目前您的易信版本过低或未安装易信,需要安装易信才能使用" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)sinaLog
{
    [_sinaWeibo logIn];
}


#pragma mark -UITableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 10000) {
        return _chapters.count;
    }else {
        return _commences.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 10000) {
        static NSString *chapterCellIdentifier = @"chapterCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chapterCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chapterCellIdentifier];
        }
        cell.textLabel.text = [_chapters objectAtIndex:indexPath.row];

        return cell;
    }else {
        static NSString *commantCellIdentifier = @"commantCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commantCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:commantCellIdentifier];
        }
        cell.textLabel.text = [[_commences objectAtIndex:indexPath.row] objectForKey:@"commence"];
        cell.detailTextLabel.text = [[_commences objectAtIndex:indexPath.row] objectForKey:@"add_time"];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 10000) {
        [self readBook];
    }
}

/*
#pragma mark -SinaWeibo delegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"成功登陆新浪微博");
    //保存认证的数据到本地
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate,
                              @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SinaWeiboViewController *sinaWeiboVC = [[SinaWeiboViewController alloc]init];
    sinaWeiboVC.sinaWeibo = self.sinaWeibo;
    sinaWeiboVC.dic = self.dic;
    [self.navigationController pushViewController:sinaWeiboVC animated:YES];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"error = %@",[error localizedDescription]);
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    
}
 */

#pragma mark - 点击图片阅读
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == self.coverImageView) {
        [self readBook];
    }
}

- (void)readBook
{
    self.coverImageView.userInteractionEnabled = NO;
    NSString *tempId = [self.dic objectForKey:@"id"];
    NSString *tempHuaId = [self.dic objectForKey:@"huaID"];
    
    if (tempId.length > 0 && tempHuaId.length > 0) {
        [[Model shareModel] parseContentDataWithCartoonBookID:tempId andWithHuaID:tempHuaId];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息不全" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        self.coverImageView.userInteractionEnabled = YES;
    }

}
#pragma mark - 阅读页面数据通知
- (void)requestReadVCDataOver:(NSNotification *)notification
{
    NSDictionary *dic = (NSDictionary *)notification.object;
    [self performSelectorOnMainThread:@selector(goForwardToReadVC:) withObject:dic waitUntilDone:YES];
}

- (void)goForwardToReadVC:(NSDictionary *)dic
{
    self.readVC = [[ReadViewController alloc]init];
    self.readVC.dic = dic;
    [self.navigationController pushViewController:self.readVC animated:YES];
}
@end
