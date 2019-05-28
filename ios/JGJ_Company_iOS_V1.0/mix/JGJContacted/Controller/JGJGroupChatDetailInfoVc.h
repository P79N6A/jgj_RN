//
//  JGJGroupChatDetailInfoVc.h
//  mix
//
//  Created by YJ on 16/12/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJGroupChatDetailInfoVc : UIViewController
/**
 *  群聊信息
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

/**
 * 存储排序后信息
 */
@property (nonatomic, strong) JGJAddressBookSortContactsModel *sortContactsModel;
@end
