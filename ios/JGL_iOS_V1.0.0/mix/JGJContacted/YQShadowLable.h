//
//  YQShadowLable.h
//  mix
//
//  Created by Tony on 2017/1/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQShadowLable : UILabel
{  float redValue_;
    float greenValue_;
    float blueValue_;
    float size_;
}
//定义颜色值全局变量和放大值全局变量
@property(assign,nonatomic)float redValue;
@property(assign,nonatomic)float greenValue;
@property(assign,nonatomic)float blueValue;
@property(assign,nonatomic)float size;
@end
