//
//  JGJAvatarView.m
//  mix
//
//  Created by YJ on 17/5/16.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAvatarView.h"
#import "UIView+GNUtil.h"
#import "UIImageView+WebCache.h"

#import "NSString+Extend.h"

#import "UIButton+JGJUIButton.h"

#import "UIButton+WebCache.h"

#define ImgMargin 2 //四周间距

#define MiddleMargin 1 //中间间距

#define MsgCountViewWH 8 //消息数大小

//#define AvatarViewW 50
//
//#define AvatarViewH 50

@interface JGJAvatarView ()

@property (nonatomic, assign) NSInteger imageViewCount;

@property (nonatomic, strong) UIView *flagView;

@end

@implementation JGJAvatarView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    if ([NSString isFloatZero:_AvatarViewWH]) {
        
        _AvatarViewWH = self.width;
        
    }
    
    //添加是否有未读的消息，默认隐藏
    
    [self flagView];
    
    [self setAvatarHeaderView];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self.layer setLayerCornerRadius:JGJHeadCornerRadius];
        
        self.backgroundColor =  TYColorHex(0xD8D9E6);
        _fontSizeRatio = 1.0;
    }
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        if ([NSString isFloatZero:_AvatarViewWH]) {
            
            _AvatarViewWH = self.width;
            
        }
        
        [self.layer setLayerCornerRadius:JGJHeadCornerRadius];
        
        self.backgroundColor =  TYColorHex(0xD8D9E6);
        
        _fontSizeRatio = 1.0;
        
        [self setAvatarHeaderView];
    }
    
    return self;
}

- (void)setAvatarViewWH:(CGFloat)AvatarViewWH {
    
    _AvatarViewWH = AvatarViewWH;
    
    if ([NSString isFloatZero:_AvatarViewWH]) {
        
        _AvatarViewWH = 50.0;
        
    }
    
}

- (void)setAvatarHeaderView {
    
    //    TYLog(@"imageViewCount ==== %@",@(self.imageViewCount));
    
    CGFloat headBtnHW = (_AvatarViewWH - ImgMargin * 2 - 2 * MiddleMargin) / 3.0;
    
    for (NSInteger indx = 0; indx < 9; indx++) {
        
        NSInteger row = indx / 3;
        
        NSInteger col = indx % 3;
        
        UIButton *headBtn = [UIButton new];
        
        headBtn.tag = 100 + indx;
        
        headBtn.x = (headBtnHW + MiddleMargin) * col + ImgMargin;
        
        headBtn.y = (headBtnHW + MiddleMargin) * row + ImgMargin;
        
        headBtn.width = headBtnHW;
        
        headBtn.height = headBtnHW;
        
        [self addSubview:headBtn];
    }
    
}

/**
 *  获取方形图片，imgMargin用默认的
 */
- (void)getRectImgView:(NSArray *)images {
    
    NSInteger headCount = images.count;
    
    switch (headCount) {
        case 0:{
            
            [self setZeroSubImageViewFrame:images];
        }
            
            break;
            
        case 1:{
            
            [self setOneSubImageViewFrame:images];
            
        }
            
            break;
            
        case 2:{
            
            [self setTwoSubImageViewFrame:images];
            
        }
            
            break;
            
        case 3:{
            
            [self setThreeSubImageViewFrame:images];
            
        }
            
            break;
            
        case 4:{
            
            [self setFourSubImageViewFrame:images];
            
        }
            
            break;
            
        case 5:{
            
            [self setFiveSubImageViewFrame:images];
            
        }
            
            break;
            
        case 6:{
            
            [self setSixSubImageViewFrame:images];
            
            
            
        }
            
            break;
            
        case 7:{
            
            [self setSevenSubImageViewFrame:images];
            
            
        }
            
            break;
            
        case 8:{
            
            [self setEightSubImageViewFrame:images];
            
        }
            
            break;
        case 9:{
            
            [self imageCountLoadHeaderImageView:images];
            
        }
            break;
            
        default: {
            
            [self imageCountLoadHeaderImageView:images];
        }
            
            break;
    }
    
}

- (void)setZeroSubImageViewFrame:(NSArray *)images {
    
    CGFloat headerImageHW = _AvatarViewWH;
    
    for (NSInteger index = 0; index < self.subviews.count; index++) {
        
        UIButton *headBtn = self.subviews[index];
        headBtn.hidden = YES;
    }
}

- (void)setOneSubImageViewFrame:(NSArray *)images {
    
    CGFloat headerImageHW = _AvatarViewWH;
    
    for (NSInteger index = 0; index < self.subviews.count; index++) {
        
        UIButton *headBtn = self.subviews[index];
        headBtn.hidden = YES;
        if (index < 1) {
            
            headBtn.y = 0;
            
            headBtn.x = 0;
            
            headBtn.width = headerImageHW;
            
            headBtn.height = headerImageHW;
            
            
            [self loadHeadImageViewStr:images[index] headBtn:headBtn headImages:images];
            
            headBtn.hidden = NO;
            
        }else {
            
            headBtn.hidden = YES;
        }
    }
    
}

- (void)setTwoSubImageViewFrame:(NSArray *)images {
    
    CGFloat headerImageHW = (_AvatarViewWH - ImgMargin * 2 - MiddleMargin) / 2.0;
    
    for (NSInteger index = 0; index < self.subviews.count; index++) {
        
        UIButton *headBtn = self.subviews[index];
        headBtn.hidden = YES;
        if (index < 2) {
            
            headBtn.y =  _AvatarViewWH / 2.0 - headerImageHW / 2.0;
            
            headBtn.x = (headerImageHW + MiddleMargin) * index + ImgMargin;
            
            headBtn.width = headerImageHW;
            
            headBtn.height = headerImageHW;
            
            [self loadHeadImageViewStr:images[index] headBtn:headBtn headImages:images];
            
            headBtn.hidden = NO;
            
        }else {
            
            headBtn.hidden = YES;
        }
    }
    
}

- (void)setThreeSubImageViewFrame:(NSArray *)images {
    
    NSMutableArray *muImages = images.mutableCopy;
    
    [muImages insertObject:@"" atIndex:0];
    
    CGFloat headerImageHW = (_AvatarViewWH - ImgMargin * 2 - MiddleMargin) / 2.0;
    
    for (NSInteger index = 0; index < self.subviews.count; index++) {
        
        UIButton *headBtn = self.subviews[index];
        headBtn.hidden = YES;
        if (index < 4) {
            
            NSInteger row = index / 2;
            
            NSInteger col = index % 2;
            
            if (row == 0 && index > 0) {
                
                headBtn.x = (headerImageHW + MiddleMargin) * col + ImgMargin - headerImageHW / 2.0;
                
                headBtn.y = (headerImageHW + MiddleMargin) * row + ImgMargin;
                
            }else {
                
                headBtn.x = (headerImageHW + MiddleMargin) * col + ImgMargin;
                
                headBtn.y = (headerImageHW + MiddleMargin) * row + ImgMargin;
                
            }
            
            headBtn.width = headerImageHW;
            
            headBtn.height = headerImageHW;
            
            if (![NSString isEmpty:muImages[index]]) {
                
                [self loadHeadImageViewStr:muImages[index] headBtn:headBtn headImages:muImages];
                
                headBtn.hidden = NO;
            }else {
                
                
                headBtn.hidden = YES;
            }
            
        }else {
            
            headBtn.hidden = YES;
        }
    }
    
}

- (void)setFourSubImageViewFrame:(NSArray *)images {
    
    CGFloat headerImageHW = (_AvatarViewWH - ImgMargin * 2 - MiddleMargin * 2) / 2.0;
    
    for (NSInteger index = 0; index < self.subviews.count; index++) {
        
        UIButton *headBtn = self.subviews[index];
        headBtn.hidden = YES;
        if (index < 4) {
            
            NSInteger row = index / 2;
            
            NSInteger col = index % 2;
            
            headBtn.x = (headerImageHW + MiddleMargin) * col + ImgMargin;
            
            headBtn.y = (headerImageHW + MiddleMargin) * row + ImgMargin;
            
            headBtn.width = headerImageHW;
            
            headBtn.height = headerImageHW;
            
            [self loadHeadImageViewStr:images[index] headBtn:headBtn headImages:images];
            
            headBtn.hidden = NO;
            
        }else {
            
            headBtn.hidden = YES;
        }
    }
    
}

#pragma mark - 5个人头像
- (void)setFiveSubImageViewFrame:(NSArray *)images {
    
    NSMutableArray *muImages = images.mutableCopy;
    
    [muImages insertObject:@"" atIndex:0];
    
    CGFloat headerImageHW = (_AvatarViewWH - ImgMargin * 2 - MiddleMargin * 2) / 3.0;
    
    CGFloat originY = (_AvatarViewWH - (headerImageHW * 2 - MiddleMargin)) / 2.0;
    
    for (UIButton *headBtn in self.subviews) {
        
        NSInteger index = headBtn.tag - 100;
        headBtn.hidden = YES;
        if (index < muImages.count) {
            
            NSInteger row = index / 3;
            
            NSInteger col = index % 3;
            
            headBtn.width = headerImageHW;
            
            headBtn.height = headerImageHW;
            
            if (row == 0 && index > 0) {
                
                headBtn.x = (headerImageHW + MiddleMargin) * col + ImgMargin - headerImageHW / 2.0;
                
                headBtn.y = originY;
                
            }else {
                
                headBtn.x = (headerImageHW + MiddleMargin) * col + ImgMargin;
                
                headBtn.y = (headerImageHW + originY) * row + MiddleMargin;
                
            }
            
            if (![NSString isEmpty:muImages[index]]) {
                
                [self loadHeadImageViewStr:muImages[index] headBtn:headBtn headImages:images];
                
                headBtn.hidden = NO;
            }else {
                
                headBtn.hidden = YES;
                
            }
            
        }else {
            
            
            headBtn.hidden = YES;
        }
        
    }
    
    
}

#pragma mark - 6个人头像
- (void)setSixSubImageViewFrame:(NSArray *)images {
    
    CGFloat headerImageHW = (_AvatarViewWH - ImgMargin * 2 - MiddleMargin * 2) / 3.0;
    
    CGFloat originY = (_AvatarViewWH - (headerImageHW * 2 - MiddleMargin)) / 2.0;
    
    for (UIButton *headBtn in self.subviews) {
        
        NSInteger index = headBtn.tag - 100;
        headBtn.hidden = YES;
        if (index < images.count) {
            
            NSInteger row = index / 3;
            
            NSInteger col = index % 3;
            
            headBtn.width = headerImageHW;
            
            headBtn.height = headerImageHW;
            
            headBtn.x = (headerImageHW + MiddleMargin) * col + ImgMargin;
            
            headBtn.y = (headerImageHW + MiddleMargin) * row + originY;
            
            [self loadHeadImageViewStr:images[index] headBtn:headBtn headImages:images];
            
            headBtn.hidden = NO;
        }else {
            
            
            headBtn.hidden = YES;
        }
        
    }
    
}

#pragma mark - 7个人头像
- (void)setSevenSubImageViewFrame:(NSArray *)images {
    
    //    NSInteger headCount = images.count;
    //
    //    CGFloat headerImageHW = (AvatarViewW - ImgMargin * 4) / 3.0;
    
    NSMutableArray *muImages = images.mutableCopy;
    
    [muImages insertObject:@"" atIndex:0];
    
    [muImages insertObject:@"" atIndex:2];
    
    [self imageCountLoadHeaderImageView:muImages];
}

- (void)imageCountLoadHeaderImageView:(NSArray *)images {
    
    CGFloat headerImageHW = (_AvatarViewWH - ImgMargin * 2 - MiddleMargin * 2) / 3.0;
    
    for (UIButton *headBtn in self.subviews) {
        headBtn.hidden = YES;
        if (headBtn.tag >= 100) {
            
            NSInteger index = headBtn.tag - 100;
            
            NSString *imageStr = images[index];
            
            NSInteger row = index / 3;
            
            NSInteger col = index % 3;
            
            headBtn.tag = 100 + index;
            
            headBtn.x = (headerImageHW + MiddleMargin) * col + ImgMargin;
            
            headBtn.y = (headerImageHW + MiddleMargin) * row + ImgMargin;
            
            headBtn.width = headerImageHW;
            
            headBtn.height = headerImageHW;
            
            if (![NSString isEmpty:imageStr]) {
                
                [self loadHeadImageViewStr:images[index] headBtn:headBtn headImages:images];
                
                headBtn.hidden = NO;
                
            }else {
                
                headBtn.hidden = YES;
                
            }
            
            
        }
        
    }
    
}

- (void)setEightSubImageViewFrame:(NSArray *)images {
    
    NSMutableArray *muImages = images.mutableCopy;
    
    [muImages insertObject:@"" atIndex:0];
    
    CGFloat headerImageHW = (_AvatarViewWH - ImgMargin * 2 - MiddleMargin * 2) / 3.0;
    
    for (UIButton *headBtn in self.subviews) {
        
        headBtn.hidden = YES;
        
        if (headBtn.tag >= 100) {
            
            NSInteger index = headBtn.tag - 100;
            
            NSString *imageStr = muImages[index];
            
            NSInteger row = index / 3;
            
            NSInteger col = index % 3;
            
            headBtn.tag = 100 + index;
            
            if (row == 0 && index > 0) {
                
                headBtn.x = (headerImageHW + MiddleMargin) * col + ImgMargin - headerImageHW / 2.0;
                
                headBtn.y = (headerImageHW + MiddleMargin) * row + ImgMargin;
                
            }else {
                
                headBtn.x = (headerImageHW + MiddleMargin) * col + ImgMargin;
                
                headBtn.y = (headerImageHW + MiddleMargin) * row + ImgMargin;
                
            }
            
            headBtn.width = headerImageHW;
            
            headBtn.height = headerImageHW;
            
            if (![NSString isEmpty:imageStr]) {
                
                [self loadHeadImageViewStr:muImages[index] headBtn:headBtn headImages:images];
                
                headBtn.hidden = NO;
                
            }else {
                
                headBtn.hidden = YES;
                
            }
            
            
        }
        
    }
    
    
}

#pragma mark - 加载头像

- (void)loadHeadImageViewStr:(NSString *)headStr headBtn:(UIButton *)headBtn headImages:(NSArray *)headImages {
    
    NSString *nameStr = @"";
    
    NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl_center_image,headStr?:@""]];
    
    if (![NSString isEmpty:headStr]) {
        
        [headBtn setBackgroundImage:nil forState:UIControlStateNormal];
        
        [headBtn setTitle:nil forState:UIControlStateNormal];
        
        nameStr = [headStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        nameStr = [self getUrlWithStr:nameStr];
    }
    
    //有名字就显示
    if (![NSString isEmpty:nameStr]) {
        
        [self setHeadInfoWithNameStr:nameStr headBtn:headBtn headImages:headImages];
        
        return;
    }
    
    [headBtn sd_setBackgroundImageWithURL:headUrl forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (error && ![NSString isEmpty:headStr]) {
            
            NSString *nameStr = [headStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            if (nameStr.length > 0 && ![NSString isEmpty:headStr]) {
                
                nameStr = [self getUrlWithStr:nameStr];
                
                if ([NSString isEmpty:nameStr]) {
                    
                    return ;
                }
                
                [headBtn setBackgroundImage:nil forState:UIControlStateNormal];
                
                NSString *lastname = [nameStr substringWithRange:NSMakeRange(nameStr.length - 1, 1)];
                
                UIColor *nameBackColor = [NSString modelBackGroundColor:lastname];
                
                headBtn.backgroundColor = nameBackColor;
                
                [headBtn setTitle:lastname forState:UIControlStateNormal];
                
                CGFloat fontSize = AppFont24Size;
                
                if (headImages.count == 1) {
                    
                    fontSize = AppFont38Size;
                    
                }else if (headImages.count > 2 && headImages.count <= 4 ) {
                    
                    fontSize = AppFont24Size;
                }else if (headImages.count > 5) {
                    
                    fontSize = AppFont20Size;
                }else {
                    
                    fontSize = AppFont24Size;
                }
                
                headBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize * _fontSizeRatio];
            }
            
        }
        
    }];
    
}

- (NSString *)getUrlWithStr:(NSString *)headStr {
    
    NSRange range = [headStr rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        
        NSString *urlStr = [headStr substringFromIndex:range.location + 1];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"=" withString:@":"];
        NSArray *qrCodes = [urlStr componentsSeparatedByString:@"&"];
        NSMutableDictionary *headInfoDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < qrCodes.count; i ++) {
            NSString *valueStr = qrCodes[i];
            NSString *keyStr = [valueStr substringToIndex:[valueStr rangeOfString:@":"].location];
            NSString *value = [valueStr substringFromIndex:[valueStr rangeOfString:@":"].location + 1];
            [headInfoDic setObject:value forKey:keyStr];
        }
        
        BOOL isShowLastName = [headStr containsString:@"headpic_m"] || [headStr containsString:@"headpic_f"] || [headStr containsString:@"nopic"] || [headStr containsString:@"default"];
        
        NSString *realName = [headInfoDic objectForKey:@"real_name"];
        
        if (!isShowLastName) {
            
            realName = @"";
        }
        
        return realName;
    }
    
    return nil;
}

#pragma mark - 设置头像
- (void)setHeadInfoWithNameStr:(NSString *)nameStr headBtn:(UIButton *)headBtn headImages:(NSArray *)headImages {
    
    if (![NSString isEmpty:nameStr]) {
        
        [headBtn setBackgroundImage:nil forState:UIControlStateNormal];
        
        NSString *lastname = [nameStr substringWithRange:NSMakeRange(nameStr.length - 1, 1)];
        
        if (![NSString isEmpty:nameStr] && nameStr.length >= 2  && headImages.count == 1) {
            
            lastname = [nameStr substringWithRange:NSMakeRange(nameStr.length - 2, 2)];
        }
        
        UIColor *nameBackColor = [NSString modelBackGroundColor:lastname];
        
        headBtn.backgroundColor = nameBackColor;
        
        [headBtn setTitle:lastname forState:UIControlStateNormal];
        
        CGFloat fontSize = AppFont24Size;
        
        if (headImages.count == 1) {
            
            fontSize = AppFont38Size;
            
        }else if (headImages.count > 2 && headImages.count <= 4 ) {
            
            fontSize = AppFont24Size;
            
        }else if (headImages.count > 5) {
            
            fontSize = AppFont20Size;
        }else {
            
            fontSize = AppFont24Size;
        }
        
        headBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize * _fontSizeRatio];
    }
}

//- (UIView *)flagView {
//
//    if (!_flagView) {
//
//        _flagView = [[UIView alloc] initWithFrame:CGRectMake(_AvatarViewWH - 4, 0, MsgCountViewWH, MsgCountViewWH)];
//
//        _flagView.backgroundColor = AppFontFF0000Color;
//
//        [_flagView.layer setLayerCornerRadius:MsgCountViewWH / 2.0];
//
//        _flagView.hidden = YES;
//
//        [self.superview addSubview:_flagView];
//    }
//
//    return _flagView;
//}

@end
