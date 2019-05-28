//
//  JGJSplitProHeaderView.h
//  JGJCompany
//
//  Created by yj on 16/9/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JGJSplitProHeaderViewHeight 35

typedef void(^ShareProHeaderViewBlock)(JGJShareProDesModel *);
@interface JGJShareProHeaderView : UIView
- (instancetype)initWithFrame:(CGRect)frame shareProDesModel:(JGJShareProDesModel *)shareProDesModel;
@property (nonatomic ,copy) ShareProHeaderViewBlock shareProHeaderViewBlock;
@end
