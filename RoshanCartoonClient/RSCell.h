//
//  RSCell.h
//  笔多漫画
//
//  Created by 方辉 on 13-11-1.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *coverImageView, *shelfImageView;
@property (strong, nonatomic) UILabel *nameLabel, *authorLabel, *categoryLabel, *shuming, *zuozhe, *fenlei;
@end
