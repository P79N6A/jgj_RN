//
//  JGJQualityReviewResultCell.h
//  JGJCompany
//
//  Created by yj on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJQualityReviewPassType, //通过
    
    JGJQualityReviewUnPassType //未通过
    
} JGJQualityReviewResultType;

typedef void(^HandleQualityReviewResultBlock)(JGJQualityReviewResultType );

@interface JGJQualityReviewResultCell : UITableViewCell

@property (nonatomic, assign) JGJQualityReviewResultType reviewResultType;

@property (nonatomic, copy) HandleQualityReviewResultBlock handleQualityReviewResultBlock;

@property (nonatomic, strong) JGJQualityDetailModel *qualityDetailModel;

@end
