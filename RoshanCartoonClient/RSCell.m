//
//  RSCell.m
//  笔多漫画
//
//  Created by 方辉 on 13-11-1.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "RSCell.h"

@implementation RSCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 74, 85)];
        self.coverImageView.layer.cornerRadius = 10;
        [self addSubview:self.coverImageView];
        
        self.shuming = [[UILabel alloc]initWithFrame:CGRectMake(92, 4, 42, 29)];
        self.shuming.text = @"书名:";
        [self addSubview:self.shuming];
        
        self.zuozhe = [[UILabel alloc]initWithFrame:CGRectMake(92, 35, 42, 29)];
        self.zuozhe.text = @"作者:";
        [self addSubview:self.zuozhe];
        
        self.fenlei = [[UILabel alloc]initWithFrame:CGRectMake(92, 63, 42, 29)];
        self.fenlei.text = @"类别:";
        [self addSubview:self.fenlei];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(142, 4, 167, 29)];
        [self addSubview:self.nameLabel];
        
        self.authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(142, 35, 167, 29)];
        [self addSubview:self.authorLabel];
        
        self.categoryLabel =  [[UILabel alloc]initWithFrame:CGRectMake(142, 63, 167, 29)];
        [self addSubview:self.categoryLabel];
        
        self.shelfImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 93, 320, 19)];
        self.shelfImageView.image = [UIImage imageNamed:@"shelf"];
        [self addSubview:self.shelfImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
