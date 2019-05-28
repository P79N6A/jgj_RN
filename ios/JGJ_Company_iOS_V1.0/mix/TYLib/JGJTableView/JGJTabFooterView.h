//
//  JGJTabFooterView.h
//  mix
//
//  Created by yj on 2018/3/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    UITableViewFooterDefaultType, //默认类型
    
    UITableViewFooterFirstType,
    
    UITableViewFooterSecType,
    
} UITableViewFooterDesType;

@interface JGJFooterViewInfoModel : NSObject

@property (nonatomic, strong) UIColor *backColor;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) UITableViewFooterDesType desType;

@property (nonatomic, assign) BOOL isHiddenLine;
@end

@interface JGJTabFooterView : UIView

@property (nonatomic, strong) JGJFooterViewInfoModel *footerInfoModel;

@end

