//
//  YZGOnlyAddProjectViewController.m
//  mix
//
//  Created by Tony on 16/3/8.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGOnlyAddProjectViewController.h"

#import "JGJMarkBillBaseVc.h"

#import "YZGMateReleaseBillViewController.h"

#import "JGJCreatTeamVC.h"

#import "TYTextField.h"

#import "JGJMoreDayViewController.h"

#import "JGJQRecordViewController.h"
@interface YZGOnlyAddProjectViewController ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *proNameTF;


@property (weak, nonatomic) IBOutlet UIScrollView *scrolloView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;


@end

@implementation YZGOnlyAddProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.saveButton.layer setLayerCornerRadius:5.0];
    if (self.editType == EditMineNameType) {
        
        self.proNameTF.maxLength = UserNameLength;
        
    }else {
        
        self.proNameTF.maxLength = ProNameLength;
        
    }
    
    self.proNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    if (![NSString isEmpty:self.proNameTFPlaceholder]) {
        self.proNameTF.placeholder = self.proNameTFPlaceholder;
    }
    
    if (![NSString isEmpty:self.defaultProName]) {
        self.proNameTF.text = self.defaultProName;
    }
    
    [self.proNameTF becomeFirstResponder];
    
    if (self.editType == EditMineNameType || self.editType == EditProNameType) {
        
        self.saveButton.hidden = YES;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick:)];
        
    }
    
    self.scrolloView.backgroundColor = AppFontf1f1f1Color;
    
    self.saveButton.backgroundColor = AppFontEB4E4EColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.proNameTF];

}

- (IBAction)saveBtnClick:(id)sender {
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    if ([NSString isEmpty:self.proNameTF.text] && self.editType != EditMineNameType) {
        
        NSString *tips = @"请输入班组名称";
        
        if (self.isCreatTeamEditProName) {
            
            tips = @"请输入项目名称";
        }
        
        [TYShowMessage showPlaint:tips];
        return;
    }
    
    
    //此处记多天跳转在转增加项目
    if (_isPopUpVc) {
        
        [TYLoadingHub showLoadingWithMessage:nil];
        
        [JLGHttpRequest_AFN PostWithApi:@"jlworkday/addpro" parameters:@{@"pro_name":self.proNameTF.text} success:^(id responseObject) {
          
            if ([self.delegate respondsToSelector:@selector(addMemberSuccessWithResponse:)]) {
               
                [self.delegate addMemberSuccessWithResponse:responseObject];
             
            }else{
                
                [TYNotificationCenter postNotificationName:@"addNewgroup" object:responseObject];
            
            }
            
            [TYLoadingHub hideLoadingView];
            
            [self.navigationController popViewControllerAnimated:YES];
        }failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
        return;
    }
    
    if (self.isEditGroupName) { //编辑班组名字和从新消息进入-加入班组没有项目时-创建项目
       
        if ([self.delegate respondsToSelector:@selector(handleYZGOnlyAddProjectViewControllerEditName:editType:)]) {
            [self.delegate handleYZGOnlyAddProjectViewControllerEditName:self.proNameTF.text editType:self.editType];
            return;
        
        }
    }
    
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/addpro" parameters:@{@"pro_name":self.proNameTF.text} success:^(id responseObject) {
        
        if (responseObject) {
            
            [TYNotificationCenter postNotificationName:@"addNewgroup" object:responseObject];
        }
        
        if (weakSelf.isCreatTeamEditProName) { //从创建班组进入新建项目
            [weakSelf handleCreatGroupTeamAddPro:responseObject];
        } else {
            [weakSelf handleMateReleaseBillAddPro:responseObject];
        }
    }];
}

- (void)handleAddProName {
    
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/addpro" parameters:@{@"pro_name":self.proNameTF.text} success:^(id responseObject) {
        if (self.isCreatTeamEditProName) { //从创建班组进入新建项目
            [self handleCreatGroupTeamAddPro:responseObject];
        } else {
            [self handleMateReleaseBillAddPro:responseObject];
        }
    }];
}

#pragma mark - 编辑名字 编辑班组名字和从新消息进入-加入班组没有项目时-创建项目
- (void)handleEditName {
    if ([self.delegate respondsToSelector:@selector(handleYZGOnlyAddProjectViewControllerEditName:editType:)]) {
        [self.delegate handleYZGOnlyAddProjectViewControllerEditName:self.proNameTF.text editType:self.editType];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)handleMateReleaseBillAddPro:(id)responseObject {
    //去掉了 不然造成崩溃
    
    JGJMarkBillBaseVc *mateGetBillVc;
    
    if (self.superViewIsGroup) {
        
        YZGMateReleaseBillViewController *releaseBillVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
        
        mateGetBillVc = (JGJMarkBillBaseVc * )[releaseBillVc getSubViewController];
    }else{
        
        mateGetBillVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
        
    }

        if ([self isKindOfClass:[JGJMarkBillBaseVc class]]){
            [mateGetBillVc addProNameByName:responseObject];

        }
    
    [self.navigationController popViewControllerAnimated:YES];
    

}

- (void)handleCreatGroupTeamAddPro:(id)responseObject {
    JGJProjectListModel *projectListModel = [JGJProjectListModel mj_objectWithKeyValues:responseObject];
    projectListModel.pro_id = responseObject[@"pid"];
    JGJCreatTeamVC * creatTeamVC = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGJCreatTeamVC class]]) {
            creatTeamVC = (JGJCreatTeamVC *)vc;
            break;
        }
    }
    creatTeamVC.projectListModel = projectListModel;
    [self.navigationController popToViewController:creatTeamVC animated:YES];
}

#pragma mark - 通知判断
-(void)textFiledEditChanged:(NSNotification*)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    
    [NSString textEditChanged:textField maxLength:self.proNameTF.maxLength];

}

@end
