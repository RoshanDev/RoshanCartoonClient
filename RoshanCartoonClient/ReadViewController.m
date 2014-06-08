//
//  ReadViewController.m
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-15.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "ReadViewController.h"
#import "SDImageView+SDWebCache.h"
@interface ReadViewController ()

@end

@implementation ReadViewController

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
//    self.currentPage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"pageName"] intValue];
    self.currentPage = 1;
    
    [self _initSubView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_initSubView
{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 85)];
    [self.view addSubview:self.topView];
    
    //返回按钮
    self.backButton = [[ThemeButton alloc] initWithBackground:@"back@2x.png"];
    self.backButton.frame = CGRectMake(20, 20, 30, 30);

    self.backButton.showsTouchWhenHighlighted = YES;
    [self.backButton addTarget:self action:@selector(backToPreviousVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.backButton];
    
    //下页按钮
    self.nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nextButton.frame = CGRectMake(280, 42, 40, 40);
    [self.nextButton setTitle:@"下页" forState:UIControlStateNormal];
    [self.topView addSubview:self.nextButton];
    [self.nextButton addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    
    //上页按钮
    self.previousButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.previousButton.frame = CGRectMake(10, 42, 40, 40);
    [self.previousButton setTitle:@"上页" forState:UIControlStateNormal];
    [self.topView addSubview:self.previousButton];
    [self.previousButton addTarget:self action:@selector(previousPage:) forControlEvents:UIControlEventTouchUpInside];
    
    //进度条
    self.progressSlider = [[UISlider alloc]initWithFrame:CGRectMake(90, 48, 160, 25)];
    self.progressSlider.minimumValue = 1;
    self.progressSlider.maximumValue = [[self.dic valueForKey:@"scenes"] count];
    //    self.progressSlider.maximumValue = [[self.dic objectForKey:@"SceneCount"] intValue];
    [self.topView addSubview:self.progressSlider];
    [self.progressSlider addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(113, 20, 95, 30)];
    titleLabel.text = [self.dic valueForKey:@"book_title"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:titleLabel];
    
    //内容图片
    self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 80, 280, 568 - 80 - 20)];
//    self.contentImageView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.contentImageView];
    self.contentImageView.userInteractionEnabled = YES;
    
    [self.contentImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/img.php?imgsize=3204800&chapterid=%@&name=%@",[self.dic valueForKey:@"chapterid"],@"k00000"]]];
    
}

- (NSString *)getCurrentPageName:(int)currentPageCount
{
    NSString *pageName = [NSString stringWithFormat:@"%d0",currentPageCount - 1];
    int numberOfZero = 5 - pageName.length;
    while (numberOfZero != 0) {
        pageName = [NSString stringWithFormat:@"0%@",pageName];
        numberOfZero--;
    }
    pageName = [NSString stringWithFormat:@"k%@",pageName];
    return pageName;
}

- (void)nextPage:(UIButton *)button
{
    if (++self.currentPage < [[self.dic valueForKey:@"scenes"] count]) {
        self.progressSlider.value = self.currentPage;
        NSString *pageName = [self getCurrentPageName:self.currentPage];
        [self.contentImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/img.php?imgsize=3204800&chapterid=%@&name=%@",[self.dic valueForKey:@"chapterid"],pageName]]];
        //动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.contentImageView cache:YES];
        [UIView commitAnimations];
    }else {
        self.currentPage--;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经是最后一页了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)previousPage:(UIButton *)button
{
    if (--self.currentPage > 0) {
        NSString *pageName = [self getCurrentPageName:self.currentPage];
        self.progressSlider.value = self.currentPage;
        [self.contentImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/img.php?imgsize=3204800&chapterid=%@&name=%@",[self.dic valueForKey:@"chapterid"],pageName]]];
        //动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.contentImageView cache:YES];
        [UIView commitAnimations];
    } else {
        self.currentPage++;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经是第一页了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)changePage:(UISlider *)slider
{
    self.currentPage = self.progressSlider.value;
    NSString *pageName = [self getCurrentPageName:self.currentPage];
    [self.contentImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/img.php?imgsize=3204800&chapterid=%@&name=%@",[self.dic valueForKey:@"chapterid"],pageName]]];
}

#pragma mark - 返回按钮响应事件
-(void)backToPreviousVC:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == self.contentImageView) {
        CGPoint point = [touch locationInView:self.contentImageView];
        if (point.y > 119 || point.y < 119 + 329) {
            if (point.x > 89 && point.x < 89 + 142) {
                if (_topView.frame.origin.y < 0) {
                    [UIView animateWithDuration:0.3 animations:^{
                        _topView.frame = CGRectMake(0, 0, 320, 85);
                    }];
                }else {
                    [UIView animateWithDuration:0.3 animations:^{
                        _topView.frame = CGRectMake(0, -100, 320, 85);
                    }];
                }
            }else {
                if (point.x < 89) {
                    [self previousPage:nil];
                }else if (point.x > 89 + 142) {
                    [self nextPage:nil];
                }
            }
        }
    }
}
@end
