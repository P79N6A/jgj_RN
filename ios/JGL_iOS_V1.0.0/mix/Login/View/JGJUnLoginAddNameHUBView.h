//
//  JGJAddNameHUBView.h
//  mix
//
//  Created by Tony on 16/3/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTextField.h"

@class JGJUnLoginAddNameHUBView;
@protocol JGJUnLoginAddNameHUBViewDelegate <NSObject>
@optional
- (void)AddNameHubSaveSuccess:(JGJUnLoginAddNameHUBView *)contactsView;
@end

typedef void(^JGJUnLoginAddNameHUBViewBlock)(id);

@interface JGJUnLoginAddNameHUBView : UIView
<
    UITextFieldDelegate
>
@property (nonatomic,  weak) id<JGJUnLoginAddNameHUBViewDelegate> delegate;
@property (nonatomic,  weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,  weak) IBOutlet LengthLimitTextField *nameTF;
@property (nonatomic, strong) NSString *currentVcStr;//当前控制器

+ (NSString *)handleSkipVc:(NSString *)currentVcStr;
- (void)showAddNameHubView;
- (IBAction)hiddenAddNameHubView:(UIButton *)sender;

/**
 *  是否弹出填写姓名的框
 *
 *  @param Vc 需要显示到的vc
 *
 *  @return 返回nil,不需要显示，返回非nil，需要显示
 */
+ (JGJUnLoginAddNameHUBView *)hasRealNameByVc:(UIViewController <JGJUnLoginAddNameHUBViewDelegate>*)Vc;

//回调点击取消按钮
@property (nonatomic, copy) JGJUnLoginAddNameHUBViewBlock unLoginAddNameHUBViewBlock;
@end
