//
//  JGJMoreSelectedTableTopView.h
//  mix
//
//  Created by Tony on 2018/3/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChoiceTheAllPerson) (BOOL selected, UIButton *sender);
@interface JGJMoreSelectedTableTopView : UIView

@property (nonatomic, strong) UIButton *selectedAll;
@property (nonatomic, assign) BOOL isSelctedAll;
@property (strong, nonatomic)  NSString *manNum;
@property (nonatomic,copy) ChoiceTheAllPerson choiceAllPerson;

@end
