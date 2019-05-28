//
//  JLGAddRegisterInfoViewController.m
//  mix
//
//  Created by Tony on 16/1/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGAddRegisterInfoViewController.h"
#import "NSString+Extend.h"
#import "JLGAppDelegate.h"

@implementation AddRegisterInfoModel

@end

@interface JLGAddRegisterInfoViewController ()

@property (nonatomic,strong) AddRegisterInfoModel *addRegisterInfoModel;
@end

@implementation JLGAddRegisterInfoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.hidden = YES;
    [self JLGHttpRequest];
}

- (void)JLGHttpRequest{
    [JLGHttpRequest_AFN PostWithApi:@"jlsignup/getUnmappingFiled" parameters:nil success:^(id responseObject) {
        
        [self.addRegisterInfoModel mj_setKeyValues:responseObject];
        
        if (!JLGisLeaderBool) {
            self.addRegisterInfoModel.person_count = 0;
        }
            [self.tableView reloadData];
        [TYLoadingHub hideLoadingView];
        self.tableView.hidden = NO;
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_hiddenLeftItem) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - tableView
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat headPicCellHeight = 230;

    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return [self getZeroCellHeight:!(self.addRegisterInfoModel.realname)];
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        return [self getZeroCellHeight:!(self.addRegisterInfoModel.gender)];
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        return [self getZeroCellHeight:!(self.addRegisterInfoModel.age)];
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        return [self getZeroCellHeight:!(self.addRegisterInfoModel.hometown)];
    }else if (indexPath.section == 0 && indexPath.row == 3) {
        return [self getZeroCellHeight:!(self.addRegisterInfoModel.hometown)];
    }else if(indexPath.section == 1 && indexPath.row == 0){;
        return [self getZeroCellHeight:!(self.addRegisterInfoModel.w_worktype || self.addRegisterInfoModel.f_worktype)];
    }else if(indexPath.section == 1 && indexPath.row == 1){;//工人规模
     
        return [self getZeroCellHeight:!(self.addRegisterInfoModel.person_count)];
    }else if(indexPath.section == 1 && indexPath.row == 2){//工龄
        return [self getZeroCellHeight:!(self.addRegisterInfoModel.workyear)];
    }else if (indexPath.section == 1 && indexPath.row == 3) {
        return [self getZeroCellHeight:!(self.addRegisterInfoModel.expectaddr)];
    }else if (indexPath.section == 1 && indexPath.row == 4) {
        if (self.addRegisterInfoModel.head_pic) {//需要补充头像
            return headPicCellHeight;
        }else{
            return 0;
        }
    }else{
        return tableViewCellHeight;
    }
}

- (CGFloat )getZeroCellHeight:(BOOL )zero{
 
    if (!zero) {
        return tableViewCellHeight;
    }else{
        return 0.0;
    }
}

//头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return tableViewHeadHeight;
    }else{
        return 0.01;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"为了提高工作的机会，请认真填写以下有效的真实信息";
    }else{
        return nil;
    }
}


#pragma mark - 重写父类方法返回的cell
- (UITableViewCell *)returnCellByTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0 && indexPath.row == 0 ) {//需要补充姓名
        return [self getNillCell:!self.addRegisterInfoModel.realname indexPath:indexPath];
    }else if (indexPath.section == 0 && indexPath.row == 1) {//需要补充性别
        return [self getNillCell:!self.addRegisterInfoModel.gender indexPath:indexPath];
    }else if (indexPath.section == 0 && indexPath.row == 2) {//需要补充年龄
        return [self getNillCell:!self.addRegisterInfoModel.age indexPath:indexPath];
    }else if (indexPath.section == 0 && indexPath.row == 3) {//需要补充家乡
        return [self getNillCell:!self.addRegisterInfoModel.hometown indexPath:indexPath];
    }else if (indexPath.section == 1 && indexPath.row == 0) {//需要补充期工种类型
        return [self getNillCell:!(self.addRegisterInfoModel.w_worktype || self.addRegisterInfoModel.f_worktype) indexPath:indexPath];
    }else if (indexPath.section == 1 && indexPath.row == 1) {//需要补充工人规模
        return [self getNillCell:!self.addRegisterInfoModel.person_count indexPath:indexPath];
    }else if (indexPath.section == 1 && indexPath.row == 2) {//需要工龄
        return [self getNillCell:!self.addRegisterInfoModel.workyear indexPath:indexPath];
    }else if (indexPath.section == 1 && indexPath.row == 3) {//需要补充期望期望工作地
        return [self getNillCell:!self.addRegisterInfoModel.expectaddr indexPath:indexPath];
    }else if (indexPath.section == 1 && indexPath.row == 4) {//需要补充头像
        return [self getNillCell:!self.addRegisterInfoModel.head_pic indexPath:indexPath];
    }
    
   return [super returnCellByTableView:tableView cellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)getNillCell:(BOOL )nillCellBool indexPath:(NSIndexPath *)indexPath{
    //创建空白的cellr
    NSString *MyIdentifierID = NSStringFromClass([self class]);
    //从缓存池中取出cell
    UITableViewCell *nilCell = [self.tableView dequeueReusableCellWithIdentifier:MyIdentifierID];
    {
        //缓存池中无数据
        if(nilCell == nil){
            nilCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifierID];
            nilCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    if (nillCellBool) {
        return nilCell;
    }else{
        return [super returnCellByTableView:self.tableView cellForRowAtIndexPath:indexPath];
    }
}
- (BOOL )checkBaseData{
    if (self.addRegisterInfoModel.realname) {
        //姓名的提示
        NSString *realName = self.parametersDic[@"realname"];
        if(!realName){
            [TYShowMessage showPlaint:@"请输入姓名"];
            return NO;
        }
        
        if(realName.length < 2 && realName.length <= 15){
            [TYShowMessage showPlaint:@"请输入正确的姓名!"];
            return NO;
        }
    }

    if (self.addRegisterInfoModel.gender) {
        if(!self.parametersDic[@"gender"]){
            //因为现在要默认选择男士  所以在不动其他代码的情况下设置为男士
            [self.parametersDic setObject:@"1" forKey:@"gender"];
//            [TYShowMessage showPlaint:@"请选择性别"];
//            return NO;
        }
    }
    
    if (self.addRegisterInfoModel.age) {
        if(!self.parametersDic[@"age"]){
            [TYShowMessage showPlaint:@"请输入年龄"];
            return NO;
        }else if([self.parametersDic[@"age"] integerValue] < 15){
            [TYShowMessage showPlaint:@"年龄输入有误"];
            return NO;
        }
    }

    if (self.addRegisterInfoModel.workyear) {
        if(![self.parametersDic[@"workyear"] integerValue]){
            [TYShowMessage showPlaint:@"请输入你的工龄"];
            return NO;
        }
    }

    
    if (self.addRegisterInfoModel.person_count) {
        if (JLGisLeaderBool) {//班组长/工头才检查工人规模
            if(!self.parametersDic[@"person_count"]){
                [TYShowMessage showPlaint:@"请选择工人规模"];
                return NO;
            }
        }
    }
    /*
    if (self.addRegisterInfoModel.w_worktype || self.addRegisterInfoModel.f_worktype) {
        //项目类别先去掉，有问题在看
//        if(!self.parametersDic[@"worktype"]){
//            [TYShowMessage showPlaint:@"请选择项目类别"];
//            return NO;
//        }else
        if(self.addRegisterInfoModel.w_worktype){
            self.parametersDic[@"w_worktype"] = self.parametersDic[@"worktype"];
            [self.parametersDic removeObjectForKey:@"worktype"];
        }else if(self.addRegisterInfoModel.f_worktype){
            self.parametersDic[@"f_worktype"] = self.parametersDic[@"worktype"];
            [self.parametersDic removeObjectForKey:@"worktype"];
        }
    }
     */

    return YES;
}

- (void)popToSuperVc{
//    [self.navigationController popToRootViewControllerAnimated:YES];不能pop到首页
    JLGAppDelegate *jlgAppDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
    [jlgAppDelegate setRootViewController];
}

#pragma mark - 结束注册
- (void)finishBtnClick:(UIButton *)sender{
    if (![self checkBaseData]) {
        return;
    }
    
    [TYLoadingHub showLoadingWithMessage:@""];
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *imageArray = [NSMutableArray array];
    if (self.image) {
        [imageArray addObject:self.image];
    }

    [JLGHttpRequest_AFN uploadImagesWithApi:@"jlsignup/upuserinfo" parameters:self.parametersDic imagearray:imageArray success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showSuccess:@"补充资料成功"];
        //设置权限
        NSInteger roleNum = [responseObject[@"role"] integerValue];
        //如果有权限，直接赋权限,并且跳转到对应的权限界面
        if ([responseObject[@"is_info"] integerValue] == 1) {
            
            if (roleNum == 1) {
                [TYUserDefaults setBool:YES forKey:JLGMateIsInfo];
                [TYUserDefaults setBool:NO forKey:JLGLeaderIsInfo];
            }else{
                [TYUserDefaults setBool:NO forKey:JLGMateIsInfo];
                [TYUserDefaults setBool:YES forKey:JLGLeaderIsInfo];
            }
        }
        
        if (![NSString isEmpty:self.parametersDic[@"realname"]]) {
            [TYUserDefaults setBool:YES forKey:JLGIsRealName];
        }
        [TYUserDefaults setObject:self.parametersDic[@"realname"]?:@"" forKey:JGJUserName];
        [TYUserDefaults synchronize];
        [weakSelf popToSuperVc];
        
        NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
        infoVer += 1;
        [TYUserDefaults setObject:@(infoVer) forKey:JGJInfoVer];
        
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

- (AddRegisterInfoModel *)addRegisterInfoModel
{
    if (!_addRegisterInfoModel) {
        _addRegisterInfoModel = [[AddRegisterInfoModel alloc] init];
    }
    return _addRegisterInfoModel;
}

@end
