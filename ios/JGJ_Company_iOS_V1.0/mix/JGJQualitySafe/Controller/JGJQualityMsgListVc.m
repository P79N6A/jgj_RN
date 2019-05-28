//
//  JGJQualityMsgListVc.m
//  JGJCompany
//
//  Created by yj on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityMsgListVc.h"

#import "JGJQualityMsgListCell.h"

#import "JGJQualityRecordVc.h"

@interface JGJQualityMsgListVc () <

    UITableViewDataSource,

    UITableViewDelegate
>

//@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *containSaveButtonView;

@property (nonatomic, strong) UIButton *publishButton;

@property (nonatomic, strong) JGJQualitySafeListRequestModel *requestModel;

@end

@implementation JGJQualityMsgListVc

//@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"质量";
    [self initialSubView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    JGJQualityMsgListCell *replyListCell = [JGJQualityMsgListCell cellWithTableView:tableView];
    
    
    return replyListCell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 260;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //用这两个模型 self.proListModel， taskModel
    
    TYLog(@"点击进质量详情页");
    
    
}

#pragma mark - 记录按钮按下
- (void)recordProblemBtnClick:(UIButton *)sender {

    JGJQualityRecordVc *qualityRecordVc = [JGJQualityRecordVc new];
    
    qualityRecordVc.proListModel = self.proListModel;
    
    [self.navigationController pushViewController:qualityRecordVc animated:YES];

}

//- (UITableView *)tableView {
//    
//    if (!_tableView) {
//        
//        _tableView = [[UITableView alloc] init];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//        _tableView.backgroundColor = AppFontf1f1f1Color;
//    }
//    
//    return _tableView;
//    
//}

- (void)initialSubView {
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.containSaveButtonView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.mas_equalTo(self.view);
        
        make.height.mas_equalTo(TYGetUIScreenHeight - 127);
    }];
    
}

- (UIView *)containSaveButtonView {
    if (!_containSaveButtonView) {
        _containSaveButtonView = [[UIView alloc] init];
        _containSaveButtonView.backgroundColor = AppFontfafafaColor;
        [self.view addSubview:_containSaveButtonView];
        [_containSaveButtonView addSubview:self.publishButton];
        [_containSaveButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@63);
            make.left.right.bottom.equalTo(self.view);
        }];
        UIView *lineViewTop = [[UIView alloc] init];
        lineViewTop.backgroundColor = AppFontdbdbdbColor;
        [_containSaveButtonView addSubview:lineViewTop];
        [lineViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.left.equalTo(_containSaveButtonView);
            make.height.equalTo(@1);
        }];
        UIView *lineViewBottom = [[UIView alloc] init];
        lineViewBottom.backgroundColor = AppFontdbdbdbColor;
        [_containSaveButtonView addSubview:lineViewBottom];
        [lineViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.left.equalTo(_containSaveButtonView);
            make.height.equalTo(@1);
        }];
    }
    return _containSaveButtonView;
}

- (UIButton *)publishButton
{
    if (!_publishButton) {
        //添加保存按钮
        _publishButton = [[UIButton alloc] init];
        [self.containSaveButtonView addSubview:_publishButton];
        _publishButton.backgroundColor = JGJMainColor;
        _publishButton.titleLabel.textColor = [UIColor whiteColor];
        [_publishButton setTitle:@"记录" forState:UIControlStateNormal];
        [_publishButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
        [_publishButton addTarget:self action:@selector(recordProblemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            
            make.right.mas_equalTo(-10);
            
            make.height.mas_equalTo(45);
            
            make.centerY.mas_equalTo(self.containSaveButtonView);
        }];
    }
    return _publishButton;
}

- (JGJQualitySafeListRequestModel *)requestModel {

    if (!_requestModel) {
        
        _requestModel = [JGJQualitySafeListRequestModel new];
    }
    
    return _requestModel;

}

@end
