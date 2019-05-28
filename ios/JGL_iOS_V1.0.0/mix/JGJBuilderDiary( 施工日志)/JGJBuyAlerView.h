//
//  JGJBuyAlerView.h
//  JGJCompany
//
//  Created by Tony on 2017/7/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BuyAlertBlock)(NSString *content);
typedef void(^BcancelAlertBlock)(NSString *content);

@interface JGJBuyAlerView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet UIButton *CancelButton;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (copy, nonatomic) BuyAlertBlock BuyBlock;
@property (copy, nonatomic) BcancelAlertBlock CancelBlock;

+(void)showBottemMoreButtonWithContent:(NSString *)content andClickCancelButton:(BuyAlertBlock)buyBlock cancelBlock:(BcancelAlertBlock)cancelBlock;

@end
