//
//  JGJTipAccountView.h
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddAccountDelegate <NSObject>
-(void)clickAddaccountButton;
@end
@interface JGJTipAccountView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *accountButton;
@property (strong, nonatomic)  id <AddAccountDelegate> delegate;

@end
