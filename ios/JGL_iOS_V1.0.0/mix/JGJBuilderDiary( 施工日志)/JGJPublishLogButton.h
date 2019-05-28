//
//  JGJPublishLogButton.h
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol choiceLogDelegate <NSObject>
- (void)clickChoiceTemplateLogButton;
- (void)clickChoicePublsihLogButton;

@end
@interface JGJPublishLogButton : UIView
@property (strong, nonatomic) IBOutlet UIButton *choiceLogButton;
@property (strong, nonatomic) IBOutlet UIButton *publishLogButton;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) id <choiceLogDelegate>delegate;
@end
