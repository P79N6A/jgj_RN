//
//  JGJRecruiteTableCell.m
//  mix
//
//  Created by Tony on 2018/9/11.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecruiteTableCell.h"
#import "UILabel+GNUtil.h"
@interface JGJRecruiteTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *recruiteTitle;
@property (weak, nonatomic) IBOutlet UILabel *recruiteContent;

@end
@implementation JGJRecruiteTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{
    
    _recruiteTitle.text = jgjChatListModel.title;
    _recruiteContent.text = jgjChatListModel.detail;
    
    [_recruiteTitle setAttributedText:_recruiteTitle.text lineSapcing:4];
}

@end
