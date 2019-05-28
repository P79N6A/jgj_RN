//
//  JLGTagView.h
//  mix
//
//  Created by jizhi on 15/11/27.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JLGTagViewHFinish @"JLGTagViewHFinish"
@interface JLGTagView : UIView
@property (nonatomic, strong) UIColor *viewColor;
@property (nonatomic, assign) CGFloat labelFont;
@property (nonatomic, assign) CGFloat viewW;
@property (nonatomic, assign) CGFloat viewH;
@property (nonatomic, copy) NSArray *datasArray;
@end
