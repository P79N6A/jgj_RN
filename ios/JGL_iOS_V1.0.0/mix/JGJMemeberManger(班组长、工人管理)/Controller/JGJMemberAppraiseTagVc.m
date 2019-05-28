//
//  JGJMemberAppraiseTagVc.m
//  mix
//
//  Created by yj on 2018/4/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemberAppraiseTagVc.h"

#import "JGJInputContentView.h"

#import "JGJCusEvaNavView.h"

#import "JGJTagListCell.h"

@interface JGJMemberAppraiseTagVc () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JGJInputContentView *inputContentView;

@property (nonatomic, strong) JGJCusEvaNavView *cusEvaNavView;

@property (nonatomic, strong) NSArray *tagList;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JGJMemberAppraiseTagVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评价";
    
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [self.view addSubview:self.cusEvaNavView];
    
    [self.view addSubview:self.inputContentView];
    
    [self.view addSubview:self.tableView];
    
    TYWeakSelf(self);
    
    self.inputContentView.inputContentViewBlock = ^(NSString *content) {
      
        [weakself searchTagnameWithTagname:content];
    };
    
    self.inputContentView.addButtonPressedBlock = ^(NSString *content) {
      
        if ([NSString isEmpty:content]) {
            
            [TYShowMessage showPlaint:@"请输入标签信息"];
            
            return ;
        }
        
        JGJMemberImpressTagViewModel *tagModel = [JGJMemberImpressTagViewModel new];
        
        tagModel.tag_name = content;
        
        [weakself selTagModel:tagModel];
        
    };
    
    self.cusEvaNavView.closedButtonPressedBlock = ^{
      
        [weakself dismissViewControllerAnimated:nil completion:nil];
        
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    };
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    
    tableViewGesture.numberOfTapsRequired = 1;
    
    tableViewGesture.cancelsTouchesInView = NO;
    
    [self.tableView addGestureRecognizer:tableViewGesture];
}

//影响评价输入
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tagList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJTagListCell *cell = [JGJTagListCell cellWithTableView:tableView];
 
    cell.tagModel = self.tagList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJMemberImpressTagViewModel *tagModel = self.tagList[indexPath.row];
        
    [self selTagModel:tagModel];
}

- (void)selTagModel:(JGJMemberImpressTagViewModel *)tagModel {
    
    if (self.tagVcBlock) {
        
        tagModel.selected = YES;
        
        self.tagVcBlock(tagModel);
    }
        
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchTagnameWithTagname:(NSString *)tagname {
    
    if ([NSString isEmpty:tagname] || tagname.length < 2) {
        
        return;
        
    }
    
    [JLGHttpRequest_AFN PostWithNapi:@"evaluate/search-tags" parameters:@{@"tag_name" : tagname?:@""} success:^(id responseObject) {
        
        self.tagList = [JGJMemberImpressTagViewModel mj_objectArrayWithKeyValuesArray:responseObject];
        
    } failure:^(NSError *error) {
       
        
    }];
}

- (void)setTagList:(NSArray *)tagList {
    
    _tagList = tagList;
    
    [self.tableView reloadData];
    
}

- (JGJCusEvaNavView *)cusEvaNavView {
    
    if (!_cusEvaNavView) {
        
        _cusEvaNavView = [[JGJCusEvaNavView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, JGJ_NAV_HEIGHT)];
    }
    
    return _cusEvaNavView;
}

- (JGJInputContentView *)inputContentView {
    
    if (!_inputContentView) {
        
        _inputContentView = [[JGJInputContentView alloc] initWithFrame:CGRectMake(0, TYGetMaxY(self.cusEvaNavView), TYGetUIScreenWidth, 75)];
    }
    
    return _inputContentView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, TYGetMaxY(self.inputContentView), TYGetUIScreenWidth, TYGetUIScreenHeight -TYGetMaxY(self.inputContentView));
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        self.view.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _tableView;
}

- (void)commentTableViewTouchInSide{
    
    [self.view endEditing:YES];
}

@end
