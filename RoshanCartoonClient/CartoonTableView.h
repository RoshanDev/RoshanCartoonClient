//
//  CartoonTableView.h
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-22.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartoonTableView : UITableView<UITableViewDataSource>

//数据源
@property (strong, nonatomic) NSMutableArray *data;

@end
