//
//  JGJCalenderDateView.h
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJCalenderDateViewDelegate <NSObject>

-(void)JGJCalenderDateViewClickLeftButton;

-(void)JGJCalenderDateViewClickrightButton;

-(void)JGJCalenderDateViewtapdateLable;

@end
@interface JGJCalenderDateView : UIView
@property (strong, nonatomic) IBOutlet UILabel *dateTitle;
@property (strong, nonatomic) IBOutlet UIButton *rightDateButton;
@property (strong, nonatomic) IBOutlet UIButton *leftDateButton;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) id <JGJCalenderDateViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftBtnCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleCenterY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtnCenterY;
@property (weak, nonatomic) IBOutlet UILabel *lineView;

@end
