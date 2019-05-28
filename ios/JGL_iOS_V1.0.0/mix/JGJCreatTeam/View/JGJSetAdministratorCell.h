//
//  JGJSetAdministratorCell.h
//  JGJCompany
//
//  Created by yj on 16/11/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JGJSetAdminiCellRemoveAdminType,
    JGJSetAdminiCellAddAdminType
} JGJSetAdministratorCellType;
typedef void(^RemoveMemberModelBlock)(JGJSynBillingModel *);
@interface JGJSetAdministratorCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) JGJSynBillingModel *memberModel;
@property (nonatomic, copy) RemoveMemberModelBlock removeMemberModelBlock;
@property (nonatomic, assign) JGJSetAdministratorCellType adminCellType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewH;
//查看圈成员改变颜色
@property (nonatomic, copy) NSString *searchValue;
@end
