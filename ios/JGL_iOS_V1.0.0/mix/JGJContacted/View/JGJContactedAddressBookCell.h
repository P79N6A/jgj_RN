//
//  JGJContactedAddressBookCell.h
//  mix
//
//  Created by yj on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "SWTableViewCell.h"
#import "CustomView.h"
typedef enum : NSUInteger {
    JGJContactedAddressBookFirstSectionCellCustomHeadPicType, //第一段自定义头像
    JGJContactedAddressBookCellDefaultType, //没有右边选中按钮
    JGJContactedAddressBookCellSelectedMembersType //显示右边选中按钮
} JGJContactedAddressBookCellType;
@class JGJContactedAddressBookCell;
@protocol JGJContactedAddressBookCellDelegate <NSObject>

@optional
- (void)contactedAddressBookCell:(JGJContactedAddressBookCell *)cell contactModel:(JGJSynBillingModel *)contactModel;

@end
@interface JGJContactedAddressBookCell : SWTableViewCell
@property (nonatomic, strong) JGJSynBillingModel *contactModel; //联系人模型
@property (nonatomic, strong) JGJSynBillingModel *headModel; //第一段群聊、项目、黑名单信息
@property (weak, nonatomic) IBOutlet LineView *lineView;
@property (weak, nonatomic) id <JGJContactedAddressBookCellDelegate> addressBookCellDelegate;
@property (assign, nonatomic) JGJContactedAddressBookCellType addressBookCellType;

+(CGFloat)cellHeight;
@end
