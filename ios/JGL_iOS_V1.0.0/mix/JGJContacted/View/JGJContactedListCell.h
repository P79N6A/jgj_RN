//
//  JGJContactedListCell.h
//  mix
//
//  Created by YJ on 16/12/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "SWTableViewCell.h"
#import "CustomView.h"
#import "JGJChatGroupListModel.h"
typedef void(^JGJContactedListCellBlock)(JGJChatGroupListModel *proListModel);

@interface JGJContactedListCell : SWTableViewCell

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic, strong) JGJChatGroupListModel *groupModel;

+ (CGFloat)contactedListCellHeight;
//聊天搜索的的值根据当前搜索改变颜色
@property (nonatomic, copy) NSString *searchValue;
@property (weak, nonatomic) IBOutlet LineView *lineView;

@property (copy, nonatomic) JGJContactedListCellBlock contactedListCellBlock;

@property (weak, nonatomic) IBOutlet UIView *containView;



+ (CGFloat)JGJContactedListCellHeight;

@end

