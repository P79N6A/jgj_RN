//
//  TYMoreButton.h
//  mix
//
//  Created by Tony on 2016/8/29.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  图标在上，文本在下按钮的图文间隔比例（0-1），默认0.8
 */
#define TYButtonTopRadio 0.8

/**
 *  图标在下，文本在上按钮的图文间隔比例（0-1），默认0.5
 */
#define TYButtonBottomRadio 0.5


typedef enum{
    TYAlignmentStatuDefault,//图标在上，文本在下(居中)
    TYAlignmentStatusLeft,// 左对齐,图片在左
    TYAlignmentStatusCenter,// 居中对齐
    TYAlignmentStatusRight,// 右对齐，图片在右
    TYAlignmentStatusTop,// 图标在上，文本在下(居中)
    TYAlignmentStatusBottom, // 图标在下，文本在上(居中)
}TYAlignmentStatus;

@interface TYMoreButton : UIButton
/**
 *  外界通过设置按钮的status属性，创建不同类型的按钮
 */
@property (nonatomic,assign)TYAlignmentStatus status;

+ (instancetype)TYShareButton;

+ (instancetype)TYShareButtonStatus:(TYAlignmentStatus )status;

- (instancetype)initWithAlignmentStatus:(TYAlignmentStatus)status;
@end
