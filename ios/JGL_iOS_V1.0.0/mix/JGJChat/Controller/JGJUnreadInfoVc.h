//
//  JGJUnreadInfoVc.h
//  mix
//
//  Created by Tony on 2016/9/2.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJReadInfoCell.h"

@interface JGJUnreadInfoVc : UIViewController
@property (nonatomic,strong) NSMutableArray <ChatMsgList_Read_User_List *>*dataSourceArr;
@end
