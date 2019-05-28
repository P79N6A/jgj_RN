//
//  JGJGuideImageVc.h
//  JGJCompany
//
//  Created by Tony on 2016/10/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    GuideImageTypeDefualt = 0,
    GuideImageTypeRecord,
    GuideImageTypeBill,
    GuideImageTypeSysManage,
} GuideImageType;

@class JGJGuideImageVc;
@protocol JGJGuideImageVcDelegate <NSObject>
- (void)guideImageVcWithguideImageVc:(JGJGuideImageVc *)guideImageVc didSelectedFooterView:(UIView *)footerView;
@end

@interface JGJGuideImageVc : UIViewController

- (instancetype )initWithImageType:(GuideImageType )guideImageType;

@property (weak, nonatomic) id <JGJGuideImageVcDelegate> delegate;
@property (assign ,nonatomic) BOOL isShowBottomButton;
@end
