//
//  JGJConRecomCell.h
//  mix
//
//  Created by yj on 2018/1/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"


typedef enum : NSUInteger {
    
    JGJConRecomCellAddFriendBtnType, //加好友
    
    JGJConRecomCellVertifyBtnType, //实名
    
    JGJConRecomCellAuthBtnType //认证
    
} JGJConRecomCellBtnType;

typedef void(^JGJConRecomCellBlock)(JGJSynBillingModel *friendlyModel, JGJConRecomCellBtnType btnType);

@interface JGJConRecomCell : UITableViewCell

@property (nonatomic, strong) JGJSynBillingModel *friendlyModel;

@property (nonatomic, copy) JGJConRecomCellBlock conRecomCellBlock;
@property (weak, nonatomic) IBOutlet LineView *topLineView;

@end
