//
//  JGJChatNoDataDefaultView.h
//  mix
//
//  Created by Tony on 2016/11/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatListType.h"
@protocol JGJChatNoDataDefaultViewDelegate <NSObject>

- (void)JGJChatNoDataDefaultViewClickHelpBtn;

@end
@interface JGJChatNoDataDefaultView : UIView

@property (nonatomic,assign) JGJChatListType chatListType;

@property (nonatomic,strong) id <JGJChatNoDataDefaultViewDelegate> delegate;

- (BOOL )needAddViewWithListType:(JGJChatListType)chatListType;

@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet UIButton *helpButton;
@property (strong, nonatomic) IBOutlet UIImageView *defultImageview;

@end
