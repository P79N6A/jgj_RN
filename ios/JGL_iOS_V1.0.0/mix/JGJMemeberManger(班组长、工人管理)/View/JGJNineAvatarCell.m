//
//  JGJNineAvatarCell.m
//  mix
//
//  Created by YJ on 2019/1/6.
//  Copyright © 2019年 JiZhi. All rights reserved.
//

#import "JGJNineAvatarCell.h"

@interface JGJNineAvatarCell()<JGJCusNineAvatarViewDelegate>

@property (strong, nonatomic) JGJCusNineAvatarView *avatarView;

@end

@implementation JGJNineAvatarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, [JGJCusNineAvatarView avatarSingleViewHeight] + 20);
    
    JGJCusNineAvatarView *avatarView  = [[JGJCusNineAvatarView alloc] initWithFrame:rect];
    
    avatarView.delegate = self;
    
    self.avatarView = avatarView;
    
    avatarView.maxImageCount = 8;
    
    [self.contentView addSubview:avatarView];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setPhotos:(NSMutableArray *)photos {
    
    _photos = photos;
    
    self.avatarView.isShowAddBtn = self.isShowAddBtn;
    
    self.avatarView.isCheckImage = self.isCheckImage;
    
    self.avatarView.photos = photos;
    
    CGFloat height = [JGJCusNineAvatarView avatarViewHeightWithPhotoCount:photos.count];
    
    self.avatarView.height = height;
}

#pragma mark - JGJCusNineAvatarViewDelegate

- (void)cusNineAvatarView:(JGJCusNineAvatarView *)avatarView checkView:(JGJCusCheckView *)checkView{
    
//    self.avatarView.frame = avatarView.frame;
    
//    CGFloat height = [JGJCusNineAvatarView avatarViewHeightWithPhotoCount:avatarView.photos.count];
//
//    avatarView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, height);
    
    if (checkView) {
        
        if ([self.delegate respondsToSelector:@selector(nineAvatarCell:avatarView:checkView:)]) {
            
            [self.delegate nineAvatarCell:self avatarView:avatarView checkView:checkView];
            
        }
        
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
