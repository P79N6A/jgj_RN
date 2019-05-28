//
//  JGJCusCheckView.m
//  mix
//
//  Created by YJ on 2019/1/6.
//  Copyright © 2019年 JiZhi. All rights reserved.
//

#import "JGJCusCheckView.h"

#import "UIButton+WebCache.h"

@interface JGJCusCheckView()

@property (nonatomic, strong) JGJCusCheckButton *imageBtn;

@property (nonatomic, strong) JGJCusCheckButton *delBtn;

@property (nonatomic, strong) UIImageView *addImageView;

@property (nonatomic, strong) UILabel *des;

@end

@implementation JGJCusCheckView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setSubUI];
        
    }
    
    return self;
}

- (void)setSubUI {
    
    CGFloat imageWH = 40;
    
    JGJCusCheckButton *imageBtn = [[JGJCusCheckButton alloc] initWithFrame:self.bounds];
    
    self.imageBtn = imageBtn;
    
    self.imageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.imageBtn.imageView.clipsToBounds = YES;
    
    [imageBtn addTarget:self action:@selector(checkBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    imageBtn.backgroundColor = AppFontfafafaColor;
    
    [self addSubview:imageBtn];
    
    JGJCusCheckButton *delBtn = [[JGJCusCheckButton alloc] initWithFrame:CGRectMake(imageBtn.width - imageWH / 2.0 - 3, -6, imageWH, imageWH)];
    
    delBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    self.delBtn = delBtn;
    
    [delBtn addTarget:self action:@selector(delBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [delBtn setImage:[UIImage imageNamed:@"findHelper_deletePhone"] forState:UIControlStateNormal];
    
    [self addSubview:delBtn];
    
    self.backgroundColor = AppFontE6E6E6Color;
    
    UIImageView *addImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"startWork_BaskSkill"]];
    
    self.addImageView = addImageView;
    
    CGSize size = addImageView.image.size;
    
    addImageView.x = (imageBtn.width - size.width) / 2.0;
    
    addImageView.y = imageBtn.centerY - 20;
    
    addImageView.width = size.width;
    
    addImageView.height = size.height;
    
    [self addSubview:addImageView];
    
    UILabel *des = [[UILabel alloc] initWithFrame:CGRectMake(0, addImageView.y + 30, imageBtn.width, 20)];
    
    self.des = des;
    
    des.textAlignment = NSTextAlignmentCenter;
    
    des.text = @"添加图片";
    
    des.textColor = AppFont666666Color;
    
    des.font = [UIFont systemFontOfSize:AppFont24Size];
    
    [self addSubview:des];
    
}

- (void)setImages:(NSArray *)images {
    
    _images = images;
    
    self.delBtn.hidden = NO;
    
    self.addImageView.hidden = YES;
    
    self.des.hidden = YES;
    
    for (NSInteger indx = 0; indx < images.count; indx++) {
        
        if ([images.firstObject isKindOfClass:[UIImage class]]) {
            
            UIImage *image = images.firstObject;
            
            [self.imageBtn setImage:image forState:UIControlStateNormal];
            
        }else if ([images.firstObject isKindOfClass:[NSString class]]) {
            
            NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",JLGHttpRequest_UpLoadPicUrl_center_image,images.firstObject?:@""]];
            
            [self.imageBtn sd_setImageWithURL:headUrl forState:UIControlStateNormal];
            
        }else {
            
            self.delBtn.hidden = YES;

            self.addImageView.hidden = NO;

            self.des.hidden = NO;
        }
        
    }
    
    if (!images) {
        
        self.delBtn.hidden = YES;

        self.addImageView.hidden = NO;

        self.des.hidden = NO;
    }
}


- (void)checkBtnPressed:(JGJCusCheckButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cusCheckView:checkBtnPressed:)]) {
        
        [self.delegate cusCheckView:self checkBtnPressed:sender];
    }
}

- (void)delBtnPressed:(JGJCusCheckButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(cusCheckView:delBtnPressed:)]) {
        
        [self.delegate cusCheckView:self delBtnPressed:sender];
    }
    
}

@end
