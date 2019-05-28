//
//  JGJConversationSelectionBottomView.h
//  mix
//
//  Created by Json on 2019/3/26.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJConversationSelectionBottomView : UIView
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign, getter=isButtonEnable) BOOL buttonEnable;
@property (nonatomic, copy) void(^ensureAction)();
+ (instancetype)bottomView;
@end
