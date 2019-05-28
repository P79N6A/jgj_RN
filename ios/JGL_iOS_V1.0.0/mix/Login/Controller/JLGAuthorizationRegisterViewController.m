//
//  JLGAuthorizationRegisterViewController.m
//  mix
//
//  Created by Tony on 16/1/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGAuthorizationRegisterViewController.h"
#import "NSString+Extend.h"
#import "JLGAppDelegate.h"

@interface JLGAuthorizationRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *skipButton;

@end

@implementation JLGAuthorizationRegisterViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.skipButton.tintColor = JGJMainColor;
    self.parametersDic[@"role_type"] = JLGisMateBool?@1:@2;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (JLGisMateBool) {
            return 6;
        }else{
        return 5;
        }
    }else{
        return 7;
    }
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //身份证的cell高度
    
    if (indexPath.section == 1 && indexPath.row == 4) {
        return 230;
    }else if(JLGisMateBool && indexPath.section == 1 && indexPath.row == 1){
        return 0;
    }else{
        
        return tableViewCellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self returnCellByTableView:tableView cellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)returnCellByTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *myCellID = @"nillCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellID];
    NSUInteger section = indexPath.section;
    
    switch (section) {
        case 0:
        {
            if (indexPath.row == 0) {
                cell = [JLGRegisterInfoTableViewCell cellWithTableView:tableView];
                JLGRegisterInfoTableViewCell *returnCell = (JLGRegisterInfoTableViewCell *)cell;
                returnCell.indexPath = indexPath;
                returnCell.titleLabel.text = self.authoInfosArray[indexPath.section][indexPath.row][0];
                
                [self setRegisterInfoCellDetailTF:returnCell indexPath:indexPath];
                [self blockWithCell:returnCell];
                return returnCell;
            }else if(indexPath.row == 1){
                JLGRegisterSexTableViewCell *returnCell = [JLGRegisterSexTableViewCell cellWithTableView:tableView];
                [returnCell setSexNum:[self.mateRegisterInfo[@"gender"] integerValue]];
                returnCell.delegate = self;
                
                return returnCell;
            }else if(indexPath.row == 2){
                return [self addBuildAreaCell:tableView cell:cell indexPath:indexPath];
            }else{
                cell = [JLGRegisterClickTableViewCell cellWithTableView:tableView];
                
                JLGRegisterClickTableViewCell *returnCell = (JLGRegisterClickTableViewCell *)cell;
                returnCell.indexPath = indexPath;
                returnCell.titleLabel.text = self.authoInfosArray[indexPath.section][indexPath.row][0];
            
                returnCell.redStarImage.hidden = indexPath.row == 3;
                [self setRegisterClickCellDetailTF:returnCell indexPath:indexPath];
                
                return returnCell;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0 || indexPath.row == 3) {
                cell = [JLGRegisterClickTableViewCell cellWithTableView:tableView];
                
                JLGRegisterClickTableViewCell *returnCell = (JLGRegisterClickTableViewCell *)cell;
                returnCell.indexPath = indexPath;
                returnCell.titleLabel.text = self.authoInfosArray[indexPath.section][indexPath.row][0];
                [self setRegisterClickCellDetailTF:returnCell indexPath:indexPath];
                returnCell.redStarImage.hidden = indexPath.row != 0;
                
                return returnCell;
            }else if(indexPath.row == 2 || indexPath.row == 1){
                if (JLGisMateBool && indexPath.row == 1) {//返回一个空的cell
                    if (!cell)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myCellID];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    return cell;
                }else{
                    return [self addBuildAreaCell:tableView cell:cell indexPath:indexPath];
                }
            }else if(indexPath.row == 4){
                cell = [JLGRegisterHeadPicTableViewCell cellWithTableView:tableView];
                
                JLGRegisterHeadPicTableViewCell *returnCell = (JLGRegisterHeadPicTableViewCell *)cell;
                returnCell.delegate = self;
                if (self.image) {
                    returnCell.headImage = self.image;
                }
                return returnCell;
            }else{
                //cell增加子控件
                cell = [[UITableViewCell alloc] init];
                if (indexPath.row == 5) {
                cell.frame = CGRectMake(0, 0,TYGetUIScreenWidth, tableViewLableCellHeight);

                }else{
                cell.frame = CGRectMake(0, 0,TYGetUIScreenWidth, tableViewCellHeight);
                }
                cell = [self cellAddSubView:cell WithRow:indexPath.row];
                
                return cell;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)setRegisterInfoCellDetailTF:(JLGRegisterInfoTableViewCell *)returnCell indexPath:(NSIndexPath *)indexPath{
    NSString *keyString = self.mateRegisterInfo[[self getKeyByIndexPath:indexPath]];
    //设置显示的内容
    if (keyString) {
        returnCell.detailTF.text = keyString;
    }else{
        returnCell.detailTF.placeholder = self.authoInfosArray[indexPath.section][indexPath.row][1];
    }
}

- (JLGBuildAreaTableViewCell *)addBuildAreaCell:(UITableView *)tableView cell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    cell = [JLGBuildAreaTableViewCell cellWithTableView:tableView];
    
    JLGBuildAreaTableViewCell *returnCell = (JLGBuildAreaTableViewCell *)cell;
    
    returnCell.titleLabel.text = self.authoInfosArray[indexPath.section][indexPath.row][0];
    //设置后缀
    returnCell.squareLabel.text = indexPath.section == 0?@"岁":(indexPath.row == 1?@"人":@"年");
    
    //最大人数
    if (indexPath.section !=0 && indexPath.row == 1) {
        returnCell.detailTF.maxLength = 5;
    }else{
        returnCell.detailTF.maxLength = 2;
    }

    //面积和工期字符串转换
    NSString *age_int = [self.parametersDic[@"age"] integerValue] !=0?self.parametersDic[@"age"]:nil;
    NSString *workyear_int = [self.parametersDic[@"workyear"] integerValue]!=0?self.parametersDic[@"workyear"]:nil;
    NSString *scale_int = [self.parametersDic[@"person_count"] integerValue]!=0?self.parametersDic[@"person_count"]:nil;
    
    //设置内容
    NSString *detailString = indexPath.section == 0?age_int:(indexPath.row == 1?workyear_int:scale_int);
    NSString *defaultString = self.authoInfosArray[indexPath.section][indexPath.row][1];
    returnCell.detailTF.text = detailString?:nil;
    returnCell.detailTF.placeholder = defaultString;
    
    [self blockWithBuildAreaCell:returnCell indexPath:indexPath];
    return returnCell;
}

#pragma mark - cellBlock
- (void)blockWithBuildAreaCell:(JLGBuildAreaTableViewCell *)returnCell indexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    
    //beginEdit
    [returnCell beginEditWithBlock:^{
        [weakSelf.cityPickerView hiddenCityPicker];
    }];
    
    //endEdit
    [returnCell endEditWithBlock:^(NSString *detailTFStr) {
        if (indexPath.section == 0) {
            weakSelf.parametersDic[@"age"] = detailTFStr;
        }else{
            if (indexPath.row == 1) {
                weakSelf.parametersDic[@"person_count"] = detailTFStr;
            }else{
                weakSelf.parametersDic[@"workyear"] = detailTFStr;
            }
        }
    }];
}

//头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return tableViewHeadHeight;
    }else{
        return 4;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"为了提高工作的机会，请认真填写以下有效的真实信息";
    }else{
        return nil;
    }
}

//cell增加子控件
- (UITableViewCell *)cellAddSubView:(UITableViewCell *)cell WithRow:(NSInteger )row{
    
    if (row == 5) {
        [self addLabel:cell];
    }else if(row == 6){
        [self addButton:cell];
    }
    
    return cell;
}

#pragma mark - cell的选择操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TYLog(@"indexPath.section = %@,indexPath.row = %@",@(indexPath.section),@(indexPath.row));
    //第0组最后一个不用弹出的
    if (indexPath.section == 0 && (indexPath.row != 3 )&&indexPath.row != 4&&indexPath.row !=5) {
        return;
    }
    if (indexPath.section == 0 && indexPath.row == 4) {
        
        JLGProjectTypeViewController *projectTypeVc = [[UIStoryboard storyboardWithName:@"ManageProject" bundle:nil] instantiateViewControllerWithIdentifier:@"projectType"];
        projectTypeVc.delegate = self;
        
        projectTypeVc.selectedType = WorkType;
        projectTypeVc.selectedSingle = NO;
        projectTypeVc.indexPath = indexPath;
        projectTypeVc.projectTypesArray = [self.workTypesArray mutableCopy];
        projectTypeVc.selectedArray = [self.workTypesSelectArray mutableCopy];
    
        [self.navigationController pushViewController:projectTypeVc animated:YES];

    }
  else  if (indexPath.section == 0 && indexPath.row == 5) {
        
        JLGProjectTypeViewController *projectTypeVc = [[UIStoryboard storyboardWithName:@"ManageProject" bundle:nil] instantiateViewControllerWithIdentifier:@"projectType"];
        projectTypeVc.delegate = self;
        
        projectTypeVc.selectedType = Work_level;
        projectTypeVc.selectedSingle = YES;
        projectTypeVc.indexPath = indexPath;
        
        projectTypeVc.projectTypesArray = [self.skillTypesArray mutableCopy];
        projectTypeVc.selectedArray = [self.workTypesSelectArray mutableCopy];
        [self.navigationController pushViewController:projectTypeVc animated:YES];
        
    }

    //第1组的第2以后的都不用弹出
    if (indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4)) {
        return ;
    }
    
    //弹出的界面
    if (indexPath.section == 0 && indexPath.row !=4&& indexPath.row != 5) {//第一组
        self.cityPickerView.onlyShowCitys = NO;
        [self.cityPickerView showCityPickerByIndexPath:indexPath];
    }else{//第二组
        if (indexPath.row == 0 || indexPath.row == 1) {
            JLGProjectTypeViewController *projectTypeVc = [[UIStoryboard storyboardWithName:@"ManageProject" bundle:nil] instantiateViewControllerWithIdentifier:@"projectType"];
            projectTypeVc.delegate = self;
            
            projectTypeVc.selectedType = ProjectType;
            projectTypeVc.selectedSingle = NO;
            projectTypeVc.indexPath = indexPath;
            
            if(indexPath.row == 0){
                projectTypeVc.projectTypesArray = [self.projectTypesArray mutableCopy];
                projectTypeVc.selectedArray = [self.workTypesSelectArray mutableCopy];
            }else if(indexPath.row == 1){
                projectTypeVc.projectTypesArray = [self.projectTypesArray mutableCopy];
                projectTypeVc.selectedArray = [self.projectTypesSelectArray mutableCopy];
            }
            [self.navigationController pushViewController:projectTypeVc animated:YES];
        }else if(indexPath.row == 3){
            self.cityPickerView.onlyShowCitys = YES;
            [self.cityPickerView showCityPickerByIndexPath:indexPath];
        }
    }
    
    [self.view endEditing:YES];
}

#pragma mark - 点击了头像
- (void)JLGRegisterHeadPicBtnClick{
    [self.sheet showInView:self.view];
    [self.view endEditing:YES];
}

#pragma mark - 选择了性别
- (void)setSexNum:(SexNum )sexNum{
    self.mateRegisterInfo[@"gender"] = @(sexNum);
    self.parametersDic[@"gender"] = @(sexNum);
}

#pragma mark actionSheet的代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 2) return;//取消
    
    //修改iOS8以上,打开相机慢的问题
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
    }
    
    if(buttonIndex == 0){//照相
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{//相册
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //显示图片选择器
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // info中就包含了选择的图片
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }

    //存入相片数组
    self.image = image;
    
    [self tableViewReloadAfterSelectedImage];
    
    //隐藏当前的模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
}

//选完图片以后刷新
- (void)tableViewReloadAfterSelectedImage{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:4 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (BOOL )checkBaseData{
    NSString *realName = self.parametersDic[@"realname"];
    //姓名的提示
    if(!realName){
        [TYShowMessage showPlaint:@"请输入姓名"];
        return NO;
    }
    
    if(realName.length < 2 && realName.length <= 15){
        [TYShowMessage showPlaint:@"请输入正确的姓名!"];
        return NO;
    }
    
    if(!self.parametersDic[@"gender"]){
        [TYShowMessage showPlaint:@"请选择性别"];
        return NO;
    }
    
    if(!self.parametersDic[@"age"]){
        [TYShowMessage showPlaint:@"请输入年龄"];
        return NO;
    }else if([self.parametersDic[@"age"] integerValue] < 15){
        [TYShowMessage showPlaint:@"年龄输入有误"];
        return NO;
    }
    
    
    if(![self.parametersDic[@"workyear"] integerValue]){
        [TYShowMessage showPlaint:@"请输入你的工龄"];
        return NO;
    }

    if (JLGisLeaderBool) {//班组长/工头才检查工人规模
        if(!self.parametersDic[@"person_count"]){
            [TYShowMessage showPlaint:@"请选择工人规模"];
            return NO;
        }
    }
    
    
    if(!self.parametersDic[@"worktype"]){
        [TYShowMessage showPlaint:@"请选择项目类别"];
        return NO;
    }
    
    return YES;
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

    [JLGHttpRequest_AFN uploadImagesWithApi:@"jlsignup/mduserinfo" parameters:self.parametersDic imagearray:imageArray success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        
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
        [TYUserDefaults synchronize];
        [weakSelf popToSuperVc];
        [TYShowMessage showSuccess:@"完善成功"];
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)JLGProjectTypeVc:(JLGProjectTypeViewController *)workTypeVc SelectedArray:(NSArray *)selectedArray dataDic:(NSDictionary *)dataDic{
    NSString *key = [self getKeyByIndexPath:workTypeVc.indexPath];

    self.parametersDic[key] = dataDic[@"id"];
    self.mateRegisterInfo[key] = dataDic[@"name"];
    if (workTypeVc.indexPath.row == 0) {
        self.workTypesSelectArray = [selectedArray mutableCopy];
    }else{
        self.projectTypesSelectArray = [selectedArray mutableCopy];
    }
    
    workTypeVc.delegate = nil;
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:workTypeVc.indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 跳过
- (IBAction)skipToRootVc{
    [self popToSuperVc];
}

- (void)popToSuperVc{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    JLGAppDelegate *jlgAppDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;
//    [jlgAppDelegate setRootViewController];
//    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (JLGCityPickerView *)cityPickerView
{
    if (!_cityPickerView) {
        _cityPickerView = [[JLGCityPickerView alloc] initWithFrame:TYGetUIScreenRect];
        _cityPickerView.delegate = self;
        _cityPickerView.backgroundColor = [UIColor clearColor];
        [[[UIApplication sharedApplication] delegate].window addSubview:_cityPickerView];
    }
    return _cityPickerView;
}


#pragma mark - 继承内容
- (void)initData{
    //设置显示内容的数组
    [self initAutoInfoArray];
    
    //从数据库读数据
    [self sqlDataSourceInit];
    
    //初始化注册信息的dictionary
    self.mateRegisterInfo = [NSMutableDictionary dictionary];
    self.parametersDic = [NSMutableDictionary dictionary];

    //初始化照片选择
    [self initSheetPicker];
}

- (void)initAutoInfoArray{
    if (!JLGisLeaderBool) {
        
    
    self.authoInfosArray = @[
                             @[
                                 @[@"姓名:",@"请输入你的真实姓名"],
                                 @[@"",@""],
                                 @[@"年龄:",@"请输入年龄"],
                                 @[@"家乡:",@"选择家乡可以让朋友找到你"],
                                 @[@"工种:",@"请选择你主要从事的工种"],
                                 @[@"熟练度:",@"请选择熟练度"]
                                 ],
                             @[
                                 @[@"工程类别:",@"请选择你主要从事的工程类别"],
                                 @[@"工人规模:",@"请输入工人规模"],
                                 @[@"工龄:",@"请输入工龄"],
                                 @[@"期望工作地:",@"请选择工作地"]
                                 ]
                             ];
    }else{
    
        self.authoInfosArray = @[
                                 @[
                                     @[@"姓名:",@"请输入你的真实姓名"],
                                     @[@"",@""],
                                     @[@"年龄:",@"请输入年龄"],
                                     @[@"家乡:",@"选择家乡可以让朋友找到你"],
                                     @[@"工种:",@"请选择你主要从事的工种"],
                                     ],
                                 @[
                                     @[@"工程类别:",@"请选择你主要从事的工程类别"],
                                     @[@"工人规模:",@"请输入工人规模"],
                                     @[@"工龄:",@"请输入工龄"],
                                     @[@"期望工作地:",@"请选择工作地"]
                                     ]
                                 ];
    }
}


- (NSString *)getKeyByIndexPath:(NSIndexPath *)indexPath{
    NSString *key;
    
    if (!JLGisMateBool) {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    key = @"realname";
                    break;
                case 1:
                    key = @"gender";
                    break;
                case 2:
                    key = @"hometown";
                    break;
                case 3:
                    key = @"hometown";
                    break;
                case 4:
                    key = @"f_worktype";
                    break;
            }
        }else if(indexPath.section == 1){
            switch (indexPath.row) {
                case 0:
                    key = @"w_protype";
                    break;
                case 1:
                    key = @"person_count";
                    break;
                case 2:
                    key = @"workyear";
                    break;
                case 3:
                    key = @"expectaddr";
                    break;
                case 4:
                    key = @"head_pic";
                    break;
            }
        }
    }else{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                key = @"realname";
                break;
            case 1:
                key = @"gender";
                break;
            case 2:
                key = @"hometown";
                break;
            case 3:
                key = @"hometown";
                break;
            case 4:
                key = @"w_worktype";
                break;
            case 5:
                key = @"work_level";
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                key = @"w_protype";
                break;
            case 1:
                key = @"person_count";
                break;
            case 2:
                key = @"workyear";
                break;
            case 3:
                key = @"expectaddr";
                break;
            case 4:
                key = @"head_pic";
                break;
        }
    }
//    return key;
    }
    return key;

}

- (void)setHeaderViewLabelAlignment:(UILabel *)label{
    label.textAlignment = NSTextAlignmentCenter;
}

- (void)sqlDataSourceInit{
    //初始化数据源
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weakSelf.workTypesSelectArray = [NSMutableArray array];
        weakSelf.projectTypesSelectArray = [NSMutableArray array];
        weakSelf.skillSelectArr = [NSMutableArray array];
        //取数据库 熟练度jlg_work_level//项目类型jlg_project_type////工种jlg_work_type
        weakSelf.skillTypesArray =[TYFMDB searchTable:@"jlg_work_level"];
        weakSelf.workTypesArray = [TYFMDB searchTable:@"jlg_work_type"];
        weakSelf.projectTypesArray = [TYFMDB searchTable:@"jlg_project_type"];
        [weakSelf.workTypesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            weakSelf.workTypesSelectArray[idx] = @NO;
        }];
        [weakSelf.projectTypesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            weakSelf.projectTypesSelectArray[idx] = @NO;
        }];
        [weakSelf.skillSelectArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            weakSelf.skillSelectArr[idx] = @NO;
        }];

    });
}

- (void )initSheetPicker{
    self.sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = YES;
}
@end
