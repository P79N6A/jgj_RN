//
//  JGJDetailCallView.h
//  mix
//
//  Created by yj on 16/6/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGFindProjectModel.h"
#import "JLGFHLeaderDetailModel.h"

typedef void(^BlockContactInfo)(FindResultModel *);

@interface JGJDetailCallView : UIView
@property (nonatomic, copy) BlockContactInfo blockContactInfo;
- (instancetype)initWithFrame:(CGRect)frame findProjectModel:(JLGFindProjectModel *)findProjectModel;
@end
