//
//  JGJSplitProHeaderView.m
//  JGJCompany
//
//  Created by yj on 16/9/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJShareProHeaderView.h"
#import "UIButton+JGJUIButton.h"

@interface JGJShareProHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *desButton;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) JGJShareProDesModel *shareProDesModel;
@end
@implementation JGJShareProHeaderView

- (instancetype)initWithFrame:(CGRect)frame shareProDesModel:(JGJShareProDesModel *)shareProDesModel
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        self.shareProDesModel = shareProDesModel;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView{
    self.backgroundColor = AppFontf1f1f1Color;
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    [self.desButton setEnlargeEdgeWithTop:20.0 right:10.0 bottom:10.0 left:50.0];
    
    [self.desButton setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
}

- (void)setShareProDesModel:(JGJShareProDesModel *)shareProDesModel {
    _shareProDesModel = shareProDesModel;
    self.titleLable.text = shareProDesModel.title;
    [self.desButton setTitle:shareProDesModel.desTitle forState:UIControlStateNormal];
}

- (IBAction)handleDesButtonPressed:(UIButton *)sender {
    if (self.shareProHeaderViewBlock) {
        self.shareProHeaderViewBlock(self.shareProDesModel);
    }
}
@end
