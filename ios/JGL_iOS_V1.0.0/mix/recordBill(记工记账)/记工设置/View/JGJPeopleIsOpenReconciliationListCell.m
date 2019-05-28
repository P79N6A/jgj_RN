//
//  JGJPeopleIsOpenReconciliationListCell.m
//  mix
//
//  Created by Tony on 2019/2/18.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJPeopleIsOpenReconciliationListCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+JGJUIButton.h"
#import "UILabel+GNUtil.h"
@interface JGJPeopleIsOpenReconciliationListCell ()

@property (nonatomic, strong) UIButton *headPhoto;
@property (nonatomic, strong) UILabel *peopleName;
@property (nonatomic, strong) UILabel *telPhone;
@property (nonatomic, strong) UILabel *registerInfo;
@property (nonatomic, strong) UIButton *makeReconciliationBtn;
@property (nonatomic, strong) UILabel *makingACallLabel;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UILabel *noHaveTelPhoneLabel;

@property (nonatomic, strong) UIView *bottomLine;

@end
@implementation JGJPeopleIsOpenReconciliationListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = AppFontffffffColor;
        [self initializeAppearance];
    }
    return self;
}


- (void)initializeAppearance {
    
    [self.contentView addSubview:self.headPhoto];
    [self.contentView addSubview:self.peopleName];
    [self.contentView addSubview:self.telPhone];
    [self.contentView addSubview:self.registerInfo];
    [self.contentView addSubview:self.makeReconciliationBtn];
    [self.contentView addSubview:self.makingACallLabel];
    [self.contentView addSubview:self.rightImageView];
    [self.contentView addSubview:self.noHaveTelPhoneLabel];
    [self.contentView addSubview:self.bottomLine];
    [self setUpLayout];
    
    [_headPhoto updateLayout];
    _headPhoto.layer.cornerRadius = 5;
    _makeReconciliationBtn.layer.cornerRadius = 3;
}

- (void)setModel:(JGJSynBillingModel *)model {
    
    _model = model;
    
    [_headPhoto setMemberPicButtonWithHeadPicStr:_model.head_pic memberName:_model.real_name memberPicBackColor:_model.modelBackGroundColor membertelephone:_model.telephone];
    _peopleName.text = _model.real_name;
    _telPhone.text = _model.telephone;
    _registerInfo.text = _model.confirm_off_desc;
    
    // 表示有电话号码
    if (!_model.is_not_telph) {
        
        _registerInfo.hidden = NO;
        _noHaveTelPhoneLabel.hidden = YES;
        
        _telPhone.hidden = NO;
        [_peopleName mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_headPhoto.mas_top).offset(5);
        }];
        
        // 判断是否注册
        if ([_model.is_active isEqualToString:@"1"]) {// 表示已注册
            
            // 判断是否开启对账
            if (!_model.confirm_off) {// 表示开启
                
                _makeReconciliationBtn.hidden = NO;
                _makingACallLabel.hidden = YES;
                _rightImageView.hidden = YES;
                
                [_registerInfo mas_updateConstraints:^(MASConstraintMaker *make) {

                    make.top.mas_equalTo(12);
                }];
                
            }else {// 表示关闭
                
                _makeReconciliationBtn.hidden = YES;
                _makingACallLabel.hidden = NO;
                _rightImageView.hidden = NO;
                _makingACallLabel.text = @"拨打电话联系开启";
                
                [_registerInfo mas_updateConstraints:^(MASConstraintMaker *make) {

                    make.top.mas_equalTo(18);
                }];

                
            }
            
        }else {// 表示未注册
            
            _makeReconciliationBtn.hidden = YES;
            _makingACallLabel.hidden = NO;
            _rightImageView.hidden = NO;
            _makingACallLabel.text = @"邀请注册吉工家";
            
            [_registerInfo mas_updateConstraints:^(MASConstraintMaker *make) {

                make.top.mas_equalTo(18);
            }];

        }
        
    }else {
        
        _noHaveTelPhoneLabel.hidden = NO;
        
        [_peopleName mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(_headPhoto.mas_top).offset(45 / 2 - 6);
        }];
        
        _telPhone.hidden = YES;
        _registerInfo.hidden = YES;
        _makeReconciliationBtn.hidden = YES;
        _makingACallLabel.hidden = YES;
        _rightImageView.hidden = YES;
    }
}

- (void)setSearchValue:(NSString *)searchValue {
    
    _searchValue = searchValue;
    
    if ([NSString isEmpty:_searchValue]) {
        
        _peopleName.textColor = AppFont333333Color;
        _telPhone.textColor = AppFont666666Color;
        
    }else {
        
        [_peopleName markattributedTextArray:@[_searchValue] color:AppFontEB4E4EColor];
        [_telPhone markattributedTextArray:@[_searchValue] color:AppFontEB4E4EColor];
    }
    
}

- (void)makeReconciliationBtnClick {
    
    if (self.makeReconciliation) {
        
        _makeReconciliation(_model.uid);
    }
}

- (void)makeTelPhone {
    
    // 判断是否注册
    if ([_model.is_active isEqualToString:@"1"]) {// 表示已注册
        
        if (_model.confirm_off) {// 表示关闭
            
            if (self.makeTelPhoneOrShare) {
                
                _makeTelPhoneOrShare(YES,self.model.telph);
            }
        }
        
    }else {// 表示未注册
        
        if (self.makeTelPhoneOrShare) {
            
            _makeTelPhoneOrShare(NO,self.model.telph);
        }
    }
}

- (void)setUpLayout {
    
    [_headPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(11);
        make.top.mas_equalTo(16.5);
        make.bottom.mas_equalTo(-16.5);
        make.width.mas_equalTo(45);
    }];
    
    [_peopleName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_headPhoto.mas_right).offset(9);
        make.centerY.equalTo(_headPhoto.mas_centerY).offset(-11.5);
//        make.width.mas_equalTo(90);
        make.height.mas_equalTo(12);
    }];
    
    [_telPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_headPhoto.mas_right).offset(9);
        make.centerY.equalTo(_headPhoto.mas_centerY).offset(11.5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(12);
    }];
    
    [_registerInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(18);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(12);
    }];
    
    [_makeReconciliationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(_telPhone.mas_centerY).offset(0);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(28);
    }];
    
    [_makingACallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_rightImageView.mas_left).offset(-5);
        make.centerY.equalTo(_telPhone.mas_centerY).offset(0);
        make.left.equalTo(_telPhone.mas_right).offset(10);
        make.height.mas_equalTo(14);
    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(_makingACallLabel.mas_centerY).offset(0);
        make.bottom.mas_equalTo(-18);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(10);
    }];
    
    [_noHaveTelPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_offset(0);
        make.left.equalTo(_peopleName.mas_right).offset(10);
        make.right.mas_offset(-10);
        make.height.mas_equalTo(14);
        
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
}

- (UIButton *)headPhoto {
    
    if (!_headPhoto) {
        
        _headPhoto = [[UIButton alloc] init];
        _headPhoto.clipsToBounds = YES;
        _headPhoto.layer.cornerRadius = 5;
    }
    return _headPhoto;
}

- (UILabel *)peopleName {
    
    if (!_peopleName) {
        
        _peopleName = [[UILabel alloc] init];
        _peopleName.text = @"陈波";
        _peopleName.textColor = AppFont333333Color;
        _peopleName.font = FONT(AppFont28Size);
    }
    return _peopleName;
}

- (UILabel *)telPhone {
    
    if (!_telPhone) {
        
        _telPhone = [[UILabel alloc] init];
        _telPhone.textColor = AppFont666666Color;
        _telPhone.font = FONT(AppFont26Size);
        _telPhone.text = @"18328383345";
    }
    return _telPhone;
}

- (UILabel *)registerInfo {
    
    if (!_registerInfo) {
        
        _registerInfo = [[UILabel alloc] init];
        _registerInfo.textColor = AppFont999999Color;
        _registerInfo.font = FONT(AppFont24Size);
        _registerInfo.textAlignment = NSTextAlignmentRight;
    }
    return _registerInfo;
}

- (UIButton *)makeReconciliationBtn {
    
    if (!_makeReconciliationBtn) {
        
        _makeReconciliationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_makeReconciliationBtn setTitle:@"我要对账" forState:(UIControlStateNormal)];
        [_makeReconciliationBtn setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        _makeReconciliationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:AppFont28Size];
        _makeReconciliationBtn.layer.borderWidth = 1;
        _makeReconciliationBtn.layer.borderColor = AppFont999999Color.CGColor;
        _makeReconciliationBtn.clipsToBounds = YES;
        
        [_makeReconciliationBtn addTarget:self action:@selector(makeReconciliationBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _makeReconciliationBtn;
}

- (UILabel *)makingACallLabel {
    
    if (!_makingACallLabel) {
        
        _makingACallLabel = [[UILabel alloc] init];
        _makingACallLabel.textColor = AppFontEB4E4EColor;
        _makingACallLabel.font = FONT(AppFont28Size);
        _makingACallLabel.textAlignment = NSTextAlignmentRight;
        _makingACallLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeTelPhone)];
        
        [_makingACallLabel addGestureRecognizer:gesture];
    }
    return _makingACallLabel;
}

- (UIImageView *)rightImageView {
    
    if (!_rightImageView) {
        
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = IMAGE(@"red-arrows");
        _rightImageView.contentMode = UIViewContentModeRight;
    }
    return _rightImageView;
}

- (UILabel *)noHaveTelPhoneLabel {
    
    if (!_noHaveTelPhoneLabel) {
        
        _noHaveTelPhoneLabel = [[UILabel alloc] init];
        _noHaveTelPhoneLabel.textColor = AppFont999999Color;
        _noHaveTelPhoneLabel.font = FONT(AppFont24Size);
        _noHaveTelPhoneLabel.text = @"该对象无电话号码";
        _noHaveTelPhoneLabel.textAlignment = NSTextAlignmentRight;
        
    }
    return _noHaveTelPhoneLabel;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = AppFontEBEBEBColor;
    }
    return _bottomLine;
}
@end
