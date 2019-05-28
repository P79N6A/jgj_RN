//
//  JGJGroupMangerVC.h
//  JGJCompany
//
//  Created by yj on 16/9/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JGJGroupMangerVC : UIViewController
/**
 *  页面类型区分
 */
@property (nonatomic, assign) JGJTeamMangerVcType teamMangerVcType;

/**
 *  班组信息
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

/**
 * 存储排序后信息
 */
@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;

/**
 * 项目详细地址
 */
@property (nonatomic, copy) NSString *proDetailAddress;

@end
