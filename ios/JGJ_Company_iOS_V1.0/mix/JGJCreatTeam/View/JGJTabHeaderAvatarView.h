//
//  JGJTabHeaderAvatarView.h
//  mix
//
//  Created by yj on 2018/7/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJTabHeaderAvatarView;

@protocol JGJTabHeaderAvatarViewDelegate<NSObject>

@optional

- (void)tabHeaderAvatarView:(JGJTabHeaderAvatarView *)avatarView;

@end

@interface JGJTabHeaderAvatarView : UIView

@property (nonatomic, strong) NSArray *avatars;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *num;

@property (nonatomic, assign) BOOL *isHidden;

@property (nonatomic, weak) id <JGJTabHeaderAvatarViewDelegate> delegate;

+ (CGFloat)headerHeight;

@end
