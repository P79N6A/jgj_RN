//
//  JGJGroupSetMemberCell.h
//  mix
//
//  Created by yj on 2018/12/13.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJGroupSetMemberCellViewModel : NSObject

//头像
@property (nonatomic, strong) UIButton *headBtn;

//姓名
@property (nonatomic, strong) UILabel *name;

//创建者或者管理员
@property (nonatomic, strong) UIImageView *adminFlag;

//是否注册
@property (nonatomic, strong) UIImageView *registerFlag;

@end

@class JGJGroupSetMemberCell;

@protocol JGJGroupSetMemberCellDelegate <NSObject>

@optional

//点击成员
- (void)selMemberWithCell:(JGJGroupSetMemberCell *)cell memberModel:(JGJSynBillingModel *)memberModel;

@end

@interface JGJGroupSetMemberCell : UITableViewCell

@property (nonatomic, strong) NSArray *members;

@property (nonatomic, strong) JGJTeamMemberCommonModel *commonModel;

@property (nonatomic, weak) id <JGJGroupSetMemberCellDelegate> delegate;

//成员cell高度

+ (CGFloat)memberCellHeight;

//头像个数
+ (NSInteger)headerCount;

@end
