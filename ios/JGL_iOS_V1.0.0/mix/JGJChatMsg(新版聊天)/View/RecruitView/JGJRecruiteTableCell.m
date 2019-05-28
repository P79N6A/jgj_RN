//
//  JGJRecruiteTableCell.m
//  mix
//
//  Created by Tony on 2018/9/11.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecruiteTableCell.h"
#import "UILabel+GNUtil.h"
#import "NSString+Extend.h"
@interface JGJRecruiteTableCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recruiteConstance;

@property (weak, nonatomic) IBOutlet UILabel *recruiteTitle;
@property (weak, nonatomic) IBOutlet UILabel *recruiteContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIView *bottomViEW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstance;

@end
@implementation JGJRecruiteTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}


- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{
    
    _recruiteTitle.text = jgjChatListModel.title;
    
    // 找活招工小助手 workremind类型的标题变色
    if ([jgjChatListModel.msg_type isEqualToString:@"workremind"]) {
        
        if (![NSString isEmpty:jgjChatListModel.user_info.real_name]) {
            
            [_recruiteTitle markText:jgjChatListModel.user_info.real_name withFont:[UIFont boldSystemFontOfSize:16] color:AppFont000000Color];
        }
        
    }
    if (jgjChatListModel.chatListType == JGJChatListUnKonownMsgType) {
        
        _recruiteContent.text = @"当前版本暂不支持查看此消息，请升级为最新版本查看";
        
    }else {
        
       _recruiteContent.text = jgjChatListModel.detail;
    }
    
    [_recruiteContent setAttributedText:_recruiteContent.text lineSapcing:4];

    if (jgjChatListModel.chatListType == JGJChatListUnKonownMsgType) {

        _recruiteTitle.hidden = YES;
        _recruiteConstance.constant = 0;
        _bottomViEW.hidden = YES;
        _bottomViewConstance.constant = 0;
        
    }else {

        _recruiteTitle.hidden = NO;
        _recruiteConstance.constant = 30;
        if (jgjChatListModel.chatListType == JGJChatListFeedbackType) {
            
            _bottomViEW.hidden = YES;
            _bottomViewConstance.constant = 10;
            
        }else {
            
            _bottomViEW.hidden = NO;
            _bottomViewConstance.constant = 30;
            
        }
    }
    // 变色处理
    if (jgjChatListModel.chatListType == JGJChatListFeedbackType) {
        
        NSMutableArray *changeColorArr = [[NSMutableArray alloc] init];
        NSString *colorStr;
        for (NSDictionary *dic in jgjChatListModel.extend.content) {
            
            [changeColorArr addObject:dic[@"field"] ? : @""];
            colorStr = dic[@"color"] ? : @"0X000000";
        }
        [_recruiteContent markattributedTextArray:changeColorArr color:TYColorHex([colorStr integerValue])];
    }
    
}

@end
