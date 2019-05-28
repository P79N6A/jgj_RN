//
//  JGJTransferAuthorityVc.h
//  mix
//
//  Created by yj on 16/12/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    JGJTransferAuthorityVcType = 1, //转让管理权
    JGJUpgradeGroupVcType   //升级群聊
} JGJMembersVcType;
@interface JGJTransferAuthorityVc : UIViewController
/**
 *  转让管理权成员
 */
@property (nonatomic, strong) NSMutableArray *members;
/**
 *  群聊信息
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

//当前类型
@property (assign, nonatomic) JGJMembersVcType membersVcType;
@end
