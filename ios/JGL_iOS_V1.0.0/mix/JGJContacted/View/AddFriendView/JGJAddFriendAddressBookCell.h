//
//  JGJAddFriendAddressBookCell.h
//  mix
//
//  Created by yj on 17/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJAddFriendAddressBookCell : UITableViewCell
@property (nonatomic, strong) JGJSynBillingModel *contactModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewH;

@property (weak, nonatomic) IBOutlet UIView *lineView;

//聊天搜索的的值根据当前搜索改变颜色
@property (nonatomic, copy) NSString *searchValue;

+ (CGFloat)JGJAddFriendAddressBookCellHeight;
@end
