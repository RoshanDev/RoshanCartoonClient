//
//  Model.m
//  笔多漫画客户端
//
//  Created by 方辉 on 13-11-6.
//  Copyright (c) 2013年 方辉. All rights reserved.
//

#import "Model.h"
#import "GDataXMLNode.h"
#import "SDImageView+SDWebCache.h"
#import "SBJSON.h"
#import "CommonFunc.h"
#import "GTMBase64.h"

@implementation Model

+ (Model *)shareModel
{
    static Model *model = nil;
    if (model == nil) {
        model = [[Model alloc]init];
    }
    return model;
}

+ (FMDatabase *)shareBookDataBase
{
    static FMDatabase *bookDataBase = nil;
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [documents objectAtIndex:0];
    NSLog(@"documentsPath=%@",documentsPath);
    if (bookDataBase == nil) {
        bookDataBase = [FMDatabase databaseWithPath:@"/tmp/tmp.db"];
    }
    return bookDataBase;
}

+ (FMDatabase *)shareDownloadDataBase
{
    static FMDatabase *downloadBataBase = nil;
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [documents objectAtIndex:0];
    NSLog(@"documentsPath=%@",documentsPath);
    if (downloadBataBase == nil) {
        downloadBataBase = [FMDatabase databaseWithPath:[documentsPath stringByAppendingString:@"downloadDataBase.db"]];
    }
    return downloadBataBase;
}

//获取首页数据
- (void)parseHomeData
{
    NSURL *url = [NSURL URLWithString:@"http://iphonenew.ecartoon.net/tuijian.php"];
    NSLog(@"url=%@",url);
    [NSThread detachNewThreadSelector:@selector(requestHomeData:) toTarget:self withObject:url];
}

- (void)requestHomeData:(NSURL *)url
{
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if (!error) {
        self.homeDataArray = [NSMutableArray arrayWithArray:[self parseXMLDataToGetArray:data]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"homeData" object:self.homeDataArray];
    }
}

//获取排行数据
- (void)parseRankListData
{
    NSURL *url = [NSURL URLWithString:@"http://iphonenew.ecartoon.net/book_list.php?sub=1"];
    NSLog(@"url=%@",url);
    [NSThread detachNewThreadSelector:@selector(requestRankListData:) toTarget:self withObject:url];
}

- (void)requestRankListData:(NSURL *)url
{
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if (!error) {
        self.rankListDataArray = [NSMutableArray array];
        
        [self.rankListDataArray addObjectsFromArray:[self parseXMLDataToGetArray:data]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rankList" object:self.rankListDataArray];
        
//        NSArray *recordsArray = [rootElement elementsForName:@"records"];
//        GDataXMLElement *recordsElement = [recordsArray objectAtIndex:0];
//        NSString *records = [recordsElement stringValue];
//        [self.rankListDataArray addObject:records];
//        
//        NSArray *pagecountArray = [rootElement elementsForName:@"pagecount"];
//        GDataXMLElement *pagecountElement = [pagecountArray objectAtIndex:0];
//        NSString *pagecount = [pagecountElement stringValue];
//        [self.rankListDataArray addObject:pagecount];
        
    }
}

//请求详细数据
- (void)parseDetailData:(NSString *)carttonID
{
    [self performSelectorInBackground:@selector(requestDetailVCData:) withObject:carttonID];
}

- (void)requestDetailVCData:(NSString *)carttonID
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/book_index.php?id=%@",carttonID]];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:data options:0 error:nil];
    GDataXMLElement *rootElement = [document rootElement];
//    NSLog(@"rootElement:%@",rootElement);
    //ID
    NSArray *elementIDArray = [rootElement nodesForXPath:@"book_info/id" error:nil];
    NSMutableArray *idArray = [NSMutableArray arrayWithCapacity:elementIDArray.count];
    for (GDataXMLElement *element in elementIDArray) {
        [idArray addObject:[element stringValue]];
    }
    if (idArray.count == 0) {
        NSLog(@"idArray= %@",idArray);
        NSLog(@"id为空");
        return;
    }
    NSString *idStr = [idArray objectAtIndex:0];
    
    //书名
    NSArray *elementCartoonNameArray = [rootElement nodesForXPath:@"book_info/name" error:nil];
    NSMutableArray *cartoonNameArray = [NSMutableArray arrayWithCapacity:elementCartoonNameArray.count];
    for (GDataXMLElement *element in elementCartoonNameArray) {
        [cartoonNameArray addObject:[element stringValue]];
    }
    NSString *cartoonNameStr = [cartoonNameArray objectAtIndex:0];
    
    //作者
    NSArray *elementAuthorArray = [rootElement nodesForXPath:@"book_info/author" error:nil];
    NSMutableArray *authorArray = [NSMutableArray arrayWithCapacity:elementAuthorArray.count];
    for (GDataXMLElement *element in elementAuthorArray) {
        [authorArray addObject:[element stringValue]];
    }
    NSString *authorStr = [authorArray objectAtIndex:0];
    
    //简介
    NSArray *elementInfoArray = [rootElement nodesForXPath:@"book_info/info" error:nil];
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:elementInfoArray.count];
    for (GDataXMLElement *element in elementInfoArray) {
        [infoArray addObject:[element stringValue]];
    }
    NSString *infoStr = [infoArray objectAtIndex:0];
    
    //作品封面图片
    NSArray *elementEimgArray = [rootElement nodesForXPath:@"book_info/eimg" error:nil];
    NSMutableArray *eimgArray = [NSMutableArray arrayWithCapacity:elementEimgArray.count];
    for (GDataXMLElement *element in elementEimgArray) {
        [eimgArray addObject:[element stringValue]];
    }
    NSString *eimgStr = [eimgArray objectAtIndex:0];
    
    //作品打分
    NSArray *elementGradeArray = [rootElement nodesForXPath:@"book_info/grade" error:nil];
    NSMutableArray *gradeArray = [NSMutableArray arrayWithCapacity:elementAuthorArray.count];
    for (GDataXMLElement *element in elementGradeArray) {
        [gradeArray addObject:[element stringValue]];
    }
    NSString *gradeStr = [gradeArray objectAtIndex:0];
    
    //作品默认第一话的阅读接口
    NSArray *elementRead_urlArray = [rootElement nodesForXPath:@"book_info/read_url" error:nil];
    NSMutableArray *read_urlArray = [NSMutableArray arrayWithCapacity:elementRead_urlArray.count];
    for (GDataXMLElement *element in elementRead_urlArray) {
        [read_urlArray addObject:[element stringValue]];
    }
    NSString *read_urlStr = [read_urlArray objectAtIndex:0];
    
    //作品分类
    NSArray *elementCategoryArray = [rootElement nodesForXPath:@"book_info/category" error:nil];
    NSMutableArray *categoryArray = [NSMutableArray arrayWithCapacity:elementCategoryArray.count];
    for (GDataXMLElement *element in elementCategoryArray) {
        [categoryArray addObject:[element stringValue]];
    }
    NSString *categoryStr = [categoryArray objectAtIndex:0];
    
    //话id
    NSArray *elementHuaIDArray = [rootElement nodesForXPath:@"chapter_list/item/chapter_id" error:nil];
    NSMutableArray *huaIDArray = [NSMutableArray arrayWithCapacity:elementHuaIDArray.count];
    for (GDataXMLElement *element in elementHuaIDArray) {
        [huaIDArray addObject:[element stringValue]];
    }
    NSString *huaIDStr = [huaIDArray objectAtIndex:0];
    
    //话名称
    NSArray *elementHuaNameArray = [rootElement nodesForXPath:@"chapter_list/item/name" error:nil];
    NSMutableArray *huaNameArray = [NSMutableArray arrayWithCapacity:elementHuaNameArray.count];
    for (GDataXMLElement *element in elementHuaNameArray) {
        [huaNameArray addObject:[element stringValue]];
    }
    NSString *huaNameStr = [huaNameArray objectAtIndex:0];
    
    //当前话阅读接口
    NSArray *elementView_urlArray = [rootElement nodesForXPath:@"chapter_list/item/view_url" error:nil];
    NSMutableArray *view_urlArray = [NSMutableArray arrayWithCapacity:elementView_urlArray.count];
    for (GDataXMLElement *element in elementView_urlArray) {
        [view_urlArray addObject:[element stringValue]];
    }
    NSString *view_urlStr = [view_urlArray objectAtIndex:0];
    
    NSDictionary *detailDic = [[NSDictionary alloc]initWithObjects:@[idStr,cartoonNameStr,authorStr,infoStr,eimgStr,gradeStr,read_urlStr,categoryStr,huaIDStr,huaNameStr,view_urlStr] forKeys:@[@"id",@"name",@"authorname",@"info",@"eimg",@"grade",@"read_url",@"category",@"huaID",@"huaName",@"view_url"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailVCData" object:detailDic];
}

//获取书包数据
- (void)parseBookBagData
{
    
}

- (void)parseClassData:(NSString *)carttonId
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/book_index.php?id=%@",carttonId]];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:data options:0 error:nil];
    GDataXMLElement *rootElement = [document rootElement];
    
    //ID
    NSArray *elementIDArray = [rootElement nodesForXPath:@"book_info/id" error:nil];
    NSMutableArray *idArray = [NSMutableArray arrayWithCapacity:elementIDArray.count];
    for (GDataXMLElement *element in elementIDArray) {
        [idArray addObject:[element stringValue]];
    }
    if (idArray.count == 0) {
        NSLog(@"idArray= %@",idArray);
        NSLog(@"id为空");
        return;
    }
    NSString *idStr = [idArray objectAtIndex:0];
    
    //书名
    NSArray *elementCartoonNameArray = [rootElement nodesForXPath:@"book_info/name" error:nil];
    NSMutableArray *cartoonNameArray = [NSMutableArray arrayWithCapacity:elementCartoonNameArray.count];
    for (GDataXMLElement *element in elementCartoonNameArray) {
        [cartoonNameArray addObject:[element stringValue]];
    }
    NSString *cartoonNameStr = [cartoonNameArray objectAtIndex:0];
    
    //作者
    NSArray *elementAuthorArray = [rootElement nodesForXPath:@"book_info/author" error:nil];
    NSMutableArray *authorArray = [NSMutableArray arrayWithCapacity:elementAuthorArray.count];
    for (GDataXMLElement *element in elementAuthorArray) {
        [authorArray addObject:[element stringValue]];
    }
    NSString *authorStr = [authorArray objectAtIndex:0];
    
    //简介
    NSArray *elementInfoArray = [rootElement nodesForXPath:@"book_info/info" error:nil];
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:elementInfoArray.count];
    for (GDataXMLElement *element in elementInfoArray) {
        [infoArray addObject:[element stringValue]];
    }
    NSString *infoStr = [infoArray objectAtIndex:0];
    
    //作品封面图片
    NSArray *elementEimgArray = [rootElement nodesForXPath:@"book_info/eimg" error:nil];
    NSMutableArray *eimgArray = [NSMutableArray arrayWithCapacity:elementEimgArray.count];
    for (GDataXMLElement *element in elementEimgArray) {
        [eimgArray addObject:[element stringValue]];
    }
    NSString *eimgStr = [eimgArray objectAtIndex:0];
    
    //作品打分
    NSArray *elementGradeArray = [rootElement nodesForXPath:@"book_info/grade" error:nil];
    NSMutableArray *gradeArray = [NSMutableArray arrayWithCapacity:elementAuthorArray.count];
    for (GDataXMLElement *element in elementGradeArray) {
        [gradeArray addObject:[element stringValue]];
    }
    NSString *gradeStr = [gradeArray objectAtIndex:0];
    
    //作品默认第一话的阅读接口
    NSArray *elementRead_urlArray = [rootElement nodesForXPath:@"book_info/read_url" error:nil];
    NSMutableArray *read_urlArray = [NSMutableArray arrayWithCapacity:elementRead_urlArray.count];
    for (GDataXMLElement *element in elementRead_urlArray) {
        [read_urlArray addObject:[element stringValue]];
    }
    NSString *read_urlStr = [read_urlArray objectAtIndex:0];
    
    //作品分类
    NSArray *elementCategoryArray = [rootElement nodesForXPath:@"book_info/category" error:nil];
    NSMutableArray *categoryArray = [NSMutableArray arrayWithCapacity:elementCategoryArray.count];
    for (GDataXMLElement *element in elementCategoryArray) {
        [categoryArray addObject:[element stringValue]];
    }
    NSString *categoryStr = [categoryArray objectAtIndex:0];
    
    //话id
    NSArray *elementHuaIDArray = [rootElement nodesForXPath:@"chapter_list/item/chapter_id" error:nil];
    NSMutableArray *huaIDArray = [NSMutableArray arrayWithCapacity:elementHuaIDArray.count];
    for (GDataXMLElement *element in elementHuaIDArray) {
        [huaIDArray addObject:[element stringValue]];
    }
    NSString *huaIDStr = [huaIDArray objectAtIndex:0];
    
    //话名称
    NSArray *elementHuaNameArray = [rootElement nodesForXPath:@"chapter_list/item/name" error:nil];
    NSMutableArray *huaNameArray = [NSMutableArray arrayWithCapacity:elementHuaNameArray.count];
    for (GDataXMLElement *element in elementHuaNameArray) {
        [huaNameArray addObject:[element stringValue]];
    }
    NSString *huaNameStr = [huaNameArray objectAtIndex:0];
    
    //当前话阅读接口
    NSArray *elementView_urlArray = [rootElement nodesForXPath:@"chapter_list/item/view_url" error:nil];
    NSMutableArray *view_urlArray = [NSMutableArray arrayWithCapacity:elementView_urlArray.count];
    for (GDataXMLElement *element in elementView_urlArray) {
        [view_urlArray addObject:[element stringValue]];
    }
    NSString *view_urlStr = [view_urlArray objectAtIndex:0];
    
    NSDictionary *detailDic = [[NSDictionary alloc]initWithObjects:@[idStr,cartoonNameStr,authorStr,infoStr,eimgStr,gradeStr,read_urlStr,categoryStr,huaIDStr,huaNameStr,view_urlStr] forKeys:@[@"id",@"name",@"authorname",@"info",@"eimg",@"grade",@"read_url",@"category",@"huaID",@"huaName",@"view_url"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClassVCData" object:detailDic];

}
//获取分类数据
- (void)parseCategoryData
{
    NSURL *url = [NSURL URLWithString:@"http://iphonenew.ecartoon.net/board_index.php"];
    [NSThread detachNewThreadSelector:@selector(requestCategoryData:) toTarget:self withObject:url];
}

- (void)requestCategoryData:(NSURL *)url
{
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if (!error) {
        self.categoryDataArray = [NSMutableArray array];
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:data options:0 error:nil];
        GDataXMLElement *rootElement = [document rootElement];
        NSArray *rootArray = [rootElement elementsForName:@"item"];
        GDataXMLElement *idElement, *nameElement, *linkElement;
        for (GDataXMLElement *element in rootArray) {
            NSArray *idArray = [element elementsForName:@"id"];
            idElement = [idArray objectAtIndex:0];
            
            NSArray *nameArray = [element elementsForName:@"name"];
            nameElement = [nameArray objectAtIndex:0];
            
            NSArray *linkArray = [element elementsForName:@"link"];
            linkElement = [linkArray objectAtIndex:0];
            
            NSDictionary *dic = @{@"id": [idElement stringValue],@"name":[nameElement stringValue],@"link":[linkElement stringValue]};
            [self.categoryDataArray addObject:dic];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"category" object:self.categoryDataArray];
    }
}

//分类作品列表接口
- (void)parseCategoryDetailInfoData:(NSString *)linkStr
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/%@",linkStr]];
    [NSThread detachNewThreadSelector:@selector(requestCategoryDetailInfoData:) toTarget:self withObject:url];
}

- (void)requestCategoryDetailInfoData:(NSURL *)url
{
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if (!error) {
        NSMutableArray *tempArray = [self parseXMLDataToGetArray:data];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryDetailInfo" object:tempArray];
    }
}

- (NSMutableArray *)parseXMLDataToGetArray:(NSData *)data
{
    NSMutableArray *tempArray = [NSMutableArray array];
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:data options:0 error:nil];
    GDataXMLElement *rootElement = [document rootElement];
    
//    NSArray *array = [rootElement nodesForXPath:@"book_list/item/id" error:nil];
    
    NSArray *rootArray = [rootElement elementsForName:@"book_list"];
    GDataXMLElement *bookListElement = [rootArray objectAtIndex:0];
    NSArray *bookListArray = [bookListElement elementsForName:@"item"];
    
    GDataXMLElement *categoryElement,*idElement,*nameElement,*authornameElement,*infoElement,*eimgElement,*read_urlElement;
    for (GDataXMLElement *element in bookListArray) {
        NSArray *categoryArray = [element elementsForName:@"category"];
        categoryElement = [categoryArray objectAtIndex:0];
        
        NSArray *idArray = [element elementsForName:@"id"];
        idElement = [idArray objectAtIndex:0];
        
        NSArray *nameArray = [element elementsForName:@"name"];
        nameElement = [nameArray objectAtIndex:0];
        
        NSArray *authornameArray = [element elementsForName:@"authorname"];
        authornameElement = [authornameArray objectAtIndex:0];
        
        NSArray *infoArray = [element elementsForName:@"info"];
        infoElement = [infoArray objectAtIndex:0];
        
        NSArray *eimgArray = [element elementsForName:@"eimg"];
        eimgElement = [eimgArray objectAtIndex:0];
        
        NSArray *read_urlArray = [element elementsForName:@"read_url"];
        read_urlElement = [read_urlArray objectAtIndex:0];
        
        NSDictionary *respondDic = @{@"category": [categoryElement stringValue],@"id": [idElement stringValue],@"name": [nameElement stringValue],@"authorname": [authornameElement stringValue],@"info": [infoElement stringValue],@"eimg": [eimgElement stringValue],@"read_url": [read_urlElement stringValue]};
        [tempArray addObject:respondDic];
    }
    return tempArray;
}

//获取阅读页面数据
- (void)parseContentDataWithCartoonBookID:(NSString *)bookID andWithHuaID:(NSString *)huaID
{
    NSArray *array = @[bookID,huaID];
    [self performSelectorInBackground:@selector(requestReadVCDataWithIDs:) withObject:array];
}

- (void)requestReadVCDataWithIDs:(NSArray *)array
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/book_content.php?bookid=%@&id=%@&imagesize=3204800",[array objectAtIndex:0],[array lastObject]]];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    //SBJson 解析json数据
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSString *jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [parser objectWithString:jsonString];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"readVCData" object:jsonDic];
}

- (void)parseSearchData:(NSString *)searchStr
{
    [self performSelectorInBackground:@selector(requestSearchData:) withObject:searchStr];
}

- (void)requestSearchData:(NSString *)searchStr
{
//    NSString *base64Str = [CommonFunc base64StringFromText:searchStr];
//    NSLog(@"base64Str=%@",base64Str);
    //这是base64编码？？？
    NSString *secretStr = [searchStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/book_list.php?type=3&sub=%@",secretStr]];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSMutableArray *searchDataArray = [self parseXMLDataToGetArray:data];
    NSLog(@"searchDataArray%@",searchDataArray);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchData" object:searchDataArray];
}

- (void)parseHotSearchData
{
    [self performSelectorInBackground:@selector(requestHotSearchData) withObject:nil];
}

- (void)requestHotSearchData
{
    NSURL *url = [NSURL URLWithString:@"http://iphonenew.ecartoon.net/hotkeywords.php"];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:data options:0 error:&error];
    GDataXMLElement *rootElement = [document rootElement];
    NSArray *rootArray = [rootElement elementsForName:@"item"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (GDataXMLElement *element in rootArray) {
        [tempArray addObject:[element stringValue]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HotSearch" object:tempArray];
}


- (NSArray *)parseCommentData:(NSString *)bookID
{
//    dispatch_queue_t queue = dispatch_queue_create("gcdParseCommence", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{    });
    self.comments = [NSMutableArray array];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/comment.php?act=list&book_id=%@",bookID]];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if (!error) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:data options:0 error:&error];
        GDataXMLElement *rootElement = [document rootElement];
//        NSLog(@"rootElement = %@",rootElement);
        self.commentsData = [NSMutableArray arrayWithObject:data];
        if (rootElement) {
            NSArray *messageElements = [rootElement elementsForName:@"message"];
            if (messageElements.count > 0) {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"暂无评论,你是第一个评论的人哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                [alertView show];
            }else {
                NSArray *pageCounts = [rootElement elementsForName:@"pagecount"];
                GDataXMLElement *pageCountElement = [pageCounts firstObject];
                NSString *pageCountStr = [pageCountElement stringValue];
                if ([pageCountStr intValue]> 1) {
//                    NSArray *params = @[bookID, pageCountStr];
                    for (int i = 2; i <= pageCountStr.intValue; i++) {
                        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"http://iphonenew.ecartoon.net/comment.php?book_id=%@&p=%d",bookID,i]];
                        NSData *data=[NSData dataWithContentsOfURL:url];
                        if (data) {
                            [self.commentsData addObject:data];
                        }
                        /**
                         
                         //                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                            NSData *data=[NSData dataWithContentsOfURL:url];
//                            if (data != nil) {
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    [self.commentsData addObject:data];
//                                });
//                            }
//                        });
//                    if (self.commentsData.count == pageCountStr.intValue) {
//                        [self parseCommentXML];
//                    }

                         */
                    }
                }
                for (NSData *data in self.commentsData) {
                    NSError *error = nil;
                    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:data options:0 error:&error];
                    if (!error) {
                        GDataXMLElement *rootElement = [document rootElement];
//                        NSLog(@"rootElement = %@",rootElement);
                        if (rootElement) {
                            NSArray *listElements = [rootElement elementsForName:@"list"];
                            GDataXMLElement *listElement = [listElements firstObject];
                            NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                            NSArray *items = [listElement elementsForName:@"item"];
                            if (items.count > 0) {
                                for (GDataXMLElement *itemElement in items) {
                                    //评论密文
                                    NSString *content = [[[itemElement elementsForName:@"content"] firstObject] stringValue];
                                    //解码
                                    NSData *data=[GTMBase64 decodeString:content];
                                    NSString *base64content=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                    if (base64content) {
                                        [tempDic setObject:base64content forKey:@"commence"];
                                    }else {
                                        [tempDic setObject:content forKey:@"commence"];
                                    }
                                    
                                    //评论时间
                                    NSString *add_time = [[[itemElement elementsForName:@"add_time"] firstObject] stringValue];
                                    
                                    [tempDic setObject:add_time forKey:@"add_time"];
                                    [self.comments addObject:tempDic];
                                }
                            }
                        }
                    }
                }

//                NSArray *arr = [self parseCommentXML];
//                return arr;
//                else {
//                    [self parseCommentXML];
//                }
            }

        }
//            [self.commentsData addObject:data];
    }
    for (NSDictionary *dic in _comments) {
        NSLog(@"add_time = %@",[dic objectForKey:@"add_time"]);
    }
    return _comments;
}

- (void)parseChapterData:(NSString *)bookID
{
    
    
}
@end
