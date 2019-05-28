//
//  JGJBuyCallPhone.h
//  JGJCompany
//
//  Created by Tony on 2017/9/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^IkownBlock)(NSString *buttonTitle);
typedef void(^applyBlock)(NSString *buttonTitle);

@interface JGJBuyCallPhone : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet UIButton *sureButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (copy,   nonatomic)  IkownBlock IknowBlock;
@property (copy,   nonatomic)  applyBlock applyBlock;

+(void)showApplyViewAndClickApply:(applyBlock)applyBlock andClickIkwonButton:(IkownBlock)cancelBlock ;

@end
