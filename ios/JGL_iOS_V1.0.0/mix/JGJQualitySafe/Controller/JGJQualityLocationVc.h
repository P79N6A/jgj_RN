//
//  JGJQualityLocationVc.h
//  mix
//
//  Created by YJ on 17/6/11.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJQualityLocationVc;
typedef void(^QualityLocationVcBlock)(JGJQualityLocationVc *, JGJQualityLocationModel *);

@interface JGJQualityLocationVc : UIViewController

@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

@property (nonatomic, copy) QualityLocationVcBlock qualityLocationVcBlock;

@end
