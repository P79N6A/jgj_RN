//
//  JGJMergeProPopView.h
//  JGJCompany
//
//  Created by yj on 16/9/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^OnClickedBlock)(JGJMergeProRequestModel *);
@interface JGJMergeProPopView : UIView
@property (nonatomic, copy) OnClickedBlock onClickedBlock;
- (instancetype)initWithFrame:(CGRect)frame mergeProRequestModel:(JGJMergeProRequestModel *)mergeProRequestModel;
@end
