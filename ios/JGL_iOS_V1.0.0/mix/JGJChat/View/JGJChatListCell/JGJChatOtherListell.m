//
//  JGJChatOtherListell.m
//  JGJCompany
//
//  Created by Tony on 16/9/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatOtherListell.h"

#import "UIButton+JGJUIButton.h"

#import "UILabel+JGJCopyLable.h"

@interface JGJChatOtherListell ()

@property (nonatomic,assign) CGFloat expandButtonConstraintH_Float;

@property (nonatomic,assign) CGFloat expandButtonConstraintB_Float;

@property (nonatomic,assign) CGFloat collectionViewConstraintB_Float;

@property (nonatomic,assign) CGFloat contentLabelConstraintH_Float;

@property (weak, nonatomic) IBOutlet UIButton *expandButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expandButtonConstraintH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expandButtonConstraintB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConstraintW;

@property (strong, nonatomic) UIButton *headButton;

//@property (weak, nonatomic) IBOutlet UIView *contentDetailView;

@property (strong, nonatomic) NSMutableArray *thumbnails;
@end

@implementation JGJChatOtherListell
- (void)subClassInit{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.expandButtonConstraintH_Float = self.expandButtonConstraintH.constant;
    self.collectionViewConstraintB_Float = self.collectionViewConstraintB.constant;
    self.expandButtonConstraintB_Float = self.expandButtonConstraintB.constant;
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:self.nameLabel.font.pointSize];
    
    self.contentLabelMaxW = self.collectionViewConstraintW.constant;
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
    self.headButton = [UIButton new];
    [self.avatarImageView addSubview:self.headButton];
    [self.headButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.avatarImageView);
    }];
    
    //取消高亮效果
    [self.headButton setAdjustsImageWhenHighlighted:NO];
    
    CGFloat padding = 10;
    CGFloat thumbnailImageViewWH = (TYGetUIScreenWidth - 30) / 4.0;
    NSMutableArray *thumbnails = [NSMutableArray new];
    self.thumbnails = thumbnails;
    for (NSInteger indx = 0; indx < 4; indx ++) {
        
        UIImageView *thumbnailImageView = [[UIImageView new] init];
        
        thumbnailImageView.tag = 100 + indx;
        
        thumbnailImageView.backgroundColor = [UIColor whiteColor];
        
        [thumbnails addObject:thumbnailImageView];
        
        [self.contentDetailView addSubview:thumbnailImageView];
    }
    
    [thumbnails mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:10 tailSpacing:10];
    
    [thumbnails mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentLabel.mas_bottom).mas_offset(10);
        
        make.width.mas_equalTo(thumbnailImageViewWH);
        
        make.bottom.equalTo(self.contentDetailView.mas_bottom).mas_offset(-10);
    }];
}
-(void)subLogClassWithModel:(JGJLogSectionListModel *)jgjChatListModel
{
    _nameCenterConstance.constant = 0;
    //心需求 去掉时间
    _dateLabel.hidden = YES;
    
    _LogClassTypeLable.text = jgjChatListModel.cat_name;
    NSInteger imgCount = jgjChatListModel.imgs.count;
    
    NSString *thumbnailsurl = @"";
    for (UIImageView *imageView in self.thumbnails) {
        
        NSInteger index = imageView.tag - 100;
        imageView.hidden = NO;
        if (jgjChatListModel.imgs.count > 3) {
            
            if (index == 3) {
                
                imageView.image = [UIImage imageNamed:@"more_ thumbnail_Icon"];
                
                break;
                
            }else {
                
                thumbnailsurl = jgjChatListModel.imgs[index];
                
                NSString *clipStr = [NSString stringWithFormat:@"%@%@/%@/", JLGHttpRequest_UpLoadPicUrl_center_image,ImageUrlCenterCut, thumbnailsurl];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:clipStr] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
                
            }
            
        }else if(index < jgjChatListModel.imgs.count){
            
            thumbnailsurl = jgjChatListModel.imgs[index];
            
            NSString *clipStr = [NSString stringWithFormat:@"%@%@/%@/", JLGHttpRequest_UpLoadPicUrl_center_image,ImageUrlCenterCut, thumbnailsurl];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:clipStr] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
        }else {
            
            imageView.hidden = YES;
        }
        
    }
    UIColor *backGroundColor = [NSString modelBackGroundColor:jgjChatListModel.user_info.real_name];
    [self.headButton setMemberPicButtonWithHeadPicStr:jgjChatListModel.user_info.head_pic memberName:jgjChatListModel.user_info.real_name memberPicBackColor:backGroundColor];
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    //设置姓名
    self.nameLabel.text = jgjChatListModel.user_info.real_name;
    
    if (![NSString isEmpty: jgjChatListModel.user_info.real_name]) {
        if ( jgjChatListModel.user_info.real_name.length >4) {
            NSString *subStr = [jgjChatListModel.user_info.real_name substringToIndex:3];
            self.nameLabel.text = [subStr stringByAppendingString:@"..."];
        }
    }
    
    //发施工日志情况，优先显示质量，再显示
    self.contentLabel.text = jgjChatListModel.show_list_content;
    
    
    if ([NSString isEmpty:self.contentLabel.text]) {
        
        self.contentLabelConstraintH.constant = 0;
    }else{
        
        CGFloat labelheight = [self getTitleSizeHeigt:self.contentLabel.text];
#pragma mark - 修改过后可以显示设定的行数
        self.contentLabelConstraintH.constant = labelheight>21?42:21;

    }
    
    self.contentLabel.numberOfLines = 2;
    //设置日期
    self.dateLabel.text = jgjChatListModel.create_time;
    
    //设置底部间距
    if (imgCount == 0) {
        [self setCollectionViewBConstant:0.0];
        self.expandButtonConstraintB.constant = self.expandButtonConstraintB_Float/2.0;
    }else{
        [self setCollectionViewBConstant:self.collectionViewConstraintB_Float];
        self.expandButtonConstraintB.constant = self.expandButtonConstraintB_Float;
    }
    
    //设置底部的照片
    [self setCollectionImgs:imgCount chatListType:JGJChatListLog];
    [self layoutIfNeeded];
    
    self.headButton.userInteractionEnabled = NO;
    self.avatarImageView.userInteractionEnabled = NO;

    
}

#pragma mark - 给子模块里面的通知和其他想起设置样式
- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel{
    
    JGJChatListBelongType belongType = jgjChatListModel.belongType;
    NSInteger imgCount = jgjChatListModel.msg_src.count;
    
    NSString *thumbnailsurl = @"";
    
    for (UIImageView *imageView in self.thumbnails) {
        
        NSInteger index = imageView.tag - 100;
        imageView.hidden = NO;
        if (jgjChatListModel.msg_src.count > 3) {
            
            if (index == 3) {
                
                imageView.image = [UIImage imageNamed:@"more_ thumbnail_Icon"];
                
                break;
                
            }else {
                
                thumbnailsurl = jgjChatListModel.msg_src[index];
                
                NSString *clipStr = [NSString stringWithFormat:@"%@%@/%@/", JLGHttpRequest_UpLoadPicUrl_center_image,ImageUrlCenterCut, thumbnailsurl];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:clipStr] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
                
            }
            
        }else if(index < jgjChatListModel.msg_src.count){
            
            thumbnailsurl = jgjChatListModel.msg_src[index];
            
            NSString *clipStr = [NSString stringWithFormat:@"%@%@/%@/", JLGHttpRequest_UpLoadPicUrl_center_image,ImageUrlCenterCut, thumbnailsurl];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:clipStr] placeholderImage:[UIImage imageNamed:@"defaultPic"]];
        }else {
            
            imageView.hidden = YES;
        }
        
    }
  
    //设置头像
    UIColor *backGroundColor = [NSString modelBackGroundColor:jgjChatListModel.user_name];
    [self.headButton setMemberPicButtonWithHeadPicStr:jgjChatListModel.user_info.head_pic memberName:jgjChatListModel.user_name memberPicBackColor:backGroundColor];
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    //设置姓名
    if (belongType == JGJChatListBelongMine) {//我的
        self.nameLabel.text = @"我";
    }else if(belongType == JGJChatListBelongOther || belongType == JGJChatListBelongGroupOut){
        
        self.nameLabel.text = jgjChatListModel.user_name;

        if (![NSString isEmpty: jgjChatListModel.user_name]) {
            if ( jgjChatListModel.user_name.length > 4) {
                NSString *subStr = [jgjChatListModel.user_name substringToIndex:3];
                self.nameLabel.text = [subStr stringByAppendingString:@"..."];
            }
        }
    }
        
    //发施工日志情况，优先显示质量，再显示
    if (![NSString isEmpty:jgjChatListModel.msg_text]) {
        
        self.contentLabel.text = jgjChatListModel.msg_text;
        
    }else {
        
        self.contentLabel.text = jgjChatListModel.techno_quali_log;
    }
    
    if ([NSString isEmpty:self.contentLabel.text]) {
        self.contentLabelConstraintH.constant = 0;
    }else{
        
        CGFloat labelheight = [self getTitleSizeHeigt:self.contentLabel.text];
#pragma mark - 修改过后可以显示设定的行数
        self.contentLabelConstraintH.constant = labelheight>21?42:21;

    }
    self.contentLabel.numberOfLines = 2;

    //设置日期
    self.dateLabel.text = jgjChatListModel.send_time;
    
    //设置底部间距
    if (imgCount == 0) {
        [self setCollectionViewBConstant:0.0];
        self.expandButtonConstraintB.constant = self.expandButtonConstraintB_Float/2.0;
    }else{
        [self setCollectionViewBConstant:self.collectionViewConstraintB_Float];
        self.expandButtonConstraintB.constant = self.expandButtonConstraintB_Float;
    }
    //设置底部的照片
    [self setCollectionImgs:imgCount chatListType:JGJChatListLog];
    [self layoutIfNeeded];
    
    self.headButton.userInteractionEnabled = NO;
    self.avatarImageView.userInteractionEnabled = NO;
    
}

- (CGFloat )getTitleSizeHeigt:(NSString *)msg_text{
    
    NSDictionary *attrs = @{NSFontAttributeName : self.contentLabel.font};
    CGSize maxSize = CGSizeMake(TYGetUIScreenWidth - 44.0, MAXFLOAT);
    CGSize titleSize = [msg_text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    return titleSize.height + kChatListAllDetailCellH;
}
@end
