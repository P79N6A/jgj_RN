//
//  JGJContactedAddressBookHeadCell.h
//  mix
//
//  Created by yj on 17/1/11.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomView.h"
@interface JGJContactedAddressBookHeadCell : UITableViewCell
@property (nonatomic, strong) JGJSynBillingModel *headModel; //第一段群聊、项目、黑名单信息
@property (weak, nonatomic) IBOutlet LineView *lineView;
@end
