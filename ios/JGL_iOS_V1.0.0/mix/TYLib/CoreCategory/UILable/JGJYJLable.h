//
//  JGJYJLable.h
//  mix
//
//  Created by yj on 17/2/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    VerticalAlignmentTop = 0,
    VerticalAlignmentMiddle,//default
    VerticalAlignmentBottom,
    
} VerticalAlignment;

@interface JGJYJLable : UILabel

@property (nonatomic ,assign ) VerticalAlignment verticalAlignment;
@end
