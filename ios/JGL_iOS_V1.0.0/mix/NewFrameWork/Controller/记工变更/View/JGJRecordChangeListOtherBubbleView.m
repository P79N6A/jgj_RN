//
//  JGJRecordChangeListOtherBubbleView.m
//  mix
//
//  Created by Tony on 2018/8/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordChangeListOtherBubbleView.h"
#import "UIButton+JGJUIButton.h"
#import "NSString+Extend.h"
@interface JGJRecordChangeListOtherBubbleView ()

@property (nonatomic, strong) UIImageView *userImageView;// 头像
@property (nonatomic, strong) UIButton *headPic;
@property (nonatomic, strong) UILabel *userName;// 名字
@property (nonatomic, strong) UIImageView *bubbleContainer;// 气泡

@property (nonatomic, strong) UIImageView *timeImage;
@property (nonatomic, strong) UILabel *timeLabel;// 时间
@property (nonatomic, strong) UILabel *typeLabel;// 类型

@end
@implementation JGJRecordChangeListOtherBubbleView

- (instancetype)init
{
    self = [super init];
    if (self) {
     
        self.backgroundColor = AppFontf1f1f1Color;
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.userImageView];
    [self.userImageView addSubview:self.headPic];
    [self addSubview:self.userName];
    [self addSubview:self.bubbleContainer];
    [self.bubbleContainer addSubview:self.timeImage];
    [self.bubbleContainer addSubview:self.timeLabel];
    [self.bubbleContainer addSubview:self.typeLabel];
    
    [self setUpLayout];
}

- (void)setUpLayout {
    
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
        make.width.height.mas_equalTo(40);
    }];
    
    [_headPic mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_userImageView.mas_right).offset(10);
        make.top.equalTo(_userImageView).offset(0);
        make.height.mas_equalTo(15);
    }];
    
    [_bubbleContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(64);
        make.top.equalTo(_userName.mas_bottom).offset(5);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-14);
        
    }];
    
    [_timeImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(12);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_timeImage.mas_right).offset(5);
        make.centerY.equalTo(_timeImage.mas_centerY).offset(0);
        make.height.mas_equalTo(15);
    }];
    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(_timeLabel.mas_centerY).offset(0);
        make.left.equalTo(_timeLabel.mas_right).offset(10);
        make.height.mas_equalTo(15);
    }];
}


- (void)setChangeInfoModel:(JGJRecordWorkpointsChangeModel *)changeInfoModel {
    
    _changeInfoModel = changeInfoModel;
    
    // 头像
    UIColor *backGroundColor = [NSString modelBackGroundColor:changeInfoModel.user_info.full_name];
    [self.headPic setMemberPicButtonWithHeadPicStr:changeInfoModel.user_info.head_pic memberName:changeInfoModel.user_info.real_name memberPicBackColor:backGroundColor];
    self.headPic.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
    
    // 姓名
    if ([changeInfoModel.role integerValue] == 2) {// 班组长
        
        _userName.text = [NSString stringWithFormat:@"班组长(%@)",changeInfoModel.user_info.real_name];
        
    }else if ([changeInfoModel.role integerValue] == 3) {// 代班长
        
        _userName.text = [NSString stringWithFormat:@"代班长(%@)",changeInfoModel.user_info.real_name];
    }
    
    // 时间
    _timeLabel.text = _changeInfoModel.create_time;
    
    // 类型
    _typeLabel.text = changeInfoModel.typeTitle;
    if ([_changeInfoModel.record_type integerValue] == 1) {// 新增
        
        _timeLabel.textColor = AppFont1892E7Color;
        _typeLabel.textColor = AppFont1892E7Color;
        
    }else if ([_changeInfoModel.record_type integerValue] == 2) {// 修改
        
        _timeLabel.textColor = AppFont27B441Color;
        _typeLabel.textColor = AppFont27B441Color;
        
    }else if ([_changeInfoModel.record_type integerValue] == 3) {// 删除
        
        _timeLabel.textColor = AppFontEB4E4EColor;
        _typeLabel.textColor = AppFontEB4E4EColor;
    }
}

- (void)interceptTouch {
    
    NSLog(@"拦截点击事件");
    
    if (self.headerPickClick) {
        
        _headerPickClick(_indexPath);
    }
}

#pragma mark - property
- (UIImageView *)userImageView {
    
    if (!_userImageView) {
        
        _userImageView = [[UIImageView alloc] init];
        _userImageView.userInteractionEnabled = YES;
    }
    return _userImageView;
}
- (UIButton *)headPic {
    
    if (!_headPic) {
        
        _headPic = [UIButton new];
        [_headPic addTarget:self action:@selector(interceptTouch) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _headPic;
}
- (UILabel *)userName {
    
    if (!_userName) {
        
        _userName = [[UILabel alloc] init];
        _userName.textColor = AppFont333333Color;
        _userName.font = FONT(AppFont32Size);
    }
    return _userName;
}

- (UIImageView *)bubbleContainer {
    
    if (!_bubbleContainer) {
        
        _bubbleContainer = [[UIImageView alloc] init];
        UIImage *outImage = [UIImage imageNamed:@"Chat_listWhitePOP"];
        _bubbleContainer.image = [outImage resizableImageWithCapInsets:UIEdgeInsetsMake(outImage.size.height - 13 , outImage.size.width / 2, 9.6, outImage.size.width / 2 - 5) resizingMode:UIImageResizingModeStretch];
    }
    return _bubbleContainer;
}

- (UIImageView *)timeImage {
    
    if (!_timeImage) {
        
        _timeImage = [[UIImageView alloc] init];
        _timeImage.image = IMAGE(@"RCListTime");
    }
    return _timeImage;
}
- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = AppFont333333Color;
        _timeLabel.font = [UIFont boldSystemFontOfSize:AppFont24Size];
    }
    return _timeLabel;
}

- (UILabel *)typeLabel {
    
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont boldSystemFontOfSize:AppFont26Size];
    }
    return _typeLabel;
}
@end
