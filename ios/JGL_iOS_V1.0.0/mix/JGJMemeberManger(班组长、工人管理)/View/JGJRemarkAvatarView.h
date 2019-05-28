//
//  JGJRemarkAvatarView.h
//  mix
//
//  Created by yj on 2019/1/4.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JGJRemarkAvatarView;

@protocol JGJRemarkAvatarViewDelegate <NSObject>

@optional

- (void)remarkAvatarView:(JGJRemarkAvatarView *)avatarView;

@end

@interface JGJRemarkAvatarView : UIView

@property (nonatomic, weak) id <JGJRemarkAvatarViewDelegate> delegate;

//图片个数

@property (nonatomic, strong) NSArray *images;

//获取高度
+(CGFloat)avatarViewHeightWithImageCount:(NSInteger)imagesCount;

@end

NS_ASSUME_NONNULL_END
