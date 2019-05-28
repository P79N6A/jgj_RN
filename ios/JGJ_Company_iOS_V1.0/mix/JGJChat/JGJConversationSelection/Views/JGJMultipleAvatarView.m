//
//  JGJMultipleAvatarView.m
//  mix
//
//  Created by Json on 2019/3/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMultipleAvatarView.h"
#import "JGJAvatarView.h"

/** 每行最多显示的图片数 */
NSInteger const maxCountPerRow = 6;
/** 图片之间间距 */
CGFloat const inset = 5;

extern CGFloat contentWidthRatio;

@interface JGJMultipleAvatarView ()

@end
@implementation JGJMultipleAvatarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * contentWidthRatio;
        _avatarWH = (maxWidth - 20 * 2 - (maxCountPerRow - 1) * inset) / maxCountPerRow;
    }
    return self;
}


- (void)setImageURLs:(NSArray<NSString *> *)imageURLs
{
    _imageURLs = imageURLs;
    NSInteger count = imageURLs.count;
    for (NSInteger i = 0; i < count; i++) {
        JGJAvatarView *imageView = [[JGJAvatarView alloc] initWithFrame:CGRectMake(0, 0, _avatarWH, _avatarWH)];
        imageView.fontSizeRatio = _avatarWH / 50.0;
        NSString *imageURL = imageURLs[i];
        [self addSubview:imageView];
        [imageView getRectImgView:[imageURL mj_JSONObject]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    for (NSInteger i = 0; i < count; i++) {
        JGJAvatarView *imageView = self.subviews[i];
        imageView.width = _avatarWH;
        imageView.height = _avatarWH;
        imageView.x = (i % maxCountPerRow) * (_avatarWH + inset);
        imageView.y = (i / maxCountPerRow) * (_avatarWH + inset);
    }
}
+ (CGFloat)inset {
    return inset;
}

@end
