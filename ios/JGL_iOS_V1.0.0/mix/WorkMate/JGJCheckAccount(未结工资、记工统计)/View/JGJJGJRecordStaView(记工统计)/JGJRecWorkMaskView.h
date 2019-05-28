//
//  JGJRecWorkMaskView.h
//  mix
//
//  Created by yj on 2018/9/7.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJMaskImageModel : NSObject

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) CGRect rect;

@property (nonatomic, assign) CGFloat radius;

//自定义按钮
@property (nonatomic, assign) BOOL is_cusview;

@property (nonatomic, assign) NSInteger buttonTag;

@end

@interface JGJRecWorkMaskView : UIView

@property (nonatomic, strong) NSArray *imageModels;

-(void)cutView:(UIView *)cutView convertView:(UIView *)convertView;

@end
