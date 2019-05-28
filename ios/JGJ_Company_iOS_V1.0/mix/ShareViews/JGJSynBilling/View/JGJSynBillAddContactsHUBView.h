//
//  JGJSynBillAddContactsHUBView.h
//  mix
//
//  Created by Tony on 16/3/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTextField.h"

typedef enum : NSUInteger {
    AddSynContactsHUBViewType = 1,
    AddProTeamContactsHUBViewType
} AddContactsHUBViewType;
@class JGJSynBillAddContactsHUBView;
@protocol JGJSynBillAddContactsHUBViewDelegate <NSObject>
- (void)SynBillAddContactsHubSaveSuccess:(JGJSynBillAddContactsHUBView *)contactsView;
@end

@interface JGJSynBillAddContactsHUBView : UIView
<
    UITextFieldDelegate
>
@property (nonatomic,  weak) id<JGJSynBillAddContactsHUBViewDelegate> delegate;
@property (nonatomic,  weak) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic,  weak) IBOutlet LengthLimitTextField *nameTF;
@property (nonatomic,  weak) IBOutlet LengthLimitTextField *phoneNumTF;
@property (nonatomic,  weak) IBOutlet LengthLimitTextField *descriptTF;
@property (nonatomic,strong) JGJSynBillingModel *jgjSynBillingModel;

//2.0添加需要将保存改为添加，备注取消
@property (nonatomic, assign) AddContactsHUBViewType addContactsHUBViewType;

- (void)showAddContactsHubView;
- (IBAction)hiddenAddContactsHubView:(UIButton *)sender;
@end
