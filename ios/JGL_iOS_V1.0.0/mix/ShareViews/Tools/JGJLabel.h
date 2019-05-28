//
//  JGJLabel.h
//  mix
//
//  Created by Tony on 16/4/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YYLabel.h"
#import "JLGFindProjectModel.h"

@class JGJLabelModel;
@interface JGJLabel : YYLabel
/**
 *  获取的富文本和高度的Model
 *
 *  @param proModel 传入的模型
 *  @param maxWith  最大的宽度
 *
 *  @return 获取的Model
 */
+ (JGJLabelModel *)getModel:(JLGFindProjectModel *)proModel maxWith:(CGFloat )maxWith;

/**
 *  获取富文本的高度
 *
 *  @param proModel 传入的模型
 *  @param maxWith  最大的宽度
 *
 *  @return 返回的高度
 */
+ (CGFloat )getModelStrHeight:(JLGFindProjectModel *)proModel maxWith:(CGFloat )maxWith;

/**
 *  获取对应的富文本
 *
 *  @param findProModel 传入的模型
 *
 *  @return 返回的富文本
 */
+ (NSAttributedString *)getModelAttributeString:(JLGFindProjectModel *)findProModel;
@end

@interface JGJLabelModel : NSObject
@property (nonatomic, assign) CGFloat strViewH;//类型View的高度

@property (nonatomic, strong) NSAttributedString *attributedStr;//计算出的富文本
@end
