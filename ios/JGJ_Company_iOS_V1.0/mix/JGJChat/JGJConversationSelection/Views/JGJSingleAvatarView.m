//
//  JGJSingleAvatarView.m
//  mix
//
//  Created by Json on 2019/3/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJSingleAvatarView.h"
#import "JGJAvatarView.h"

extern CGFloat contentWidthRatio;
extern NSInteger maxCountPerRow;
extern CGFloat inset;

@interface JGJSingleAvatarView ()
@property (nonatomic, weak) JGJAvatarView *avatarView;
@property (nonatomic, weak) UILabel *nameLabel;
@end

@implementation JGJSingleAvatarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * contentWidthRatio;
        CGFloat avatarWH = (maxWidth - 20 * 2 - (maxCountPerRow - 1) * inset) / maxCountPerRow;
        
        JGJAvatarView *avatarView = [[JGJAvatarView alloc]  initWithFrame:CGRectMake(0, 0, avatarWH, avatarWH)];
        avatarView.fontSizeRatio = avatarWH / 50.0;
        [self addSubview:avatarView];
        self.avatarView = avatarView;
        
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(self);
            make.width.height.mas_equalTo(avatarWH);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont boldSystemFontOfSize:AppFont30Size];
        nameLabel.textColor = AppFont333333Color;
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarView.mas_right).offset(10);
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self);
        }];

    }
    return self;
}

- (void)setName:(NSString *)name
{
    _name = [name copy];
    self.nameLabel.text = name;
}

- (void)setImageURL:(NSString *)imageURL
{
    _imageURL = [imageURL copy];
    [self.avatarView getRectImgView:[imageURL mj_JSONObject]];
}

@end
