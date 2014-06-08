//
//  DownloadCell.m
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-30.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "DownloadCell.h"
@implementation DownloadCell
@synthesize currentPage,progressView,progressLabel,startOrPausebutton;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self _initSubView];
        currentPage = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"download_id_%@",[self.cartoonDic objectForKey:@"id"]]] intValue];
        
        if (_networkQueue == nil) {
            _networkQueue = [[ASINetworkQueue alloc]init];
        }
        
        [_networkQueue reset];
        [_networkQueue setDelegate:self];
        [_networkQueue setDownloadProgressDelegate:progressView];
        [_networkQueue go];
    }
    return self;
}

//初始化子视图
- (void)_initSubView
{
//    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
//    [self addSubview:self.nameLabel];
    //封面
    self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 74, 85)];
    self.coverImageView.layer.cornerRadius = 10;
    [self addSubview:self.coverImageView];
    //下载进度Label
    progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 80, 20)];
    progressLabel.text = @"0.00%";
    [self addSubview:progressLabel];
    //下载进度条
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(100, 30, 100, 30)];
    [self addSubview:progressView];
    //开始或暂停button
    startOrPausebutton = [UIButton buttonWithType:UIButtonTypeSystem];
    startOrPausebutton.frame = CGRectMake(280, 35, 40, 40);
    [self addSubview:startOrPausebutton];
    [startOrPausebutton setTitle:@"开始" forState:UIControlStateNormal];
    [startOrPausebutton addTarget:self action:@selector(startOrPause:) forControlEvents:UIControlEventTouchUpInside];
    //书架图片
    UIImageView *shelfImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 95, 320, 19)];
    shelfImageView.image = [UIImage imageNamed:@"shelf"];
    [self addSubview:shelfImageView];
}

- (void)getCartoonTotalPageCount
{
//    NSLog(@"self.cartoonDic = %@",self.cartoonDic);
    NSString *bookID = [self.cartoonDic objectForKey:@"id"];
    NSString *huaID = [self.cartoonDic objectForKey:@"huaID"];
    assert(bookID != nil && huaID != nil);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getReadVCData:) name:@"readVCData" object:nil];
    [[Model shareModel] parseContentDataWithCartoonBookID:bookID andWithHuaID:huaID];
}

- (void)getReadVCData:(NSNotification *)notification
{
    NSDictionary *readDic = (NSDictionary *)notification.object;
    [self performSelectorOnMainThread:@selector(turnMainThread:) withObject:readDic waitUntilDone:YES];
}

- (void)turnMainThread:(NSDictionary *)dic
{
    self.totalPage = [[dic objectForKey:@"SceneCount"] intValue];
    NSLog(@"self.totalPage%d",self.totalPage);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)startOrPause:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"开始"]) {
        [button setTitle:@"暂停" forState:UIControlStateNormal];
        [self download];
    }else {
        [button setTitle:@"开始" forState:UIControlStateNormal];
        for (ASIHTTPRequest *request in [_networkQueue operations]) {
            [request clearDelegatesAndCancel];
        }
    }
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

- (void)download
{
    //初始化Documents路径
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //初始化临时文件路径
    NSString *folderPath = [docPath stringByAppendingPathComponent:@"temp"];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断temp文件夹是否存在
    BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
    if (!fileExists) {//如果不存在说创建,因为下载时,不会自动创建文件夹
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //初始化下载路径
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/img.php?imgsize=3204800&chapterid=%@&name=k%04d0",[self.cartoonDic objectForKey:@"huaID"],currentPage]];
    //初始化request
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    //设置超时时间
    [request setTimeOutSeconds:60 * 2];
    //设置ASIHTTPRequest代理
	request.delegate = self;
    //每张图片的名字
    NSLog(@"self.cartoonDic=%@",self.cartoonDic);
    NSString *flag = [NSString stringWithFormat:@"%@_%@_%d.jpg",[self.cartoonDic objectForKey:@"name"],[self.cartoonDic objectForKey:@"huaID"],currentPage];
    //初始化保存文件的路径
    NSString *savePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",flag]];
    //初始化临时文件路径
    NSString *tempPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",flag]];
    //设置文件保存路径
	[request setDownloadDestinationPath:savePath];
	//设置临时文件路径
	[request setTemporaryFileDownloadPath:tempPath];
	//设置进度条的代理,
	[request setDownloadProgressDelegate:progressView];
	//设置是是否支持断点下载
	[request setAllowResumeForFileDownloads:YES];
    //设置基本信息
	[request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:currentPage],@"bookID",nil]];
    //添加到ASINetworkQueue队列去下载
	[_networkQueue addOperation:request];
	//收回request
	[request release];
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate method

//ASIHTTPRequestDelegate,下载之前获取信息的方法,主要获取下载内容的大小
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
	//NSLog(@"didReceiveResponseHeaders-%@",[responseHeaders valueForKey:@"Content-Length"]);
    //查找以前是否保存过 具体对象 内容的大小
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithFloat:request.contentLength/1024.0/1024.0] forKey:[NSString stringWithFormat:@"cartoon_%@_%@_contentLength",[self.cartoonDic objectForKey:@"id"],[self.cartoonDic objectForKey:@"huaID"]]];
    //
    //			float tempConLen = [[userDefaults objectForKey:[NSString stringWithFormat:@"book_%d_contentLength",currentPage]] floatValue];
    //
    //			if (tempConLen == 0 ) {//如果没有保存,则持久化他的内容大小
    //				[userDefaults setObject:[NSNumber numberWithFloat:request.contentLength/1024.0/1024.0] forKey:[NSString stringWithFormat:@"book_%d_contentLength",currentPage]];
    //			}
}

//ASIHTTPRequestDelegate,下载完成时,执行的方法
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"finish");
    if (currentPage < self.totalPage) {
        currentPage++;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:[NSString stringWithFormat:@"download_id_%@",[self.cartoonDic objectForKey:@"id"]]];
        progressView.progress = currentPage * 1.00 / self.totalPage;
        progressLabel.text = [NSString stringWithFormat:@"%.2f%%",[progressView progress] * 100];
        if ((int)progressView.progress == 1) {
            [startOrPausebutton setTitle:@"完成" forState:UIControlStateNormal];
            startOrPausebutton.enabled = NO;
        }
        [self download];
    }
}

//ASIHTTPRequestDelegate,下载失败
- (void)requestFailed:(ASIHTTPRequest *)request {
	NSLog(@"down fail.....");
    NSError *error = [request error];
    NSLog(@"error = %@",[error localizedDescription]);
}

-(void)dealloc
{
    [_nameLabel release];
    [_coverImageView release];
    [_networkQueue release];
    [_cartoonDic release];
    [progressView release];
    [progressLabel release];
    [startOrPausebutton release];
    [super dealloc];
}

@end