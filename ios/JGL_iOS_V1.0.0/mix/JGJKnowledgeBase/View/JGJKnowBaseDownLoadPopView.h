//
//  JGJKnowBaseDownLoadPopView.h
//  mix
//
//  Created by yj on 2017/5/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HandleKnowBaseCancelDownLoadBlock)(JGJKnowBaseModel *);

@interface JGJKnowBaseDownLoadPopView : UIView

+ (JGJKnowBaseDownLoadPopView *)knowBaseDownLoadPopViewWithModel:(JGJKnowBaseModel *)knowBaseModel;

@property (nonatomic, copy) HandleKnowBaseCancelDownLoadBlock handleKnowBaseCancelDownLoadBlock;

//模型
@property (nonatomic, strong) JGJKnowBaseModel *knowBaseModel;

- (void)dismiss;

@end
