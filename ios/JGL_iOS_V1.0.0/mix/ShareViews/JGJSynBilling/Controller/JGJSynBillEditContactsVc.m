//
//  JGJSynBillEditContactsVc.m
//  mix
//
//  Created by jizhi on 16/5/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSynBillEditContactsVc.h"
#import "UITableViewCell+Extend.h"
#import "JGJSynBillEditContactsTableViewCell.h"
#import "JGJSyncProlistVC.h"
#import "JGJSynBillingManageVC.h"
@interface JGJSynBillEditContactsVc ()

@end

@implementation JGJSynBillEditContactsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正在修改同步对象";
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 234;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJSynBillEditContactsTableViewCell *synBillEditContactsCell = [JGJSynBillEditContactsTableViewCell cellWithTableView:tableView];
    synBillEditContactsCell.synBillingModel = self.synBillingModel;

    __weak typeof(self) weakSelf = self;
    [synBillEditContactsCell SynBillEditContactsSaveBlock:^(JGJSynBillEditContactsTableViewCell *cell) {
        //修改了的情况
        if (![cell.nameTF.text isEqualToString:weakSelf.synBillingModel.real_name] ||
            ![cell.descriptionTF.text isEqualToString:weakSelf.synBillingModel.descript]) {
            
            NSDictionary *parametersDic = @{@"realname":cell.nameTF.text,@"telph":cell.phoneTF.text,@"descript":cell.descriptionTF.text,@"option":@"u"};
            [JLGHttpRequest_AFN PostWithApi:@"jlworksync/optusersync" parameters:parametersDic success:^(id responseObject) {
                [TYShowMessage showSuccess:@"修改成功!"];
                //                    刷新更改的数据
                for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[JGJSyncProlistVC class]]) {
                        JGJSyncProlistVC *syncProlistVC = ( JGJSyncProlistVC *)vc;
                        syncProlistVC.synBillingModel = weakSelf.synBillingModel;
                        syncProlistVC.synBillingModel.real_name = cell.nameTF.text;
                        syncProlistVC.synBillingModel.descript = cell.descriptionTF.text;
                    }

                    if ([vc isKindOfClass:[JGJSynBillingManageVC class]]) {
                         JGJSynBillingManageVC *synBillingManageVC  = ( JGJSynBillingManageVC *)vc;
                        for (JGJSynBillingModel *synBillingModel in synBillingManageVC.dataSource) {
                            if ([synBillingModel.telephone isEqualToString:weakSelf.synBillingModel.telephone]) {
                                synBillingModel.real_name = cell.nameTF.text;
                                synBillingModel.descript = cell.descriptionTF.text;
                            }
                        }
                    }
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }else{//没有修改的情况
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    return synBillEditContactsCell;
}

@end
