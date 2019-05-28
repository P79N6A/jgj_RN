//
//  UILabel+JGJCopyLable.h
//  JGJCompany
//
//  Created by Tony on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJCopyLableActionBlock)();

@interface UILabel (JGJCopyLable)

@property (nonatomic, copy) JGJCopyLableActionBlock copyLableActionBlock;

//@property (strong ,nonatomic)NSArray *Arr;
/*
 *长按复制
 */
- (void)canCopyWithlable:(UILabel *)lable;
/*
 *设置行间距
 */
- (void)SetLinDepart:(NSInteger)distance;
/*
 *生成超文本链接
 */
- (void)creatInternetHyperlinks;
/*
 *截取名字 惨过四位的只显示四位
 */
-(NSString *)sublistNameSurplusFour:(NSString *)name;

//@property (nonatomic ,retain)NSMutableArray *linkPoints;
//@property (nonatomic ,retain)NSMutableArray *selectedRange;

@end
