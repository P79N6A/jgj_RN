//
//  JGJHomeMaskView.m
//  mix
//
//  Created by yj on 2018/11/26.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJHomeMaskView.h"

#import "UIImage+Cut.h"

#import "UIView+GNUtil.h"

@implementation JGJHomeMaskImageModel


@end

@interface JGJHomeMaskView()

@property (nonatomic, assign) NSInteger count;

@end

@implementation JGJHomeMaskView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.74];
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        self.frame = window.bounds;
        
        [window addSubview:self];
        
    }
    
    return self;
    
}

-(void)cutViewFrame:(CGRect)oriRect convertView:(UIView *)convertView {
        
    NSMutableArray *shotScreens = [NSMutableArray array];
    
//    cutView.x = TYGetUIScreenWidth - cutView.size.width - 10;
//
//    CGRect coverRect = [convertView convertRect:cutView.frame toView:convertView];
    
    CGFloat padding = 10;
//
//    CGFloat shotW = 212 + padding;
//
//    CGFloat shotH = 112 + padding;
//
//    CGFloat x = 155 - padding;
//
//    CGFloat y = 155 + padding;
    
    CGRect rect = oriRect;
    
    UIImage *image = [UIImage viewHightSnapshot:convertView withInRect:rect];
    
    JGJHomeMaskImageModel *firImageModel = [[JGJHomeMaskImageModel alloc] init];
    
    firImageModel.image = image;
    
    firImageModel.rect = rect;
    
    firImageModel.radius = 3;
    
    [shotScreens addObject:firImageModel];
    
    //记账引导
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [self addSubview:imageView];
    
    imageView.frame = firImageModel.rect;
    
    imageView.image = firImageModel.image;
    
    imageView.contentMode = UIViewContentModeCenter;
    
    if (![NSString isFloatZero:firImageModel.radius]) {
        
        [imageView.layer setLayerCornerRadius:firImageModel.radius];
    }
    
    UIImageView *accountArrowImageView = [[UIImageView alloc] init];
    
    [self addSubview:accountArrowImageView];
    
    UIImage *accountArrowImage = [UIImage imageNamed:@"home_account_arrow"];
    
    accountArrowImageView.frame = CGRectMake(imageView.x - 3 * padding, TYGetMaxY(imageView) + 2 * padding, imageView.width, accountArrowImage.size.height);
    
    accountArrowImageView.image = accountArrowImage;
    
    accountArrowImageView.contentMode = UIViewContentModeCenter;
    
    
    UIImageView *accountDesImageView = [[UIImageView alloc] init];
    
    [self addSubview:accountDesImageView];
    
    UIImage *accountDesImageViewImage = [UIImage imageNamed:@"home_account_des"];
    
    accountDesImageView.frame = CGRectMake(imageView.x, TYGetMaxY(accountArrowImageView)  + 2 * padding, accountDesImageViewImage.size.width, accountDesImageViewImage.size.height);
    
    accountDesImageView.image = accountDesImageViewImage;
    
    accountDesImageView.contentMode = UIViewContentModeCenter;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    for (UIView *subView in self.subviews) {
        
        [subView removeFromSuperview];
    }
    
    ++self.count;
        
    if (self.clickBlock) {
        
        self.clickBlock(self.count);
    }
    
//    if (self.count == 2) {
//
//        [self removeFromSuperview];
//
//    }
    
    [self removeFromSuperview];
    
}


#pragma mark - 设置第二步引导

-(void)setSecGuideView:(UIView *)cutView convertView:(UIView *)convertView {
    
    NSMutableArray *shotScreens = [NSMutableArray array];
    
    cutView.x = TYGetUIScreenWidth - cutView.size.width - 10;
    
    CGRect coverRect = [convertView convertRect:cutView.frame toView:convertView];
    
    CGFloat padding = 10;
    
    CGFloat shotW = TYGetViewW(convertView) / 5.0;
    
    CGFloat shotH = 48;
    
    CGFloat x = (convertView.width - shotW) / 2;
    
    CGFloat y = TYGetMaxY(convertView) - shotH - JGJ_IphoneX_BarHeight;
    
    CGRect rect = CGRectMake(x + padding, y, shotW - 20, shotH);
    
    UIImage *image = [UIImage viewHightSnapshot:convertView withInRect:rect];
    
    JGJHomeMaskImageModel *firImageModel = [[JGJHomeMaskImageModel alloc] init];
    
    firImageModel.image = image;
    
    firImageModel.rect = rect;
    
    firImageModel.radius = 3;
    
    [shotScreens addObject:firImageModel];
    
    //   找工作引导
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [self addSubview:imageView];
    
    imageView.frame = firImageModel.rect;    
//    imageView.image = firImageModel.image;
    imageView.image = IMAGE(@"findJob_maskingLogo");
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (![NSString isFloatZero:firImageModel.radius]) {
        
        [imageView.layer setLayerCornerRadius:firImageModel.radius];
    }
    
    UIImageView *accountArrowImageView = [[UIImageView alloc] init];
    
    [self addSubview:accountArrowImageView];
    
    UIImage *accountArrowImage = [UIImage imageNamed:@"home_find_work_arrow"];
    
    accountArrowImageView.frame = CGRectMake(imageView.x + (imageView.width) / 2.0, TYGetMinY(imageView) - 3 * padding - shotH, accountArrowImage.size.width, accountArrowImage.size.height);
    
    accountArrowImageView.image = accountArrowImage;
    
    accountArrowImageView.contentMode = UIViewContentModeCenter;
    
    //找工作描述
    UIImageView *accountDesImageView = [[UIImageView alloc] init];
    
    [self addSubview:accountDesImageView];
    
    UIImage *accountDesImage = [UIImage imageNamed:@"home_find_work_des"];
    
    accountDesImageView.frame = CGRectMake(accountArrowImageView.x - (accountDesImage.size.width) / 2.0, TYGetMinY(accountArrowImageView) - 3 * padding, accountDesImage.size.width, accountDesImage.size.height);
    
    accountDesImageView.image = accountDesImage;
    
    accountDesImageView.contentMode = UIViewContentModeCenter;
    
    [self.window addSubview:self];
}

#pragma mark - 设置第二步引导

-(void)setThirGuideView:(UIView *)cutView convertView:(UIView *)convertView {
    
    NSMutableArray *shotScreens = [NSMutableArray array];
    
    cutView.x = TYGetUIScreenWidth - cutView.size.width - 10;
    
    CGRect coverRect = [convertView convertRect:cutView.frame toView:convertView];
    
    CGFloat padding = 10;
    
    CGFloat shotW = TYGetViewW(convertView) / 5.0;
    
    CGFloat shotH = 48;
    
    CGFloat x = (convertView.width - shotW) / 2 + shotW;
    
    CGFloat y = TYGetMaxY(convertView) - shotH - JGJ_IphoneX_BarHeight;
    
    CGRect rect = CGRectMake(x + padding, y, shotW - 20, shotH);
    
    UIImage *image = [UIImage viewHightSnapshot:convertView withInRect:rect];
    
    JGJHomeMaskImageModel *firImageModel = [[JGJHomeMaskImageModel alloc] init];
    
    firImageModel.image = image;
    
    firImageModel.rect = rect;
    
    firImageModel.radius = 3;
    
    [shotScreens addObject:firImageModel];
    
    //  发现引导
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [self addSubview:imageView];
    
    imageView.frame = firImageModel.rect;
    
    imageView.image = firImageModel.image;
    
    imageView.contentMode = UIViewContentModeCenter;
    
    if (![NSString isFloatZero:firImageModel.radius]) {
        
        [imageView.layer setLayerCornerRadius:firImageModel.radius];
    }
    
    UIImageView *findArrowImageView = [[UIImageView alloc] init];
    
    [self addSubview:findArrowImageView];
    
    UIImage *accountArrowImage = [UIImage imageNamed:@"home_friend_arrow"];
    
    findArrowImageView.frame = CGRectMake(imageView.x - accountArrowImage.size.width, TYGetMinY(imageView) - 3 * padding - shotH, accountArrowImage.size.width, accountArrowImage.size.height);
    
    findArrowImageView.image = accountArrowImage;
    
    findArrowImageView.contentMode = UIViewContentModeCenter;
    
    //发现描述
    
    UIImageView *findDesImageView = [[UIImageView alloc] init];
    
    [self addSubview:findDesImageView];
    
    UIImage *accountDesImage = [UIImage imageNamed:@"home_friend_des"];
    
    findDesImageView.frame = CGRectMake(findArrowImageView.x - (accountDesImage.size.width / 2.0), TYGetMinY(findArrowImageView) - 3 * padding, accountDesImage.size.width, accountDesImage.size.height);
    
    findDesImageView.image = accountDesImage;
    
    findDesImageView.contentMode = UIViewContentModeCenter;
    
    [self.window addSubview:self];
}

@end
