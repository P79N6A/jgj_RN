//
//  JGJRecordTipView.h
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJRecordTipViewDelegate <NSObject>

- (void)JGJRecordTipViewTapRecordNosureTiplable;

@end
@interface JGJRecordTipView : UIView
@property (strong, nonatomic) IBOutlet UILabel *centerView;
@property (strong, nonatomic) IBOutlet UILabel *centerLable;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIView *baseView;

@property (strong, nonatomic) IBOutlet UILabel *tipLable;

@property (strong, nonatomic) IBOutlet UIView *animalView;

@property (strong, nonatomic) id <JGJRecordTipViewDelegate>delegate;

@property (strong, nonatomic) IBOutlet UILabel *sureLable;

@property (strong, nonatomic)  NSTimer *timer;

@property (strong, nonatomic) UIImageView *imageview;
-(void)setWaitConfirmAndText:(NSString *)text;

@end
