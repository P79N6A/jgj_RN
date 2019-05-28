//
//  JGJNewLeaderRecordButtonView.h
//  mix
//
//  Created by Tony on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum:NSInteger {
    
    JGJHomeRecordButtonMakeSingleBillType,// 记一笔工
    JGJHomeRecordButtonMakeMorePeopleBillType,// 批量记工
    JGJHomeRecordButtonMakeMoreDayBillType// 批量记多天
    
    
}JGJHomeRecordButtonClickType;

@protocol JGJNewLeaderRecordButtonViewDelegate <NSObject>

- (void)JGJNewLeaderRecordButtonClickBorrowOrCloseMarkBillBtn;// 点击借支或者结算
- (void)JGJNewLeaderRecordButtonClickMiddleBtnWithType:(JGJHomeRecordButtonClickType)type;// 点击中间按钮
- (void)JGJNewLeaderRecordButtonClickRightBtnWithType:(JGJHomeRecordButtonClickType)type;// 点击最右边按钮

@end

@interface JGJNewLeaderRecordButtonView : UIView

@property (strong, nonatomic) id <JGJNewLeaderRecordButtonViewDelegate> delegate;
@property (nonatomic, strong) UILabel *scrollTipsLabel;// 左右滑动提示
// 隐藏滑动提示
- (void)hiddenScrollTipsLabel;

- (void)updateLeaderRecordButtonWithRoleID;

@end
