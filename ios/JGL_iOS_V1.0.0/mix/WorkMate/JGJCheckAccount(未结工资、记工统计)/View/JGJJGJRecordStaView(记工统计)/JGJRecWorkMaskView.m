//
//  JGJRecWorkMaskView.m
//  mix
//
//  Created by yj on 2018/9/7.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecWorkMaskView.h"

#import "UIImage+Cut.h"

@implementation JGJMaskImageModel

@end

@interface JGJRecWorkMaskView ()

@property (nonatomic, assign) NSInteger count;

@end

@implementation JGJRecWorkMaskView

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


- (void)setSubViews:(NSArray *)images {
    
    for (JGJMaskImageModel *imageModel in images) {
        
        if (imageModel.is_cusview) {
            
            UIButton *actionButton = [[UIButton alloc] init];
            
            actionButton.frame = imageModel.rect;
            
            [actionButton setTitle:@"我知道了" forState:UIControlStateNormal];
            
            [actionButton setTitleColor:AppFontffffffColor forState:UIControlStateNormal];
            
            [actionButton.layer setLayerBorderWithColor:AppFontffffffColor width:1 radius:5];
            
            [actionButton addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            actionButton.tag = imageModel.buttonTag;
            
            [self addSubview:actionButton];
            
        }else {
            
            UIImageView *imageView = [[UIImageView alloc] init];
            
            [self addSubview:imageView];
            
            imageView.frame = imageModel.rect;
            
            imageView.image = imageModel.image;
            
            imageView.contentMode = UIViewContentModeCenter;
            
            if (![NSString isFloatZero:imageModel.radius]) {
                
                [imageView.layer setLayerCornerRadius:imageModel.radius];
            }
        }
        
    }
    
}

- (void)cutView:(UIView *)cutView convertView:(UIView *)convertView {
    
    NSMutableArray *shotScreens = [NSMutableArray array];
    
    cutView.x = TYGetUIScreenWidth - cutView.size.width - 10;
    
    CGRect coverRect = [convertView convertRect:cutView.frame toView:convertView];
    
    CGFloat shotW = coverRect.size.width;
    
    CGFloat shotH = coverRect.size.height;
    
    CGFloat x = coverRect.origin.x;
    
    CGFloat y = coverRect.origin.y;
    
    CGRect rect = CGRectMake(coverRect.origin.x, coverRect.origin.y, shotW, shotH);
    
    UIImage *image = [UIImage viewHightSnapshot:convertView withInRect:rect];
    
    JGJMaskImageModel *firImageModel = [[JGJMaskImageModel alloc] init];
    
    firImageModel.image = image;
    
    rect = CGRectMake(x, y + JGJ_NAV_HEIGHT , shotW, shotH);
    
    firImageModel.rect = rect;
    
    firImageModel.radius = 3;
    
    [shotScreens addObject:firImageModel];
    
    [self lastMaskImageModelsWithRect:rect shotScreens:shotScreens idex:0];
    
}

- (void)lastMaskImageModelsWithRect:(CGRect)rect shotScreens:(NSMutableArray *)shotScreens idex:(NSInteger)index{
    
    CGFloat padding = 10;
    
    JGJMaskImageModel *secImageModel = [[JGJMaskImageModel alloc] init];
    
    secImageModel.image = [UIImage imageNamed:@"workpoint_shot_arrow_icon"];
    
    CGRect secRect = CGRectMake(TYGetUIScreenWidth - secImageModel.image.size.width - rect.size.width / 2.0, CGRectGetMaxY(rect) + padding, secImageModel.image.size.width, secImageModel.image.size.height);
    
    secImageModel.rect = secRect;
    
    [shotScreens addObject:secImageModel];
    
    JGJMaskImageModel *thirImageModel = [[JGJMaskImageModel alloc] init];
    
    thirImageModel.image = [UIImage imageNamed:@"workpoint_shot_tips_icon"];
    
    if (index == 1) {
        
        thirImageModel.image = [UIImage imageNamed:@"mask_more_des_icon"];
    }
    
    CGRect thirRect = CGRectMake((TYGetUIScreenWidth - thirImageModel.image.size.width) / 2.0, CGRectGetMaxY(secRect) + padding * 2, thirImageModel.image.size.width, thirImageModel.image.size.height);
    
    thirImageModel.rect = thirRect;
    
    [shotScreens addObject:thirImageModel];
    
    JGJMaskImageModel *fourImageModel = [[JGJMaskImageModel alloc] init];
    
//    fourImageModel.is_cusview = YES;
    
    fourImageModel.buttonTag = index;
    
    CGFloat btnW = 110;
    
    CGFloat btnH = 35;
    
    CGRect fourRect = CGRectMake((TYGetUIScreenWidth - btnW) / 2.0, CGRectGetMaxY(thirRect) - 25 - btnH, btnW, btnH);
    
    fourImageModel.rect = fourRect;
    
    [shotScreens addObject:fourImageModel];
    
    self.imageModels = shotScreens;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self actionButtonPressed:nil];
    
     ++self.count;
    
}

- (void)actionButtonPressed:(UIButton *)sender {
    
    for (UIView *subView in self.subviews) {
        
        [subView removeFromSuperview];
    }
    
    if (self.count == 1) {
        
        [self removeFromSuperview];
        
        [TYUserDefaults setBool:YES forKey:JGJWorkPointMask];
        
    }else {
        
        NSMutableArray *shotScreens = [NSMutableArray array];
        
        UIImage *image = [UIImage imageNamed:@"more_red_text_icon"];
        
        JGJMaskImageModel *firImageModel = [[JGJMaskImageModel alloc] init];
        
        firImageModel.image = image;
        
        CGRect rect = CGRectMake(TYGetUIScreenWidth - image.size.width - 10, JGJ_StatusBar_Height + 10, image.size.width, image.size.height);
        
        firImageModel.rect = rect;
        
        [shotScreens addObject:firImageModel];
        
        [self lastMaskImageModelsWithRect:rect shotScreens:shotScreens idex:1];
        
        
    }
    
}

- (void)setImageModels:(NSArray *)imageModels {
    
    _imageModels = imageModels;
    
    [self setSubViews:imageModels];
}

@end
