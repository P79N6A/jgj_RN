//
//  JGJQuaSafeModifyMeaVc.m
//  mix
//
//  Created by yj on 2018/1/12.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJQuaSafeModifyMeaVc.h"

#import "JGJPushContentCell.h"

#import "JGJQualityDetailVc.h"

@interface JGJQuaSafeModifyMeaVc () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JGJQuaSafeModifyMeaVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"整改措施";
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJPushContentCell *contentCell = [JGJPushContentCell cellWithTableView:tableView];
    
    contentCell.maxContentWords = 400;
    
    contentCell.placeholderText = @"请输入整改措施";
    
    if (![NSString isEmpty:self.modifyRequstModel.msg_steps]) {
        
        contentCell.checkRecordDefaultText = self.modifyRequstModel.msg_steps;
        
    }else {
        
        contentCell.checkRecordDefaultText = self.qualityDetailModel.msg_steps;
    }
    
    TYWeakSelf(self);
    contentCell.pushContentCellBlock = ^(YYTextView *textView) {
        
        weakself.modifyRequstModel.msg_steps = textView.text;
        
    };
    
    return contentCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 206;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
        
        CGRect rectNav = self.navigationController.navigationBar.frame;
        
        CGFloat height = rectStatus.size.height + rectNav.size.height;
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - height);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = AppFontf1f1f1Color;
        
        self.view.backgroundColor = AppFontf1f1f1Color;
        
    }
    
    return _tableView;
    
}

- (void)rightBarButtonItemPressed{
    
    NSDictionary *parameters = [self.modifyRequstModel mj_keyValues];
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/quality/modifyQaulitySafe" parameters:parameters success:^(id responseObject) {
        
        //清除完成时间
        self.modifyRequstModel.finish_time = nil;
        
        
        //清除整改措施
        self.modifyRequstModel.msg_steps = nil;
        
        //整改负责人
        self.modifyRequstModel.principal_uid = nil;
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [self freshQuaSafeDetail];
        
        [TYLoadingHub hideLoadingView];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
    
}

- (void)freshQuaSafeDetail {
    
    for (JGJQualityDetailVc *detailVc in self.navigationController.viewControllers) {
        
        if ([detailVc isKindOfClass:NSClassFromString(@"JGJQualityDetailVc")]) {
            
            [detailVc loadNetData];
            
            break;
        }
    }
}

@end
