//
//  JGJRecordWorkPointStaHeaderView.m
//  mix
//
//  Created by yj on 2018/12/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordWorkPointStaHeaderView.h"

#import "JGJCheckStaPopViewCell.h"

#import "SJButton.h"

#import "JGJCheckStaFooterView.h"

@interface JGJRecordWorkPointStaHeaderView()<UITableViewDelegate, UITableViewDataSource,JGJCheckStaFooterViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation JGJRecordWorkPointStaHeaderView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJRecordWorkPointStaHeaderView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    self.tableView.backgroundColor = AppFontf1f1f1Color;
}

- (void)setRecordWorkStaModel:(JGJRecordWorkStaModel *)recordWorkStaModel {
    
    _recordWorkStaModel = recordWorkStaModel;
    
    _dataSource = [recordWorkStaModel setStaPopViewCellModel];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCheckStaPopViewCell *cell = [JGJCheckStaPopViewCell cellWithTableView:tableView];
    
    cell.desInfoModel = _dataSource[indexPath.row];
    
    cell.dotLineView.hidden = NO || _dataSource.count - 1 == indexPath.row;
    
    cell.lineVIew.hidden = YES;
    
    CGFloat offset = TYGetUIScreenWidth >= 414 ? 10 : 0;
    
    cell.typeTitleTrail.constant = 0.18 * TYGetUIScreenWidth + offset;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJCheckStaPopViewCellModel *desInfoModel = _dataSource[indexPath.row];
    
    return (desInfoModel.otherType == 1 || desInfoModel.otherType == 2) ? 57 : 47;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = nil;
    
    if (_dataSource.count > 0 && !_is_hidden_checkBtn) {
        
        JGJCheckStaFooterView *checkMorefooterView = [[JGJCheckStaFooterView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 52)];
        
        checkMorefooterView.backgroundColor = AppFontf1f1f1Color;
        
        checkMorefooterView.delegate = self;
        
        footerView = checkMorefooterView;
    }
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return _dataSource.count > 0 && !_is_hidden_checkBtn ? 52 : 0;
}

- (void)checkStaFooterView:(JGJCheckStaFooterView *)footerView {
    
    if ([self.delegate respondsToSelector:@selector(recordWorkPointStaHeaderView:)]) {
        
        [self.delegate recordWorkPointStaHeaderView:self];
        
    }
}

@end
