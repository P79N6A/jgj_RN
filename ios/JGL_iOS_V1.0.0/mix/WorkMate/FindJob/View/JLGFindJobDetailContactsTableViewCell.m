//
//  JLGFindJobDetailContactsTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/18.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGFindJobDetailContactsTableViewCell.h"
#import "TYPhone.h"
#import "CALayer+SetLayer.h"
#import "UIImageView+WebCache.h"
#import "UIView+GNUtil.h"
#define baseImageTag 100//imageView的基准tag
@interface JLGFindJobDetailContactsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *yourFirendsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIButton *checkMoreButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewScrollViewH;

@end
@implementation JLGFindJobDetailContactsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.yourFirendsLabel.textColor = AppFont333333Color;
    self.yourFirendsLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    self.checkMoreButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    self.imageViewScrollViewH.constant = TYIS_IPHONE_6P ? 105 : (TYIS_IPHONE_6 ? 90 : 80);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setFriendsInfoArray:(NSArray *)friendsInfoArray{
    _friendsInfoArray = friendsInfoArray;

    for (UIView *view in self.imageScrollView.subviews) {
        [view removeFromSuperview];
    }
    NSInteger marginNum = 25;
    CGFloat padding = 12;
    CGFloat labelH = 23;
    CGFloat labelW = (TYGetUIScreenWidth - 4 * marginNum - 2 * 10 ) / 5.0 ;
    
    CGFloat imageW = labelW;
    CGFloat imageH = imageW;
    CGFloat imageY = 0;
    NSInteger count = friendsInfoArray.count;
    for (NSUInteger i = 0; i < (count > 5 ? 5 : count); i++) {
        CGFloat imageX = (marginNum + imageW)*i;
        NSDictionary *friendModel = friendsInfoArray[i];
    
        //添加头像
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:TYSetRect(imageX, imageY, imageW, imageH)];
        headImageView.tag = baseImageTag+i;
        [headImageView.layer setLayerCornerRadius:TYGetViewW(headImageView) / 2];
        NSString *picUrlString = [NSString stringWithFormat:@"%@%@",JLGHttpRequest_Public,friendModel[@"head_pic"]];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:picUrlString] placeholderImage:[UIImage imageNamed:@"leader_Defulat_Headpic"]];
        headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
        [headImageView addGestureRecognizer:singleTap];//点击图片事件
        //添加名字
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:TYSetRect(imageX, TYGetMaxY(headImageView) + padding * 0.5, labelW, labelH)];

        nameLabel.textColor = AppFont666666Color;
        nameLabel.text = friendModel[@"friendname"];
        nameLabel.font = [UIFont systemFontOfSize:AppFont24Size];
        nameLabel.textAlignment = NSTextAlignmentCenter;

        [self.imageScrollView addSubview:nameLabel];
        [self.imageScrollView addSubview:headImageView];
    }
    // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
    self.imageScrollView.contentSize = CGSizeMake(friendsInfoArray.count * (imageW + marginNum), 0);
    self.imageScrollView.scrollEnabled = NO;
//    self.yourFirendsLabel.text = [NSString stringWithFormat:@"你有%@个朋友认识班组长/工头",@(friendsInfoArray.count)];
    [self setFirendsLabelText:friendsInfoArray.count];
}

- (void)setFirendsLabelText:(NSInteger )friednsCount{
    NSString *selectedNumStr = [NSString stringWithFormat:@"  %@  ",@(friednsCount)];//主要用于富文本的计算
    
    NSString *selectedStr;
    if (!self.frontString || !self.behindString) {
        selectedStr = [NSString stringWithFormat:@"你有%@个朋友认识班组长/工头",selectedNumStr];
    }else{
        selectedStr = [NSString stringWithFormat:@"%@%@%@",self.frontString,selectedNumStr,self.behindString];
    }

    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:selectedStr];
    
    //数字需要红色
    if (!self.frontString || !self.behindString) {
        [contentStr addAttribute:NSForegroundColorAttributeName value:AppFontd7252cColor range:NSMakeRange(2, selectedNumStr.length)];
    }else{
        [contentStr addAttribute:NSForegroundColorAttributeName value:AppFontd7252cColor range:NSMakeRange(self.frontString.length, selectedNumStr.length)];
    }
    
    self.yourFirendsLabel.attributedText = contentStr;
}

- (void)photoTapped:(UITapGestureRecognizer *)recognizer{
    NSInteger index = recognizer.view.tag - baseImageTag;
    NSDictionary *friendModel = self.friendsInfoArray[index];
//    [TYPhone callPhoneByNum:friendModel[@"telph"]];
    [TYPhone callPhoneByNum:friendModel[@"telph"] view:self.contentView];
}


- (IBAction)contacFriendButtonPressed:(UIButton *)sender {
    
    if (self.blockContactButtonPressed) {
        self.blockContactButtonPressed();
    }
}

@end
