//
//  JGJRecordWorkpointsChangeNewlyIncreasedView.m
//  mix
//
//  Created by Tony on 2018/8/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordWorkpointsChangeNewlyIncreasedView.h"
#import "JGJChangeNewlyIncreasedListCell.h"
@interface JGJRecordWorkpointsChangeNewlyIncreasedView ()<UITableViewDelegate,UITableViewDataSource>
{
    
    JGJChangeNewlyIncreasedListCell *_cell;
}

@property (nonatomic, strong) UITableView *listTB;
@end
@implementation JGJRecordWorkpointsChangeNewlyIncreasedView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.listTB];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    [_listTB mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}

- (void)setChangeInfoModel:(JGJRecordWorkpointsChangeModel *)changeInfoModel {
    
    _changeInfoModel = changeInfoModel;
    [self.listTB reloadData];
    
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _changeInfoModel.add_info.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _cell = [JGJChangeNewlyIncreasedListCell cellWithTableViewNotXib:tableView];
    if (indexPath.row == _changeInfoModel.add_info.count - 1) {
        
        _cell.hiddenLine = YES;
    }else {
        
        _cell.hiddenLine = NO;
    }
    _cell.addInfoModel = _changeInfoModel.add_info[indexPath.row];
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJAdd_infoChangeModel *addInfoModel = _changeInfoModel.add_info[indexPath.row];
    if (self.newlyIncreasedDelegate && [self.newlyIncreasedDelegate respondsToSelector:@selector(didSelectedNewlyIncreasedCellWithIndexPath: addInfoModel:)]) {
        
        [self.newlyIncreasedDelegate didSelectedNewlyIncreasedCellWithIndexPath:indexPath addInfoModel:addInfoModel];
    }
}

- (UITableView *)listTB {

    if (!_listTB) {

        _listTB = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _listTB.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTB.tableFooterView = [[UIView alloc] init];
        _listTB.delegate = self;
        _listTB.dataSource = self;
        _listTB.rowHeight = 55;
        _listTB.scrollEnabled = NO;
    }
    return _listTB;
}
@end
