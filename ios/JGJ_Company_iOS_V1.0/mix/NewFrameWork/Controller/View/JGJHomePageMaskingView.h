//
//  JGJHomePageMaskingView.h
//  JGJCompany
//
//  Created by Tony on 2018/7/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJHomePageMaskingView : UIView

@property (nonatomic, assign) CGFloat topConstrain;
- (void)setCutImage:(UIImage *)cutImage isCreateDefault:(BOOL)isDefault;
@end
