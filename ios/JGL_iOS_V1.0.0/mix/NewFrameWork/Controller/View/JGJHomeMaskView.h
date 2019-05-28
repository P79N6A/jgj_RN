//
//  JGJHomeMaskView.h
//  mix
//
//  Created by yj on 2018/11/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJHomeMaskImageModel : NSObject

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) CGRect rect;

@property (nonatomic, assign) CGFloat radius;

//自定义按钮
@property (nonatomic, assign) BOOL is_cusview;

@end

typedef void(^HomeMaskViewClickBlock)(NSInteger count);

@interface JGJHomeMaskView : UIView

@property (nonatomic, strong) NSArray *imageModels;

@property (nonatomic, copy) HomeMaskViewClickBlock clickBlock;

-(void)cutViewFrame:(CGRect)oriRect convertView:(UIView *)convertView;

-(void)setSecGuideView:(UIView *)cutView convertView:(UIView *)convertView;

-(void)setThirGuideView:(UIView *)cutView convertView:(UIView *)convertView;

@end
