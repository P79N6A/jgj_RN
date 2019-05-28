//
//  YZGAddContactsHUBView.h
//  mix
//
//  Created by Tony on 16/3/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGAddFmNoContactsView.h"

#import "TYTextField.h"

@class YZGAddContactsHUBView,YZGAddForemanModel;
@protocol YZGAddContactsHUBViewDelegate <NSObject>
- (void)AddContactsHubSaveBtcClick:(YZGAddContactsHUBView *)contactsView;
@end

@interface YZGAddContactsHUBView : UIView
<
    UITextFieldDelegate,
    YZGAddFmNoContactsViewDelegate
>
@property (nonatomic,  weak) id<YZGAddContactsHUBViewDelegate> delegate;
@property (nonatomic,  weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,  weak) IBOutlet LengthLimitTextField *nameTF;
@property (nonatomic,  weak) IBOutlet LengthLimitTextField *phoneNumTF;
@property (nonatomic,strong) YZGAddForemanModel *yzgAddForemanModel;

- (void)showAddContactsHubView;
- (IBAction)hiddenAddContactsHubView:(UIButton *)sender;
@end
