//
//  JGJSelectView.h
//  mix
//
//  Created by Tony on 2017/2/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClickcalenderButtondelegate<NSObject>
-(void)ClickLeftButtonTocalender;
//-(void)ClickRightButtonTocalender;
@end
@interface JGJSelectView : UIView
@property (strong, nonatomic) IBOutlet UIButton *leftButton;

@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic,weak)id <ClickcalenderButtondelegate> calenderDelegate;

@end
