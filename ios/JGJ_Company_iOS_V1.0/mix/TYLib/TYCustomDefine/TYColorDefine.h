//
//  TYColorDefine.h
//  mix
//
//  Created by jizhi on 16/5/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#ifndef TYColorDefine_h
#define TYColorDefine_h

// RGB颜色
#define TYColorRGB(r, g, b)           [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

// RGB颜色，带alpha
#define TYColorRGBA(r, g, b, a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// 16进制颜色,color输入为:0x080808
#define TYColorHex(color)             [UIColor colorWithRed:((color>>16)&0xFF)/255.0f green:((color>>8)&0xFF)/255.0f blue:(color&0xFF)/255.0f alpha:1.0f]

// 16进制颜色,带alpha,color输入为:0x080808
#define TYColorHexAlpha(color,alphaValue)  [UIColor colorWithRed:((color>>16)&0xFF)/255.0f green:((color>>8)&0xFF)/255.0f blue:(color&0xFF)/255.0f alpha:alphaValue]

// 随机色
#define TYColorRandom                 TYColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#endif /* TYColorDefine_h */
