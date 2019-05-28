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

#import "YZGAddContactsTableViewCell.h"

typedef enum : NSUInteger {
    
    YZGAddContactsHUBViewDefaultType, //默认类型添加人员
    
    YZGAddContactsHUBViewSynType, //邀请同步类型
    
    YZGAddContactsHUBViewSynToMeType //邀请同步给我的类型

} YZGAddContactsHUBViewType;

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
@property (weak, nonatomic) IBOutlet LengthLimitTextField *nameTF;
@property (nonatomic,  weak) IBOutlet LengthLimitTextField *phoneNumTF;
@property (nonatomic,strong) YZGAddForemanModel *yzgAddForemanModel;

@property (nonatomic, assign) YZGAddContactsHUBViewType hubViewType;

/**
 *  聊天界面传入的model,如果有就是聊天
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

- (void)showAddContactsHubView;
- (IBAction)hiddenAddContactsHubView:(UIButton *)sender;
@end
