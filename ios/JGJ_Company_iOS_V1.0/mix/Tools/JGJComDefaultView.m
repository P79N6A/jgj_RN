//
//  JGJComDefaultView.m
//  mix
//
//  Created by yj on 2018/4/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJComDefaultView.h"

#import "YYText.h"

@implementation JGJComDefaultViewModel

@end

@interface JGJComDefaultView ()

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (weak, nonatomic) IBOutlet YYLabel *desLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desCenterY;

@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;

@end

@implementation JGJComDefaultView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
        
    }
    
    return self;
    
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJComDefaultView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
        
    [self.actionButton.layer setLayerCornerRadius:JGJCornerRadius];
    
    self.actionButton.backgroundColor = AppFontEB4E4EColor;
    
    self.desLable.textColor = AppFontB9B9B9Color;
    

}

- (void)setDefaultViewModel:(JGJComDefaultViewModel *)defaultViewModel {
    
    _defaultViewModel = defaultViewModel;
    
    NSMutableAttributedString *synWorkAccountDes = [[NSMutableAttributedString alloc] initWithString:defaultViewModel.des?:@""];
    
    synWorkAccountDes.yy_lineSpacing = defaultViewModel.lineSpace;
    
    synWorkAccountDes.yy_alignment = NSTextAlignmentCenter;
    
    self.desLable.attributedText = synWorkAccountDes;
    
    if (![NSString isEmpty:defaultViewModel.buttonTitle]) {
        
        [self.actionButton setTitle:defaultViewModel.buttonTitle forState:UIControlStateNormal];
    }
    
    if (defaultViewModel.offsetCenterY > 0) {
        
        self.desCenterY.constant -= defaultViewModel.offsetCenterY;
    }
    
    if (![NSString isEmpty:defaultViewModel.defaultImageStr]) {
        
        self.defaultImageView.image = [UIImage imageNamed:defaultViewModel.defaultImageStr];
    }
    
    self.actionButton.hidden = defaultViewModel.isHiddenButton;
        
}

- (IBAction)actionButtonPressed:(UIButton *)sender {
    
    if (self.comDefaultViewBlock) {
        
        self.comDefaultViewBlock();
    }
    
}


@end
