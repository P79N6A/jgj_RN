//
//  JGJNotePadOneDaylistMarkImportView.m
//  mix
//
//  Created by Tony on 2019/1/10.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJNotePadOneDaylistMarkImportView.h"
#import "JGJCustomPopView.h"
@interface JGJNotePadOneDaylistMarkImportView ()

@property (nonatomic, strong) UIImageView *markImportImage;
@property (nonatomic, strong) UILabel *tipeLabel;
@property (nonatomic, strong) UIButton *markImportBtn;
@end
@implementation JGJNotePadOneDaylistMarkImportView

- (instancetype)init
{
    self = [super init];
    if (self) {
     
        self.backgroundColor = AppFontfafafaColor;
        [self initializeAppearance];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.backgroundColor = AppFontfafafaColor;
    [self initializeAppearance];
}

- (void)initializeAppearance {
    
    [self addSubview:self.markImportImage];
    [self addSubview:self.tipeLabel];
    [self addSubview:self.markImportBtn];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    [_markImportImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_offset(0);
        make.width.height.mas_equalTo(22);
        make.left.mas_offset(10);
    }];
    
    [_tipeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_markImportImage.mas_right).offset(10);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    [_markImportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_markImportImage.mas_left).offset(0);
        make.centerY.mas_equalTo(0);
        make.right.equalTo(_tipeLabel.mas_right).offset(0);
        make.height.mas_equalTo(22);
    }];
    
}

- (void)setIs_import:(BOOL)is_import {
    
    _is_import = is_import;
    if (_is_import) {
        
        _markImportImage.image = IMAGE(@"listImportStar");
        _tipeLabel.text = @"重要";
        _tipeLabel.textColor = AppFontFF6600Color;
        
    }else {
        
        _markImportImage.image = IMAGE(@"listEmptyStar");
        _tipeLabel.text = @"标记为重要";
        _tipeLabel.textColor = AppFont333333Color;
    }
}

- (void)markNoteImport {
    
    if (_markImport) {
        
        TYWeakSelf(self);
        if (self.is_import) {
            
            JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
            
            desModel.popDetail = @"该记事本内容是标记为重要的，确认要取消标记为重要吗？";
            
            desModel.rightTilte = @"确认";
            
            desModel.leftTilte = @"取消";
            
            desModel.popTextAlignment = NSTextAlignmentLeft;
            
            JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
            
            alertView.messageLable.textAlignment = NSTextAlignmentLeft;
            
            alertView.onOkBlock = ^{
                
                weakself.markImport(weakself.is_import);
            };
        }else {
            
            _markImport(self.is_import);
        }
        
        
        
        
    }
    
}

- (UIImageView *)markImportImage {
    
    if (!_markImportImage) {
        
        _markImportImage = [[UIImageView alloc] init];
        _markImportImage.image = IMAGE(@"listEmptyStar");
    }
    return _markImportImage;
}

- (UILabel *)tipeLabel {
    
    if (!_tipeLabel) {
        
        _tipeLabel = [[UILabel alloc] init];
        _tipeLabel.text = @"标记为重要";
        _tipeLabel.textColor = AppFont333333Color;
        _tipeLabel.font = FONT(15);
    }
    return _tipeLabel;
}

- (UIButton *)markImportBtn {
    
    if (!_markImportBtn) {
        
        _markImportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_markImportBtn addTarget:self action:@selector(markNoteImport) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _markImportBtn;
}

@end
