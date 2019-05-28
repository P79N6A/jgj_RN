//
//  JGJMakeAccountChoiceSubentryTemplateController.m
//  mix
//
//  Created by Tony on 2019/2/14.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMakeAccountChoiceSubentryTemplateController.h"
#import "TYTextField.h"
#import "JGJSubentryListCell.h"
#import "FDAlertView.h"
@interface JGJMakeAccountChoiceSubentryTemplateController ()<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate,FDAlertViewDelegate>
{
    
    JGJSubentryListCell *_cell;
    
    JGJSubentryListCell *_deleteCell;
}
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) LengthLimitTextField *subentryInput;
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UITableView *subentryList;
@property (nonatomic, strong) NSMutableArray *subentryListArray;
@end

@implementation JGJMakeAccountChoiceSubentryTemplateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择分项模板";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initializeAppearance];
    [self loadSubentryListData];
}

- (void)loadSubentryListData {
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [TYLoadingHub hideLoadingView];
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-contractor-tpl-list" parameters:nil success:^(id responseObject) {
    
        [TYLoadingHub hideLoadingView];
        self.subentryListArray = [JGJSubentryListModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.subentryList reloadData];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.topLabel];
    [self.view addSubview:self.subentryInput];
    [self.view addSubview:self.sureBtn];
    [self.view addSubview:self.subentryList];
    [self setUpLayout];
    
    [_sureBtn updateLayout];
    [_subentryInput updateLayout];
    
    _sureBtn.layer.cornerRadius = 5;
    _subentryInput.layer.cornerRadius = 5;
}

- (void)setUpLayout {
    
    CGSize topLabelSize = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 15) content:@"添加分项名称" font:15];
    
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(topLabelSize.width + 1);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(36);
        make.top.equalTo(_topLabel.mas_bottom).offset(12);
    }];
    
    [_subentryInput mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(10);
        make.top.equalTo(_topLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(36);
        make.right.equalTo(_sureBtn.mas_left).offset(-10);
    }];
    
    [_subentryList mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-JGJ_IphoneX_BarHeight);
        make.top.equalTo(_subentryInput.mas_bottom).offset(13);
    }];
}


- (void)sureInputSubentry {
    
    if (self.sureSubenTryInput) {
        
        _sureSubenTryInput(self.cellTag,_subentryInput.text);
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.subentryListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _cell = [JGJSubentryListCell cellWithTableViewNotXib:tableView];
    _cell.rightUtilityButtons = [self rightButtons];
    _cell.model = self.subentryListArray[indexPath.row];
    _cell.delegate = self;
    if (indexPath.row == self.subentryListArray.count - 1) {
        
        _cell.line.hidden = YES;
        
    }else {
        
        _cell.line.hidden = NO;
    }
    return _cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.subentryListArray.count == 0) {
        
        return nil;
        
    }else {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 38)];
        view.backgroundColor = AppFontEBEBEBColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 200, 14)];
        label.textColor = AppFont000000Color;
        label.font = FONT(AppFont30Size);
        label.text = @"点击选择分项模板:";
        
        [view addSubview:label];
        
        
        return view;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.subentryListArray.count == 0) {
        
        return 0.01;
    }else {
        
        return 38;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJSubentryListModel *model = self.subentryListArray[indexPath.row];
    if (self.selectedSubentryModel) {
        
        _selectedSubentryModel(self.cellTag,model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSArray *)rightButtons {
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     AppFontEA4E3DColor title:@"删除"];
    return rightUtilityButtons;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    
    return YES;
}

#pragma mark - 设置滑动的偏移量
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x > [cell rightUtilityButtonsWidth]) {
        
        scrollView.contentOffset = CGPointMake([cell rightUtilityButtonsWidth], 0);
    }
}

- (void)swipeableTableViewCell:(JGJSubentryListCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
            
        case 0:{
            
            _deleteCell = cell;
            FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"确定删除该分项模板吗？" delegate:self buttonTitles:@"取消",@"确定", nil];
            alert.isHiddenDeleteBtn = YES;
            [alert setMessageColor:AppFont000000Color fontSize:16];
            
            [alert show];
        }
                        
            break;
            
        default:
            break;
    }
    
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1 ) {
        
        //删除分项模板
        [TYLoadingHub showLoadingWithMessage:nil];
        NSDictionary *dic;
        if (self.isAgentMonitor) {
            
            dic = @{@"tpl_id":_deleteCell.model.tpl_id,
                    @"group_id":self.workProListModel.group_id
                    };
        }else {
            
            dic = @{@"tpl_id":_deleteCell.model.tpl_id};
        }
        [JLGHttpRequest_AFN PostWithNapi:@"workday/del-contractor-tpl" parameters:dic success:^(id responseObject) {
            
            [self.subentryListArray removeObject:_deleteCell.model];
            [self.subentryList reloadData];
            [TYLoadingHub hideLoadingView];
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
    }
    
    alertView.delegate = nil;
    
    alertView = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
}
- (UILabel *)topLabel {
    
    if (!_topLabel) {
        
        _topLabel = [[UILabel alloc] init];
        _topLabel.text = @"添加分项名称";
        _topLabel.textColor = AppFont000000Color;
        _topLabel.font = FONT(AppFont30Size);
    }
    return _topLabel;
}

- (LengthLimitTextField *)subentryInput {
    
    if (!_subentryInput) {
        
        _subentryInput = [[LengthLimitTextField alloc] init];
        _subentryInput.placeholder = @"例如：包柱子/挂窗帘";
        _subentryInput.maxLength = 25;
        _subentryInput.clipsToBounds = YES;
        _subentryInput.layer.borderWidth = 1;
        _subentryInput.layer.borderColor = AppFont999999Color.CGColor;
        _subentryInput.font = FONT(AppFont30Size);
        [_subentryInput setValue:AppFontccccccColor forKeyPath:@"_placeholderLabel.textColor"];
        [_subentryInput setValue:FONT(AppFont28Size) forKeyPath:@"_placeholderLabel.font"];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
        _subentryInput.leftViewMode = UITextFieldViewModeAlways;
        _subentryInput.leftView = leftView;
        
    }
    return _subentryInput;
}

- (UIButton *)sureBtn {
    
    if (!_sureBtn) {
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _sureBtn.titleLabel.font = FONT(AppFont30Size);
        _sureBtn.backgroundColor = AppFontEB4E4EColor;
        _sureBtn.clipsToBounds = YES;
        
        [_sureBtn addTarget:self action:@selector(sureInputSubentry) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureBtn;
}

- (UITableView *)subentryList {
    
    if (!_subentryList) {
        
        _subentryList = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _subentryList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _subentryList.backgroundColor = AppFontEBEBEBColor;
        _subentryList.tableFooterView = [[UIView alloc] init];
        _subentryList.delegate = self;
        _subentryList.dataSource = self;
        
        _subentryList.rowHeight = 45;
    }
    return _subentryList;
}

- (NSMutableArray *)subentryListArray {
    
    if (!_subentryListArray) {
        
        _subentryListArray = [[NSMutableArray alloc] init];
    }
    return _subentryListArray;
}

@end
