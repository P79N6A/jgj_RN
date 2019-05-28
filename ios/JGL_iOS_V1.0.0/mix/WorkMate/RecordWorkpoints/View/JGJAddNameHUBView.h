//
//  JGJAddNameHUBView.h
//  mix
//
//  Created by Tony on 16/3/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTextField.h"

@class JGJAddNameHUBView;
@protocol JGJAddNameHUBViewDelegate <NSObject>
@optional
- (void)AddNameHubSaveSuccess:(JGJAddNameHUBView *)contactsView;
@end

@interface JGJAddNameHUBView : UIView
<
    UITextFieldDelegate
>
@property (nonatomic,  weak) id<JGJAddNameHUBViewDelegate> delegate;
@property (nonatomic,  weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,  weak) IBOutlet LengthLimitTextField *nameTF;

- (void)showAddNameHubView;
- (IBAction)hiddenAddNameHubView:(UIButton *)sender;

/**
 *  是否弹出填写姓名的框
 *
 *  @param Vc 需要显示到的vc
 *
 *  @return 返回nil,不需要显示，返回非nil，需要显示
 */
+ (JGJAddNameHUBView *)hasRealNameByVc:(UIViewController <JGJAddNameHUBViewDelegate>*)Vc;
@end
