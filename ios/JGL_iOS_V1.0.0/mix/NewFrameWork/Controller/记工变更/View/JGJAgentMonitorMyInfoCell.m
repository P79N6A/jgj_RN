//
//  JGJAgentMonitorMyInfoCell.m
//  mix
//
//  Created by Tony on 2018/8/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAgentMonitorMyInfoCell.h"
#import "JGJWorkpointsChangeListCellTypeView.h"

#define leftContatin 11
#define topContatin 53
#define rightContatin -74
#define bottomContatin -24
@interface JGJAgentMonitorMyInfoCell ()

@property (nonatomic, strong) JGJWorkpointsChangeListCellTypeView *changeInfoView;// 更改信息

@end
@implementation JGJAgentMonitorMyInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = AppFontf1f1f1Color;
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self.contentView addSubview:self.myBubbleView];
    [self.contentView addSubview:self.newlyIncreasedView];
    [self.contentView addSubview:self.changeInfoView];
    [self setUpLayout];
    
}

- (void)setUpLayout {
    
    [_myBubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [_newlyIncreasedView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(leftContatin);
        make.top.mas_equalTo(topContatin);
        make.right.mas_equalTo(rightContatin);
        make.bottom.mas_equalTo(bottomContatin);
    }];
    
    [_changeInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(leftContatin);
        make.top.mas_equalTo(topContatin);
        make.right.mas_equalTo(rightContatin);
        make.bottom.mas_equalTo(bottomContatin);
    }];
    
}

- (void)setChangeInfoModel:(JGJRecordWorkpointsChangeModel *)changeInfoModel {
    
    _changeInfoModel = changeInfoModel;
    
    _myBubbleView.changeInfoModel = _changeInfoModel;
    _myBubbleView.indexPath = _indexPath;
    if ([_changeInfoModel.record_type integerValue] == 1) {// 新增
        
        self.newlyIncreasedView.hidden = NO;
        self.changeInfoView.hidden = YES;
        self.newlyIncreasedView.changeInfoModel = _changeInfoModel;
        
    }else { // 修改或删除
        
        self.changeInfoView.hidden = NO;
        self.newlyIncreasedView.hidden = YES;
        self.changeInfoView.selTypeModel = self.selTypeModel;
        self.changeInfoView.changeInfoModel = _changeInfoModel;
    }
}

- (JGJRecordChangeListMyBubbleView *)myBubbleView {
    
    if (!_myBubbleView) {
        
        _myBubbleView = [[JGJRecordChangeListMyBubbleView alloc] init];
    }
    return _myBubbleView;
}

- (JGJRecordWorkpointsChangeNewlyIncreasedView *)newlyIncreasedView {
    
    if (!_newlyIncreasedView) {
        
        _newlyIncreasedView = [[JGJRecordWorkpointsChangeNewlyIncreasedView alloc] init];
    }
    return _newlyIncreasedView;
}

- (JGJWorkpointsChangeListCellTypeView *)changeInfoView {
    
    if (!_changeInfoView) {
        
        _changeInfoView = [[JGJWorkpointsChangeListCellTypeView alloc] init];
    }
    return _changeInfoView;
}

@end
