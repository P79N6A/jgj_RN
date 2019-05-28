//
//  JGJLoginFindAccountNumberQuestionThreeVC.h
//  mix
//
//  Created by Tony on 2018/6/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJLoginFindAccountAnswerModel.h"
@interface JGJLoginFindAccountNumberQuestionThreeVC : UIViewController

@property (nonatomic, assign) BOOL isHavChoiceRecordWorkpoints;// 是否选择记工
@property (nonatomic, strong) NSString *phoneNumberStr;
@property (nonatomic, strong) JGJLoginFindAccountAnswerModel *answerModel;

@end
