//
//  Model.h
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-6.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "CommonCrypto/CommonCryptor.h"
@interface Model : NSObject

@property (strong, nonatomic) NSMutableArray *homeDataArray;
@property (strong, nonatomic) NSMutableArray *rankListDataArray;
@property (strong, nonatomic) NSMutableArray *bookBagDataArray;
@property (strong, nonatomic) NSMutableArray *categoryDataArray;
/**
 *  评论数据数组
 */
@property (strong, nonatomic) NSMutableArray *commentsData;
@property (strong, nonatomic) NSMutableArray *comments;

- (void)parseHomeData;
- (void)parseRankListData;
- (void)parseBookBagData;
- (void)parseCategoryData;
- (void)parseCategoryDetailInfoData:(NSString *)idStr;
- (void)parseDetailData:(NSString *)carttonID;
- (void)parseContentDataWithCartoonBookID:(NSString *)bookID andWithHuaID:(NSString *)huaID;
- (void)parseSearchData:(NSString *)searchStr;
- (void)parseHotSearchData;
- (void)parseClassData:(NSString *)carttonId;
/**
 *  请求评论数据
 *
 *  @param bookID 书籍ID
 */
- (NSArray *)parseCommentData:(NSString *)bookID;
/**
 *  请求章节数据
 *
 *  @param bookID 书籍ID
 */
- (void)parseChapterData:(NSString *)bookID;
+ (Model *)shareModel;
+ (FMDatabase *)shareBookDataBase;
+ (FMDatabase *)shareDownloadDataBase;
@end
