//
//  JGJAccountShowTypeView.h
//  mix
//
//  Created by yj on 2018/6/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJAccountShowTypeViewDefaultType, //@"上班按工天、加班按小时", @"按工天", @"按小时"
    
    JGJAccountShowTypeViewStaType,//按月统计、按天统计

} JGJAccountShowTypeViewType;

typedef void(^JGJAccountShowTypeViewBlock)(id);

@interface JGJAccountShowTypeView : UIView

@property (nonatomic, copy) JGJAccountShowTypeViewBlock accountShowTypeViewBlock;

@property (nonatomic, assign) JGJAccountShowTypeViewType type;

@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;

- (void)dismiss;

- (void)show;

@end
