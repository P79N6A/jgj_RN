//
//  JGJTabComHeaderFooterView.h
//  mix
//
//  Created by yj on 2018/7/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJTabComHeaderFooterViewModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *des;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) UIColor *desColor;

@property (nonatomic, copy) NSString *changeColorStr;

@property (nonatomic, strong) UIColor *backColor;

@end

@interface JGJTabComHeaderFooterView : UIView

@property (nonatomic, strong) JGJTabComHeaderFooterViewModel *infoModel;

@end
