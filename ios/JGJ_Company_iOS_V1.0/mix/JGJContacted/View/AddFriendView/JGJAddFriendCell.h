//
//  JGJAddFriendCell.h
//  mix
//
//  Created by yj on 2018/10/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

@interface JGJAddFriendCell : UITableViewCell

@property (nonatomic, strong) JGJSynBillingModel *memberModel;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
