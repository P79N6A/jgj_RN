//
//  JGJAccountingMemberCell.h
//  mix
//
//  Created by yj on 2017/10/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJAccountingMemberDefaultType,
    
    JGJAccountingMemberAccountCheckType //对账类型

} JGJAccountingMemberButtonType;

@class JGJAccountingMemberCell;

typedef void(^AccountingMemberDelButtonPressedBlock)(JGJSynBillingModel *);

typedef void(^CheckAccountButtonPressedBlock)(JGJAccountingMemberCell *);

@interface JGJAccountingMemberCell : UITableViewCell

@property (nonatomic, copy) JGJSynBillingModel *accountMember;

//工人班组长管理3.2.0
@property (nonatomic, copy) JGJSynBillingModel *workerManger;

@property (nonatomic, copy) AccountingMemberDelButtonPressedBlock accountingMemberDelButtonPressedBlock;

//查看记账
@property (nonatomic, copy) CheckAccountButtonPressedBlock checkAccountButtonPressedBlock;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewH;

//是否显示删除按钮
@property (nonatomic, assign) BOOL isShowDelButton;

//隐藏姓名
@property (nonatomic, assign) BOOL isHiddenName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerY;

@property (assign, nonatomic,readonly) JGJAccountingMemberButtonType buttonType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trail;

@property (nonatomic, copy) NSString *searchValue;

@end
