//
//  JGJLogoutOtherReasonCell.h
//  mix
//
//  Created by yj on 2018/6/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYTextView.h"

typedef void(^JGJLogoutOtherReasonCellBlock)(NSString *text);

@interface JGJLogoutOtherReasonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet YYTextView *textView;

@property (nonatomic, copy) JGJLogoutOtherReasonCellBlock reasonCellBlock;

@property (nonatomic, strong) JGJLogoutReasonModel *desModel;

+(CGFloat)cellHeight;

@end
