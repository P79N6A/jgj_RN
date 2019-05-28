//
//  JLGBGImage.h
//  mix
//
//  Created by jizhi on 15/12/10.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface JLGBGImage : UIView
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,assign) CGFloat zoomScale;
@end
