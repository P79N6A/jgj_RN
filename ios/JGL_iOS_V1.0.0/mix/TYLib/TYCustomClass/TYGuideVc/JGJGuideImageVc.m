//
//  JGJGuideImageVc.m
//  JGJCompany
//
//  Created by Tony on 2016/10/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJGuideImageVc.h"
#import "Masonry.h"
#import "UITableView+TYSeparatorLine.h"


@interface JGJGuideImageVc ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong) UIImageView *guideImageView;

@property (nonatomic,assign) CGFloat cellHeight;
@end

@implementation JGJGuideImageVc

- (instancetype)initWithImageType:(GuideImageType )guideImageType{
    self = [super init];
    if (self) {
        switch (guideImageType) {
            case GuideImageTypeRecord:{
                //                //报表中的用工数据从哪里来
                self.guideImageView.image = [UIImage imageNamed:@"guideVc_recordDataWhereFrom"];
                self.title = @"记工统计数据从哪里来";
                break;
            }
            case GuideImageTypeBill:{
                //记工统计数据从哪里来
                self.guideImageView.image = [UIImage imageNamed:@"guideVc_billDataWhereFrom"];
                self.title = @"报表中的用工数据从哪里来";
                break;
            }
            case GuideImageTypeSysManage:{
                //什么是同步管理
                self.guideImageView.image = [UIImage imageNamed:@"guideVc_whatIsSysManage"];
                self.title = @"什么是同步管理";
            }
                break;
            default:
                break;
        }
    }
    
    self.cellHeight = ceil(TYGetUIScreenWidth*self.guideImageView.image.size.height/self.guideImageView.image.size.width);
    
    [self.tableview reloadData];
    return self;
}

- (void)setIsShowBottomButton:(BOOL)isShowBottomButton {
    _isShowBottomButton = isShowBottomButton;
    
    //没有数据点击底部报表看示例数据
    
    if (_isShowBottomButton) {
        [self handleAddFooterView];
    }
}

- (void)handleAddFooterView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 65.0)];
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableview.tableFooterView = footerView;
    UIButton *checkRecordButton = [UIButton new];
    [checkRecordButton.layer setLayerBorderWithColor:AppFontd7252cColor width:1.0 radius:JGJCornerRadius];
    [checkRecordButton addTarget:self action:@selector(handleCheckRecordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkRecordButton setTitle:@"查看示例报表" forState:UIControlStateNormal];
    [checkRecordButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
    checkRecordButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    [footerView addSubview:checkRecordButton];
    [checkRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(35.0));
        make.width.equalTo(@(150));
        make.centerX.equalTo(footerView.mas_centerX);
        make.centerY.equalTo(footerView.mas_centerY);
    }];
}

#pragma mark - 查看实力数据
- (void)handleCheckRecordButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(guideImageVcWithguideImageVc:didSelectedFooterView:)]) {
        [self.delegate guideImageVcWithguideImageVc:self didSelectedFooterView:sender];
    }
}


#pragma mark - 代理
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *guideImageStrID = @"JGJGuideImageVcCell";
    
    UITableViewCell *guideImageCell = [tableView dequeueReusableCellWithIdentifier:guideImageStrID];
    
    //缓存池中无数据
    if(guideImageCell == nil){
        guideImageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:guideImageStrID];
        
        guideImageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGRect cellFrame = CGRectMake(0, 0, TYGetUIScreenWidth, self.cellHeight);
        self.guideImageView.frame = cellFrame;
        [guideImageCell addSubview:self.guideImageView];
    }
    
    return guideImageCell;
}

- (UIImageView *)guideImageView
{
    if (!_guideImageView) {
        _guideImageView = [[UIImageView alloc] init];
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return _guideImageView;
}

- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] init];
        _tableview.delegate =self;
        _tableview.dataSource =self;
        [UITableView hiddenExtraCellLine:_tableview];
        
        [self.view addSubview:_tableview];
        
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.view);
        }];
    }
    return _tableview;
}

@end
