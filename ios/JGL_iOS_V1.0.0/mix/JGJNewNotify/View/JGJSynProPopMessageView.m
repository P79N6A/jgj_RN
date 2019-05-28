//
//  JGJSynProPopMessageView.m
//  mix
//
//  Created by yj on 16/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSynProPopMessageView.h"
#import "JGJSynProPopMessageCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

#define HeaderH 59
@interface JGJSynProPopMessageView () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containDetailView;

@end

@implementation JGJSynProPopMessageView

- (instancetype)initWithFrame:(CGRect)frame mergecheckModels:(NSArray *)mergecheckModels {
    
    if (self = [super initWithFrame:frame]) {
        [self commonSet];
        self.mergecheckModels = mergecheckModels;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self commonSet];
    }
    return self;
}

- (void)setMergecheckModels:(NSArray *)mergecheckModels {
    _mergecheckModels = mergecheckModels;
    [self.tableView reloadData];
}

#pragma Mark - 常用设置

- (void)commonSet {
    [[[NSBundle mainBundle] loadNibNamed:@"JGJSynProPopMessageView" owner:self options:nil] lastObject];
    self.containView.frame = self.bounds;
    self.containView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.containDetailView.layer setLayerCornerRadius:5.0];
    [self addSubview:self.containView];
    [self.tableView registerNib:[UINib nibWithNibName:@"JGJSynProPopMessageCell" bundle:nil] forCellReuseIdentifier:@"JGJSynProPopMessageCell"];
}

#pragma Mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"JGJSynProPopMessageCell" configuration:^(JGJSynProPopMessageCell *cell) {
        cell.mergecheckModel = self.mergecheckModels[indexPath.row];
    }];
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mergecheckModels.count;
}

#pragma Mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJSynProPopMessageCell *proPopMessageCell = [tableView dequeueReusableCellWithIdentifier:@"JGJSynProPopMessageCell" forIndexPath:indexPath];
    proPopMessageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    proPopMessageCell.mergecheckModel = self.mergecheckModels[indexPath.row];
    return proPopMessageCell;
}

#pragma mark - 取消按钮按下
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self removeFromSuperview];
}

#pragma mark - 确认按钮按下
- (IBAction)confirmSynButtonPressed:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.messageViewBlock) {
        self.messageViewBlock();
    }
}

@end
