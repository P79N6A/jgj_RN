//
//  JGJMemManDetailMemCell.h
//  mix
//
//  Created by yj on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJMemManDetailMemDefaultBtntype,
    
    JGJMemManDetailMemHeadBtntype, //到他的资料
    
    JGJMemManDetailMemEditInfoBtntype //编辑姓名
    
} JGJMemManDetailMemBtntype;

typedef void(^JGJMemManDetailMemCellBlock)(JGJSynBillingModel *memberModel, JGJMemManDetailMemBtntype btnType);

@interface JGJMemManDetailMemCell : UITableViewCell

@property (nonatomic, strong) JGJSynBillingModel *memberModel;

@property (nonatomic, copy) JGJMemManDetailMemCellBlock memManDetailMemCellBlock;

@end
