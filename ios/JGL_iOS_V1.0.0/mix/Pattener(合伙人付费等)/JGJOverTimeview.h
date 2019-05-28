//
//  JGJOverTimeview.h
//  JGJCompany
//
//  Created by Tony on 2017/8/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^cancelBlock)(NSString *buttonTitle);
typedef void(^OKBlock)(NSString *buttonTitle);

@interface JGJOverTimeview : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UILabel *tiplable;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic)  JGJOverTimeModel *TimeModel;
@property (copy, nonatomic)  cancelBlock cancelBlock;
@property (copy, nonatomic)  OKBlock OKblock;
@property (strong, nonatomic) IBOutlet UIButton *singerButton;
@property (strong, nonatomic) IBOutlet UILabel *pronameLbale;

+(void)showOverTimeViewWithModel:(JGJOverTimeModel *)timeModel andClickCancelButton:(cancelBlock)cancelBlock andClickOKButton:(OKBlock)okBlock;
@end
