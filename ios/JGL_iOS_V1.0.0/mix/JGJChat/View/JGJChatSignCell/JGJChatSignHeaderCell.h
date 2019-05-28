//
//  JGJChatSignHeaderCell.h
//  JGJCompany
//
//  Created by Tony on 16/9/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatSignModel.h"

typedef NS_ENUM(NSUInteger, SignHeaderType) {
    SignHeaderTypeSignVc,
    SignHeaderTypeSignSubVc
};

@interface JGJChatSignHeaderCell : UITableViewCell

- (void)setModel:(ChatSign_List *)chatSign_List signType:(SignHeaderType )signHeaderType;

@end
