//
//  JGJChatListType.m
//  mix
//
//  Created by Tony on 2016/8/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListType.h"

@implementation JGJChatListTypeModel
TYSingleton_implementation(chatListTypeModel)

- (NSArray *)listTypeColor
{
    if (!_listTypeColor) {
        //前三个颜色没用
        _listTypeColor = @[JGJMainColor,JGJMainColor,JGJMainColor,//占位
                           JGJChatListChatRecordColor,
                           JGJChatListChatNoticeColor,
                           JGJChatListChatSafeColor,
                           JGJChatListChatQualityColor,
                           JGJMainColor,//加入消息占位
                           JGJMainColor,//未读消息占位
                           JGJChatListChatLogColor,
                           JGJMainColor,//签到占位
                           JGJMainColor,//统计占位
                           ];
    }
    
    return _listTypeColor;
}

- (NSArray *)listTypeImgs
{
    if (!_listTypeImgs) {
        //前三个图片没用
        NSArray *listTypeImgsStr = @[@"",@"",@"",//占位
                                     @"Chat_listRecord",
                                     @"Chat_listNotice",
                                     @"Chat_listSafe",
                                     @"Chat_listQuality",
                                     @"",//加入消息占位
                                     @"",//未读消息占位
                                     @"Chat_listLog",
                                     @"",//签到占位
                                     @""//统计占位
                                     ];
        
        NSMutableArray *listTypeImgsTmp = [NSMutableArray array];
        
        for (NSInteger idx = 0; idx < listTypeImgsStr.count; idx++) {
            UIImage *listTypeImg = [UIImage imageNamed:listTypeImgsStr[idx]];
            [listTypeImgsTmp addObject:listTypeImg?:[UIImage new]];
        }
        _listTypeImgs = listTypeImgsTmp.copy;
    }
    return _listTypeImgs;
}


- (NSArray *)listTypeTitles
{
    if (!_listTypeTitles) {
        _listTypeTitles = @[@"",@"",@"",//占位
                            @"记了一笔工账",
                            @"通知",
                            @"安全",
                            @"质量",
                            @"",//加入消息占位
                            @"",//未读消息占位
                            @"工作日志",
                            @"",//签到占位
                            @""//统计占位
                            ];
    }
    return _listTypeTitles;
}

- (NSArray *)listTypePOPImgsMine
{
    if (!_listTypePOPImgsMine) {
        NSArray *listTypePOPImgsStr = @[@"Chat_listRedPOP",@"Chat_listRedPOP",@"Chat_listRedPOP",//默认的，文字，语音占位
                                        @"Chat_listRecordPOPR",
                                        @"Chat_listNoticePOPR",
                                        @"Chat_listSafePOPR",
                                        @"Chat_listQualityPOPR",
                                        @"Chat_listRedPOP",//加入消息占位
                                        @"Chat_listRedPOP",//未读消息占位
                                        @"Chat_listLogPOPR",//日志
                                        @"Chat_listRedPOP",//签到占位
                                        @"Chat_listRedPOP"//统计占位
                                        ];
        
        NSMutableArray *listTypePOPImgsStrTmp = [NSMutableArray array];
        
        for (NSInteger idx = 0; idx < listTypePOPImgsStr.count; idx++) {
            UIImage *listTypeImg = [UIImage imageNamed:listTypePOPImgsStr[idx]];
            [listTypePOPImgsStrTmp addObject:listTypeImg];
        }
        
        _listTypePOPImgsMine = listTypePOPImgsStrTmp.copy;
    }
    return _listTypePOPImgsMine;
}

- (NSArray *)listTypePOPImgsOther
{
    if (!_listTypePOPImgsOther) {
        NSArray *listTypePOPImgsStr =  @[@"Chat_listWhitePOP",@"Chat_listWhitePOP",@"Chat_listWhitePOP",//默认的，文字，语音占位
                                        @"Chat_listRecordPOP",
                                        @"Chat_listNoticePOP",
                                        @"Chat_listSafePOP",
                                        @"Chat_listQualityPOP",
                                        @"Chat_listRedPOP",//加入消息占位
                                        @"Chat_listRedPOP",//未读消息占位
                                        @"Chat_listLogPOP",//日志
                                        @"Chat_listRedPOP",//签到占位
                                        @"Chat_listRedPOP"//统计占位
                                        ];
        
        NSMutableArray *listTypePOPImgsStrTmp = [NSMutableArray array];
        
        for (NSInteger idx = 0; idx < listTypePOPImgsStr.count; idx++) {
            UIImage *listTypeImg = [UIImage imageNamed:listTypePOPImgsStr[idx]];
            [listTypePOPImgsStrTmp addObject:listTypeImg];
        }
        
        _listTypePOPImgsOther = listTypePOPImgsStrTmp.copy;
    }
    return _listTypePOPImgsOther;
}

@end

@implementation JGJChatRootRequestModel

@end
