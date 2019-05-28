//
//  JGJUnLoginPopView.h
//  JGJCompany
//
//  Created by yj on 16/10/9.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^OnClickedBlock)();
@interface JGJUnLoginPopView : UIView
@property (nonatomic, copy) OnClickedBlock onClickedBlock;
+ (JGJUnLoginPopView *)popViewImageStr:(NSString *)imageStr  popMessage:(NSString *)popMessage buttonTitle:(NSString *)buttonTitle;
@end
