//
//  JGJNotepadListEmptyView.m
//  mix
//
//  Created by Tony on 2018/4/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJNotepadListEmptyView.h"
#import "NSString+Extend.h"
@interface JGJNotepadListEmptyView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JGJNotepadListEmptyView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    self.backgroundColor = AppFontffffffColor;
    [self addSubview:self.imageView];
    [self addSubview:self.recordLabel];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    [_recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self).offset(-30);
        make.height.mas_equalTo(20);
    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.bottom.equalTo(self.recordLabel.mas_top).offset(-30);
        make.centerX.equalTo(self.mas_centerX);
        
    }];
}

- (void)setEmptyImage:(NSString *)imageStr emptyText:(NSString *)emptyText {
    
    self.imageView.image = IMAGE(imageStr);
    self.recordLabel.text = emptyText;
    
    CGSize size = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 20, CGFLOAT_MAX) content:emptyText font:self.recordLabel.font.pointSize];
    [self.recordLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(size.height);
    }];
    
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeBottom;
        _imageView.image = IMAGE(@"notepad_quesheng");
    }
    return _imageView;
}

- (UILabel *)recordLabel {
    
    if (!_recordLabel) {
        
        _recordLabel = [[UILabel alloc] init];
        _recordLabel.textAlignment = NSTextAlignmentCenter;
        _recordLabel.text = @"从今天开始记录你的生活吧...";
        _recordLabel.font = FONT(18);
        _recordLabel.numberOfLines = 0;
    }
    return _recordLabel;
}
@end
