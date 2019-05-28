//
//  JGJCusAddMediaView.h
//  mix
//
//  Created by yj on 2019/3/26.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJCusAddMediaViewDefaultBtnType,
    
    JGJCusAddMediaViewPhotoAlbumBtnType, //相册
    
    JGJCusAddMediaViewShootBtnType, //拍摄
    
    JGJCusAddMediaViewPostCardType //我的名片
    
} JGJCusAddMediaViewBtnType;

@class JGJCusAddMediaView;

NS_ASSUME_NONNULL_BEGIN

@protocol JGJCusAddMediaViewDelegate <NSObject>

- (void)cusAddMediaView:(JGJCusAddMediaView *)mediaView didSelBtnType:(JGJCusAddMediaViewBtnType)type;

@end

@interface JGJCusAddMediaView : UIView

+(CGFloat)meidaViewHeight;

@property (nonatomic, weak) id <JGJCusAddMediaViewDelegate> delegate;

//选择按钮类型
@property (nonatomic, assign) JGJCusAddMediaViewBtnType btnType;

@end

NS_ASSUME_NONNULL_END
