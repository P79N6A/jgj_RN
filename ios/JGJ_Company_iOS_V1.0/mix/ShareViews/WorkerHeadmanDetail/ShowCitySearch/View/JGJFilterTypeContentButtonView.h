//
//  JGJFilterTypeContentButtonView.h
//  mix
//
//  Created by celion on 16/4/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJFilterTypeContentButtonView;
@protocol JGJFilterTypeContentButtonViewDelegate <NSObject>
- (void) filterCityTypeMenuButtonPressed:(UIButton *)cityButton;
- (void)filterWorkTypeButtonPressed:(UIButton *)workTypeButton;
@end
@interface JGJFilterTypeContentButtonView : UIView
+ (instancetype)filterTypeContentButtonView;
@property (nonatomic, weak) id <JGJFilterTypeContentButtonViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *workTypeName;

@property (weak, nonatomic) IBOutlet UIImageView *cityFlagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *workTypeFlagImageView;
@property (weak, nonatomic) IBOutlet UIButton *workTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;

@end
