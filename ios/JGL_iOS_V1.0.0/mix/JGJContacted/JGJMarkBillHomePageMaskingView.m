//
//  JGJMarkBillHomePageMaskingView.m
//  mix
//
//  Created by Tony on 2018/6/22.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMarkBillHomePageMaskingView.h"
#import "SJButton.h"
@interface JGJMarkBillHomePageMaskingView ()

@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UIImageView *jiantouImageView;
@property (nonatomic, strong) SJButton *runningWaterBtn;

@end
@implementation JGJMarkBillHomePageMaskingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initializeAppearance];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.74];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.backImage];
    [self addSubview:self.jiantouImageView];
    [self addSubview:self.runningWaterBtn];
    [self setUpLayout];
    
    [_runningWaterBtn updateLayout];
}

- (void)setUpLayout {
    
    CGFloat ratio = TYGetUIScreenWidth / 375.0;
    
    CGFloat btnY = TYGetUIScreenWidth + 80 + JGJ_NAV_HEIGHT + (JGJ_IphoneX_Or_Later ? 44 : 0) + (JGJ_IphoneX_Or_Later ? 15 : 0);
    CGFloat runningBtnHeight = JGJ_IphoneX_Or_Later ? TYGetUIScreenWidth / 3 - 1 : TYGetUIScreenHeight - btnY - 64;
    _runningWaterBtn.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, btnY).widthIs(TYGetUIScreenWidth / 3).heightIs(runningBtnHeight);
    _jiantouImageView.sd_layout.leftSpaceToView(self, 45 * ratio).bottomSpaceToView(_runningWaterBtn, 5).widthIs(55 * ratio).heightIs(130 * ratio);
    
    UIImage *image = IMAGE(@"markBillbg");
    _backImage.sd_layout.centerXEqualToView(self).bottomSpaceToView(_jiantouImageView, 15).widthIs(image.size.width).heightIs(image.size.height);
    
}

- (void)setRunningWaterBtnY:(CGFloat)runningWaterBtnY {
    
    _runningWaterBtnY = runningWaterBtnY;
    _runningWaterBtn.sd_layout.topSpaceToView(self, _runningWaterBtnY + 25 + (JGJ_IphoneX_Or_Later ? 44 : 0));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (_maskingTouch) {
    
        _maskingTouch();
    }
    
}

- (UIImageView *)backImage {
    
    if (!_backImage) {
        
        _backImage = [[UIImageView alloc] init];
        _backImage.image = IMAGE(@"markBillbg");
    }
    return _backImage;
}

- (UIImageView *)jiantouImageView {
    
    if (!_jiantouImageView) {
        
        _jiantouImageView = [[UIImageView alloc] init];
        _jiantouImageView.image = IMAGE(@"markBilljiantou");
    }
    return _jiantouImageView;
}

- (SJButton *)runningWaterBtn {
    
    if (!_runningWaterBtn) {
        
        _runningWaterBtn = [SJButton buttonWithType:SJButtonTypeVerticalImageTitle];
        [_runningWaterBtn setBackgroundColor:[UIColor whiteColor]];
        [_runningWaterBtn setTitle:@"记工流水" forState:SJControlStateNormal];
        [_runningWaterBtn setImage:IMAGE(@"markBillWater") forState:SJControlStateNormal];
        [_runningWaterBtn setTitleColor:AppFont333333Color forState:SJControlStateNormal];
        [_runningWaterBtn setBackgroundColor:[UIColor whiteColor] forState:SJControlStateHighlighted];
        _runningWaterBtn.titleLabel.font = FONT(AppFont30Size);
    }
    return _runningWaterBtn;
}
@end
