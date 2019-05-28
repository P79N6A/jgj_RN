//
//  JLGAddProExperienceViewController.m
//  mix
//
//  Created by Tony on 16/1/13.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGAddProExperienceViewController.h"
#import "TYShowMessage.h"
#import "JLGNewOppModel.h"
#import "NSString+Extend.h"
#import "SDWebImageManager.h"
#import "JLGCityPickerView.h"
#import "UITableViewCell+Extend.h"
#import "JLGSearchViewController.h"
#import "JLGAddProExperienceTableViewCell.h"
#import "JLGSendProjectTableViewCell.h"

@interface JLGAddProExperienceViewController ()
<
    JLGCityPickerViewDelegate,
    JLGSearchViewControllerDelegate,
    JLGSendProjectTableViewCellDelegate,
    JLGMYProExperienceTableViewCellDelegate
>


@property (nonatomic, assign) LGShowImageType showType;
@property (nonatomic,strong) JLGSearchViewController *searchVc;
@property (strong, nonatomic) JLGCityPickerView *cityPickerView;
@end

@implementation JLGAddProExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSet];
}

- (void)commonSet {

    self.maxImageCount = 9;
    
    ![NSString isEmpty:self.pid]?self.title = @"编辑项目经验":nil;
    if (![NSString isEmpty:self.pid] && self.imageUrlArray.count == 0) {
        [self JLGHttpRequest];
    }
    
    if (self.imageUrlArray.count) {
        self.imagesArray = [self.imageUrlArray mutableCopy];
    }
}

- (void )JLGHttpRequest{
    [TYLoadingHub showLoadingWithMessage:@""];
    //解析数据
    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN PostWithApi:@"jlwork/showproexperience" parameters:@{@"pid":self.pid} success:^(NSDictionary *responseObject) {
        if (responseObject) {
            JLGNewOppModel *newOppModel = [[JLGNewOppModel alloc] init];
            [newOppModel setValuesForKeysWithDictionary:responseObject];
            
            weakSelf.addProExperienceInfo[@"proaddress"] =  newOppModel.proaddress;
            weakSelf.addProExperienceInfo[@"proname"] = newOppModel.proname;
            weakSelf.addProExperienceInfo[@"region"] = newOppModel.region;
            weakSelf.addProExperienceInfo[@"regionname"] = newOppModel.regionname;
            
            weakSelf.parametersDic[@"pid"] = @(newOppModel.pid);
            
            NSArray *urlArray = responseObject[@"url"];
            if (urlArray.count > 0) {
                weakSelf.imagesArray = [responseObject[@"url"] mutableCopy];
            }

            [TYLoadingHub hideLoadingView];
            [weakSelf.tableView reloadData];
        }
    }failure:^(NSError *error) {
       [TYLoadingHub hideLoadingView];
    }];
}


- (UIImage *)getShareImages:(NSString *)url{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    __block UIImage *backImage;
    //分享的图片
    NSURL *shareImageURL = [NSURL URLWithString:url];
    
    [manager downloadImageWithURL:shareImageURL
                          options:0
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                backImage =  image;
                            }else{
                                backImage =  [UIImage imageNamed:@"defaultPic"];
                            }
                        }];
    
    return backImage;
}

#pragma mark - tableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        JLGAddProExperienceTableViewCell *cell = [JLGAddProExperienceTableViewCell cellWithTableView:tableView];
        cell.imagesArray = self.imagesArray;
        return cell.cellHeight;
    }else if(indexPath.row == 4){
        return 70;
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ((self.parametersDic[@"pid"] || self.parametersDic[@"id"]) && indexPath.row < 3) {//如果不是自建项目并且是前三行，就不能点击
        cell.userInteractionEnabled = NO;
    }

    switch (indexPath.row) {
        case 0:
        {
            cell = [JLGRegisterInfoTableViewCell cellWithTableView:tableView];
            JLGRegisterInfoTableViewCell *returnCell = (JLGRegisterInfoTableViewCell *)cell;
            returnCell.titleLabel.text = self.authoInfosArray[indexPath.section][indexPath.row][0];

            [self setRegisterInfoCellDetailTF:returnCell indexPath:indexPath];
            returnCell.indexPath = indexPath;
            [self blockWithCell:returnCell];

            if (self.parametersDic[@"pid"] || self.parametersDic[@"id"]|| self.pid) {//如果不是自建项目并且是前三行，就不能点击
                returnCell.detailTF.userInteractionEnabled = NO;
            }
            
            returnCell.onlyNum = NO;
            return returnCell;
        }
            break;
        case 1:
        case 2:
        {
            cell = [JLGRegisterClickTableViewCell cellWithTableView:tableView];
            JLGRegisterClickTableViewCell *returnCell = (JLGRegisterClickTableViewCell *)cell;
            returnCell.titleLabel.text = self.authoInfosArray[indexPath.section][indexPath.row][0];
            
            if (self.parametersDic[@"pid"] || self.parametersDic[@"id"]|| self.pid) {//如果不是自建项目并且是前三行，就不能点击
                returnCell.detailTF.userInteractionEnabled = NO;
            }
            
            [self setRegisterClickCellDetailTF:returnCell indexPath:indexPath];
            returnCell.indexPath = indexPath;
            return returnCell;
        }
            break;
        case 3:
        {
            cell = [JLGAddProExperienceTableViewCell cellWithTableView:tableView];
            JLGAddProExperienceTableViewCell *returnCell = (JLGAddProExperienceTableViewCell *)cell;
            
            returnCell.delegate = self;
            returnCell.imagesArray = self.imagesArray;

            __weak typeof(self) weakSelf = self;
            returnCell.deleteCallBack = ^(JLGPhoneCollection *collectionCell, NSInteger index){
                [weakSelf removeImageAtIndex:index];
                
                //取出url
                __block NSMutableArray *deleteUrlArray = [NSMutableArray array];
                [collectionCell.deleteImgsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[NSString class]]) {
                        [deleteUrlArray addObject:obj];
                    }
                }];
                [weakSelf.deleteImgsArray addObjectsFromArray:deleteUrlArray];
                [weakSelf.tableView reloadData];
            };
            
            return returnCell;
        }
        break;
        case 4:
            {
                JLGSendProjectTableViewCell *returnCell = [JLGSendProjectTableViewCell cellWithTableView:tableView];
                returnCell.delegate = self;
                returnCell.titleString = @"保存";
                returnCell.backgroundColor = [UIColor whiteColor];

                return returnCell;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)setRegisterInfoCellDetailTF:(JLGRegisterInfoTableViewCell *)returnCell indexPath:(NSIndexPath *)indexPath{
    NSString *keyString = self.addProExperienceInfo[[self getKeyByIndexPath:indexPath]];
    //设置显示的内容
    if (keyString) {
        returnCell.detailTF.text = keyString;
    }else{
        returnCell.detailTF.placeholder = self.authoInfosArray[indexPath.section][indexPath.row][1];
    }
}

- (void )setRegisterClickCellDetailTF:(JLGRegisterClickTableViewCell *)returnCell indexPath:(NSIndexPath *)indexPath{
    NSString *keyString = self.addProExperienceInfo[[self getKeyByIndexPath:indexPath]];
    //设置显示的内容
    if (keyString) {
        returnCell.detailTF.text = keyString;
        returnCell.detailTF.textColor = AppFont999999Color;
    }else{
        returnCell.detailTF.text = self.authoInfosArray[indexPath.section][indexPath.row][1];
        returnCell.detailTF.textColor = TYColorHex(0xb9b9b9);
    }
}

- (void)blockWithCell:(JLGRegisterInfoTableViewCell *)returnCell{
    __weak typeof(self) weakSelf = self;
    
    //beginEdit
    [returnCell beginEditWithBlock:^{
        [weakSelf.cityPickerView hiddenCityPicker];
    }];
    
    //endEdit
    [returnCell endEditWithBlock:^(NSIndexPath *indexPath, NSString *detailTFStr) {
        NSString *key = [self getKeyByIndexPath:indexPath];
        weakSelf.addProExperienceInfo[key] = detailTFStr;
        weakSelf.parametersDic[key] = detailTFStr;
    }];
}

//cell的选择操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self subClassTableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)subClassTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.parametersDic[@"pid"] || self.parametersDic[@"id"]) {//不是自建项目
        return;
    }
    
    //第0个和最后一个不用弹出
    if (indexPath.row == 0 && indexPath.row == 3) {
        return;
    }
    
    if(indexPath.row == 1){
        self.cityPickerView.onlyShowCitys = NO;
        [self.cityPickerView showCityPickerByIndexPath:indexPath];
    }else if(indexPath.row == 2){
        NSIndexPath *cityIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        if (!self.addProExperienceInfo[[self getKeyByIndexPath:cityIndexPath]]) {
            [TYShowMessage showPlaint:@"请选择所在地区"];
            return ;
        }
        
        //取出城市
        if (!self.searchVc) {
            self.searchVc = [[UIStoryboard storyboardWithName:@"ManageProject" bundle:nil] instantiateViewControllerWithIdentifier:@"geosearch"];
        }
        
//        NSArray *cityArray = [self.addProExperienceInfo[[self getKeyByIndexPath:cityIndexPath]] componentsSeparatedByString:@"  "];
//        NSString *cityName = cityArray[1];
//        self.searchVc.cityName = [cityName substringWithRange:NSMakeRange(0, cityName.length - 1)];
//        
//        self.searchVc.delegate = self;
        [self presentViewController:self.searchVc animated:YES completion:nil];
    }
    
    [self.view endEditing:YES];
}

#pragma mark - 选择完地址
- (void)searchVcCancel{
    self.searchVc.delegate = nil;
    [self.searchVc dismissViewControllerAnimated:YES completion:^{}];
}

- (void)searchVcSelectLocation:(NSString *)location addressName:(NSString *)addressName{
    self.searchVc.delegate = nil;
    __weak typeof(self) weakSelf = self;
    [self.searchVc dismissViewControllerAnimated:YES completion:^{
        weakSelf.addProExperienceInfo[@"proaddress"] = addressName;
        weakSelf.parametersDic[@"proaddress"] = addressName;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        weakSelf.addProExperienceInfo[@"pro_location"] = location;
    }];
}

- (NSString *)getKeyByIndexPath:(NSIndexPath *)indexPath{
    NSString *key;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                key = @"proname";
                break;
            case 1:
                key = @"regionname";
                break;
            case 2:
                key = @"proaddress";
                break;
        }
    }
    
    return key;
}

#pragma mark - 选择完城市以后
- (void )JLGCityPickerSelect:(NSDictionary *)cityDic byIndexPath:(NSIndexPath *)indexPath{
//    返回的家乡
    self.parametersDic[[self getKeyByIndexPath:indexPath]] = cityDic[@"cityCode"];
    self.addProExperienceInfo[[self getKeyByIndexPath:indexPath]] = cityDic[@"cityName"];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

//#pragma mark - 点击图片
- (void )CollectionCellDidSelected:(NSUInteger )cellIndex imageIndex:(NSUInteger )imageIndex{
    if (imageIndex >= self.maxImageCount) {
        [TYShowMessage showPlaint:@"最多可以上传9张图片"];
        return ;
    }
    
    self.imageSelectedIndex = imageIndex;
    //上传图片
    if (imageIndex == self.imagesArray.count) {
        [self.sheet showInView:self.view];
    }else{//点击其他图片
        [self pushPhotoBroswerWithStyle:LGShowImageTypeImageURL];
    }
}

- (void)phoneVc:(UIPhotoViewController *)phoneVc imagesArrayAddEnd:(NSArray *)imagesArr{
    [self.tableView reloadData];
    [TYNotificationCenter postNotificationName:@"freashImage" object:nil];

}

//点击按钮
-(void)sendProjectCellBtnClick{
    [self saveBtnClick:nil];
}

- (IBAction)saveBtnClick:(UIButton *)sender {

    if (!(self.parametersDic[@"pid"] || self.parametersDic[@"id"])) {//如果是自建的才检查
        if (!self.parametersDic[@"proname"]) {
            [TYShowMessage showPlaint:@"请输入项目名称"];
            return;
        }
        

        if (!self.parametersDic[@"regionname"]) {
            [TYShowMessage showPlaint:@"请选择所在地区"];
            return;
        }else{//V1.4 region和regionname有点混乱，获取的
            self.parametersDic[@"region"] = self.parametersDic[@"regionname"];
            [self.parametersDic removeObjectForKey:@"regionname"];
        }
        
        if (!self.parametersDic[@"proaddress"]) {
            [TYShowMessage showPlaint:@"请输入街道地址"];
            return;
        }
    }

    [TYLoadingHub showLoadingWithMessage:@""];
    __weak typeof(self) weakSelf = self;
    __block NSMutableArray *imagesArray = [NSMutableArray array];
    [self.imagesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {//获取需要增加的图片
            [imagesArray addObject:obj];
        }
    }];
    
    self.imagesArray = [imagesArray mutableCopy];;
    
    if (self.deleteImgsArray.count > 0) {
        self.parametersDic[@"delimg"] = [self.deleteImgsArray componentsJoinedByString:@";"] ;
    }
    
    [JLGHttpRequest_AFN uploadImagesWithApi:@"jlwork/showskill" parameters:self.parametersDic imagearray:self.imagesArray success:^(id responseObject) {

        UIViewController *proExperVc = [weakSelf.navigationController.viewControllers objectAtIndex:(weakSelf.navigationController.viewControllers.count - 2)];
        
        //如果上一个界面是项目经验，就刷新
        Class ProExperienceVc = NSClassFromString(@"JLGProExperienceViewController");
        if ([proExperVc isKindOfClass:[ProExperienceVc class]]) {
            SEL selector = NSSelectorFromString(@"proExperienceLoadNewData");
            IMP imp = [proExperVc methodForSelector:selector];
            void(*func)(id, SEL) = (void *)imp;
            func(proExperVc, selector);
        }
        
        [weakSelf.navigationController popToViewController:proExperVc animated:YES];
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showSuccess:@"保存成功!"];
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showError:@"提交失败"];
    }];
}

#pragma mark - 懒加载
- (NSMutableDictionary *)parametersDic
{
    if (!_parametersDic) {
        _parametersDic = [[NSMutableDictionary alloc] init];
    }
    return _parametersDic;
}

- (NSMutableDictionary *)addProExperienceInfo
{
    if (!_addProExperienceInfo) {
        _addProExperienceInfo = [[NSMutableDictionary alloc] init];
    }
    return _addProExperienceInfo;
}

- (NSArray *)authoInfosArray
{
    if (!_authoInfosArray) {
        _authoInfosArray = @[@[
                                @[@"项目名称:",@"请输入项目名称"],
                                @[@"具体地址:",@"请选择所在省市"],
                                @[@"街道地址:",@"请输入街道地址"]
                            ]];
    }
    return _authoInfosArray;
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

- (NSMutableArray *)deleteImgsArray
{
    if (!_deleteImgsArray) {
        _deleteImgsArray = [[NSMutableArray alloc] init];
    }
    return _deleteImgsArray;
}


@end
