//
//  JGJPeopleIsOpenReconciliationListCell.h
//  mix
//
//  Created by Tony on 2019/2/18.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MakeReconciliation)(NSString *uid);
typedef void(^MakeTelPhoneOrShare)(BOOL isTakePhone,NSString *telphone);

@interface JGJPeopleIsOpenReconciliationListCell : UITableViewCell

@property (nonatomic, strong) JGJSynBillingModel *model;
@property (nonatomic, copy) MakeReconciliation makeReconciliation;
@property (nonatomic, copy) MakeTelPhoneOrShare makeTelPhoneOrShare;// 1 打电话  0 邀请注册
@property (nonatomic, copy) NSString *searchValue;

@end
