//
//  JGJSlideSegementTinyMaskingView.h
//  mix
//
//  Created by Tony on 2019/1/10.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MaskingViewTouch)(void);
@interface JGJSlideSegementTinyMaskingView : UIView

@property (nonatomic, copy) MaskingViewTouch maskingTouch;
@end
