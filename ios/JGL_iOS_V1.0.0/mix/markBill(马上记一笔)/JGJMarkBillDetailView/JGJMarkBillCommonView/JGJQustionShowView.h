//
//  JGJQustionShowView.h
//  mix
//
//  Created by Tony on 2018/1/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum: NSUInteger{
  JGJBalanceAmountType,//未接工资
  JGJNowPayAmountType,//本次结算金额
  JGJRemaingAmountType,//剩余未接金额
    
}JGJQuestionShowtype;
@interface JGJQustionShowView : UIView
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet UIButton *KownBtn;
@property (assign, nonatomic)  JGJQuestionShowtype showType;

+ (void)showQustionFromPoint:(CGPoint)point FromShowType:(JGJQuestionShowtype)type;;
+ (void)removeQustionView;

@end
