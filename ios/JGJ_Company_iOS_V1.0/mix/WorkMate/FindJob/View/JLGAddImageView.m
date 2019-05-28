//
//  JLGAddImageView.m
//  mix
//
//  Created by jizhi on 15/11/29.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGAddImageView.h"
#import "UIButton+WebCache.h"
@interface JLGAddImageView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@end
@implementation JLGAddImageView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.contentView];
}

//绘画
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.contentView.frame = self.bounds;
}

- (IBAction)addImageBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(addImageButtonIndex:)]) {
        [self.delegate addImageButtonIndex:self.tag];
    }
}

- (void)setAddImage:(UIImage *)addImage{
    _addImage = addImage;
    [self.addImageButton setBackgroundImage:addImage forState:UIControlStateNormal];
}
@end
