//
//  UILabel+MEExtention.h
//  mix
//
//  Created by celion on 16/4/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MEExtention)
- (CGSize)contentSizeFixWithSize:(CGSize)size;
- (CGSize)contentSizeFixWithWidth:(CGFloat)width;
- (CGSize)contentSizeFixWithHeight:(CGFloat)height;

- (void)setAttributedText:(NSString *)text lineSapcing:(CGFloat)lineSapcing;
- (void)markText:(NSString *)text withColor:(UIColor *)c;
- (void)markText:(NSString *)text withFont:(UIFont *)f color:(UIColor *)c;

@end
