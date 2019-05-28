//
//  JGJCustomDefaultView.m
//  mix
//
//  Created by yj on 2018/6/11.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCustomDefaultView.h"

#import "UILabel+GNUtil.h"

@implementation JGJCustomDefaultViewModel

@end

@interface JGJCustomDefaultView ()

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonCenterX;

@property (weak, nonatomic) IBOutlet UILabel *desLable;

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftRightCenterX;

@end

@implementation JGJCustomDefaultView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    
    return self;
}

- (void)commonSet {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    [self.leftButton.layer setLayerBorderWithColor:AppFontEB4E4EColor width:0.5 radius:JGJCornerRadius];
    
    [self.rightButton.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.leftButton.backgroundColor = [UIColor whiteColor];
    
    [self.leftButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.desLable.font = [UIFont systemFontOfSize:AppFont32Size];
    
    self.desLable.textColor = AppFont333333Color;

}

- (void)setDesModel:(JGJCustomDefaultViewModel *)desModel {
    
    _desModel = desModel;
    
    if (![NSString isEmpty:desModel.imageStr]) {
        
        self.flagImageView.image = [UIImage imageNamed:desModel.imageStr];
    }
    
    self.rightButtonCenterX.constant = 77.5;
    
    self.rightButton.hidden = NO;
    
    self.leftRightCenterX.constant = -77.5;
    
    self.leftButton.hidden = NO;
    
    if (desModel.isOnlyShowRight && !desModel.isOnlyShowLeft) {
        
        self.rightButtonCenterX.constant = 0;
        
        self.leftButton.hidden = YES;
        
        self.rightButton.hidden = NO;
        
    }else if (!desModel.isOnlyShowRight && desModel.isOnlyShowLeft) {
        
        self.leftRightCenterX.constant = 0;
        
        self.leftButton.hidden = NO;
        
        self.rightButton.hidden = YES;
        
    }else if (desModel.isOnlyShowRight && desModel.isOnlyShowLeft) {
        
        self.rightButtonCenterX.constant = 77.5;
        
        self.rightButton.hidden = NO;
        
        self.leftRightCenterX.constant = -77.5;
        
        self.leftButton.hidden = NO;
        
    }else if (!desModel.isOnlyShowRight && !desModel.isOnlyShowLeft) {
        
        self.rightButton.hidden = YES;
        
        self.leftButton.hidden = YES;
        
    }
    
    self.desLable.text = desModel.des;
    
    if (![NSString isEmpty:desModel.changeColorDes]) {
        
        [self.desLable markText:desModel.changeColorDes withFont:[UIFont boldSystemFontOfSize:AppFont40Size] color:AppFontEB4E4EColor];
    }
    
    [self.leftButton setTitle:desModel.leftButtonTitle forState:UIControlStateNormal];
    
    [self.rightButton setTitle:desModel.rightButtonTitle forState:UIControlStateNormal];
}

- (IBAction)leftButtonAction:(UIButton *)sender {
    
    if (self.leftBtnActionBlock) {
        
        self.leftBtnActionBlock();
    }
}


- (IBAction)rightButtonAction:(UIButton *)sender {
    
    if (self.rightBtnActionBlock) {
        
        self.rightBtnActionBlock();
    }
}


@end
