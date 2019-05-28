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

@property (strong, nonatomic) NSIndexPath *lastIndexPath;

@end
