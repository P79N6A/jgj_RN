//
//  JGJHomePageMaskingView.m
//  JGJCompany
//
//  Created by Tony on 2018/7/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJHomePageMaskingView.h"

#define ButtonTop TYIST_IPHONE_X ? 25 : 13
@interface JGJHomePageMaskingView ()

@property (nonatomic, strong) UIButton *addImageView;

@property (nonatomic, strong) UIView *createNewProjectView;// 创建新项目父view
@property (nonatomic, strong) UIImageView *nProjectArrows;
@property (nonatomic, strong) UIImageView *nProjectTitle;
@property (nonatomic, strong) UIButton *iKnownBtn1;

@property (nonatomic, strong) UIView *myDefaultProjectView;// 系统为我创建的xxx项目
@property (nonatomic, strong) UIImageView *defaultImageView;
@property (nonatomic, strong) UIImageView *defaultProjectArrows;
@property (nonatomic, strong) UIImageView *defaultProjectTitle;
@property (nonatomic, strong) UIButton *iKnownBtn2;

@end
@implementation JGJHomePageMaskingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initializeAppearance];
        self.backgroundColor = [AppFont000000Color colorWithAlphaComponent:0.6];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.addImageView];
    [self addSubview:self.createNewProjectView];
    [self.createNewProjectView addSubview:self.nProjectArrows];
    [self.createNewProjectView addSubview:self.nProjectTitle];
    [self.createNewProjectView addSubview:self.iKnownBtn1];
    
    [self addSubview:self.myDefaultProjectView];
    [self.myDefaultProjectView addSubview:self.defaultImageView];
    [self.myDefaultProjectView addSubview:self.defaultProjectArrows];
    [self.myDefaultProjectView addSubview:self.defaultProjectTitle];
    [self.myDefaultProjectView addSubview:self.iKnownBtn2];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    CGFloat roatio = TYGetUIScreenWidth / 320;
    _addImageView.sd_layout.leftSpaceToView(self, TYGetUIScreenWidth - 54).topSpaceToView(self, ButtonTop).widthIs(49).heightIs(45);
    
    _createNewProjectView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(_addImageView, 0).rightSpaceToView(self, 0).heightIs(145 * roatio);
    _nProjectArrows.sd_layout.rightSpaceToView(_createNewProjectView, 15).topSpaceToView(_createNewProjectView, 0).widthIs(55 * roatio).heightIs(60 * roatio);
    _nProjectTitle.sd_layout.rightEqualToView(_nProjectArrows).topSpaceToView(_nProjectArrows, 5).widthIs(183 * roatio).heightIs(17 * roatio);
    _iKnownBtn1.sd_layout.centerXEqualToView(_nProjectTitle).topSpaceToView(_nProjectTitle, 25).widthIs(116 * roatio).heightIs(38 * roatio);
    [_iKnownBtn1 updateLayout];
    _iKnownBtn1.layer.cornerRadius = 5;
    
    _myDefaultProjectView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 160).rightSpaceToView(self, 0).heightIs(290);
    _defaultImageView.sd_layout.leftSpaceToView(_myDefaultProjectView, 0).topSpaceToView(_myDefaultProjectView, 0).widthIs(220).heightIs(60);
    _defaultProjectArrows.sd_layout.topSpaceToView(_defaultImageView, 6).leftSpaceToView(_myDefaultProjectView, 100).widthIs(48 * roatio).heightIs(78 * roatio);
    _defaultProjectTitle.sd_layout.leftSpaceToView(_myDefaultProjectView, 17).topSpaceToView(_defaultProjectArrows, 8).widthIs(240 * roatio).heightIs(40 * roatio);
    _iKnownBtn2.sd_layout.centerXEqualToView(_defaultProjectTitle).topSpaceToView(_defaultProjectTitle, 25).widthIs(116 * roatio).heightIs(38 * roatio);
    [_iKnownBtn2 updateLayout];
    _iKnownBtn2.layer.cornerRadius = 5;
    
    _defaultImageView.clipsToBounds = YES;
    _defaultImageView.layer.cornerRadius = 30.0;
}

- (void)setTopConstrain:(CGFloat)topConstrain {
    
    _topConstrain = topConstrain;
}


- (void)setCutImage:(UIImage *)cutImage isCreateDefault:(BOOL)isDefault {
    
    _defaultImageView.image = cutImage;
    if (!isDefault) {
        
        _myDefaultProjectView.hidden = YES;
        _createNewProjectView.hidden = NO;
        
    }else {
        
        _myDefaultProjectView.hidden = NO;
        _createNewProjectView.hidden = YES;
    }
}

- (void)iKnownBtn2Click {
    
    _myDefaultProjectView.hidden = YES;
    _createNewProjectView.hidden = NO;
}

- (void)iKnownBtn1Click {
    
    [self removeFromSuperview];
}

- (UIButton *)addImageView {
    
    if (!_addImageView) {
        
        _addImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addImageView setImage:IMAGE(@"more_type_sel_icon") forState:(UIControlStateNormal)];
        _addImageView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _addImageView;
}

- (UIView *)createNewProjectView {
    
    if (!_createNewProjectView) {
        
        _createNewProjectView = [[UIView alloc] init];
        _createNewProjectView.hidden = YES;
    }
    return _createNewProjectView;
}

- (UIImageView *)nProjectArrows {
    
    if (!_nProjectArrows) {
        
        _nProjectArrows = [[UIImageView alloc] init];
        _nProjectArrows.image = IMAGE(@"箭头");
    }
    return _nProjectArrows;
}

- (UIImageView *)nProjectTitle {
    
    if (!_nProjectTitle) {
        
        _nProjectTitle = [[UIImageView alloc] init];
        _nProjectTitle.image = IMAGE(@"点击这里可创建新项目");
    }
    return _nProjectTitle;
}

- (UIButton *)iKnownBtn1 {
    
    if (!_iKnownBtn1) {
        
        _iKnownBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iKnownBtn1 setTitle:@"我知道了" forState:(UIControlStateNormal)];
        [_iKnownBtn1 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _iKnownBtn1.titleLabel.font = FONT(AppFont32Size);
        _iKnownBtn1.layer.borderColor = AppFontffffffColor.CGColor;
        _iKnownBtn1.layer.borderWidth = 1;
        [_iKnownBtn1 addTarget:self action:@selector(iKnownBtn1Click) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _iKnownBtn1;
}

- (UIView *)myDefaultProjectView {
    
    if (!_myDefaultProjectView) {
        
        _myDefaultProjectView = [[UIView alloc] init];
        _myDefaultProjectView.hidden = YES;
    }
    return _myDefaultProjectView;
}

- (UIImageView *)defaultImageView {
    
    if (!_defaultImageView) {
        
        _defaultImageView = [[UIImageView alloc] init];
    }
    return _defaultImageView;
}

- (UIImageView *)defaultProjectArrows {
    
    if (!_defaultProjectArrows) {
        
        _defaultProjectArrows = [[UIImageView alloc] init];
        _defaultProjectArrows.image = IMAGE(@"箭头拷贝");
    }
    return _defaultProjectArrows;
}

- (UIImageView *)defaultProjectTitle {
    
    if (!_defaultProjectTitle) {
        
        _defaultProjectTitle = [[UIImageView alloc] init];
        _defaultProjectTitle.image = IMAGE(@"这是系统为您创建的项目，您可以在该项目中修改项目名称");
    }
    return _defaultProjectTitle;
}

- (UIButton *)iKnownBtn2 {
    
    if (!_iKnownBtn2) {
        
        _iKnownBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iKnownBtn2 setTitle:@"我知道了" forState:(UIControlStateNormal)];
        [_iKnownBtn2 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _iKnownBtn2.titleLabel.font = FONT(AppFont32Size);
        _iKnownBtn2.layer.borderColor = AppFontffffffColor.CGColor;
        _iKnownBtn2.layer.borderWidth = 1;
        [_iKnownBtn2 addTarget:self action:@selector(iKnownBtn2Click) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _iKnownBtn2;
}
@end
