//
//  JGJBillModifyProNameView.h
//  mix
//
//  Created by yj on 16/7/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OnClickedBlock)(NSString *);
@interface JGJBillModifyProNameView : UIView
@property (copy, nonatomic) OnClickedBlock onClickedBlock;
@property (nonatomic,strong) NSString *theModifyProjectName;//修改的项目名称 
+ (JGJBillModifyProNameView *)JGJBillModifyProNameViewShowWithMessage:(NSString *)message;


@end
