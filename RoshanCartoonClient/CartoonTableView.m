//
//  CartoonTableView.m
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-22.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "CartoonTableView.h"
#import "RSCell.h"
#import "SDImageView+SDWebCache.h"
@implementation CartoonTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        // Initialization code
        self.dataSource = self;
//        self.delegate = self;
        self.rowHeight = 112;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    RSCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[RSCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSLog(@"self.data%@",self.data);
    [cell.coverImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/%@",[[self.data objectAtIndex:indexPath.row] objectForKey:@"eimg"]]]];
    cell.nameLabel.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.authorLabel.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"authorname"];
    cell.categoryLabel.text = [[self.data objectAtIndex:indexPath.row] objectForKey:@"category"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

@end
