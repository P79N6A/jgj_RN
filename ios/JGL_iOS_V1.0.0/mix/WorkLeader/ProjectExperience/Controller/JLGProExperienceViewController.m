//
//  JLGProExperienceViewController.m
//  mix
//
//  Created by jizhi on 15/12/10.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGProExperienceViewController.h"
#import "MJRefresh.h"
#import "TYShowMessage.h"
#import "JLGBGImagesView.h"
#import "UITableViewCell+Extend.h"
#import "JLGMYProExperienceTableViewCell.h"
#import "JLGAddProExperienceViewController.h"
#import "YZGNoProExperienceDefaultTableViewCell.h"

@interface JLGProExperienceViewController ()
<
    UIActionSheetDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    JLGMYProExperienceTableViewCellDelegate,
    YZGNoProExperienceDefaultTableViewCellDelegate
>
{
    NSInteger _cellIndex;//记录选中的是第几个cell
}

@property (nonatomic, assign) NSUInteger pageNum;
@property (nonatomic, assign) LGShowImageType showType;
@property (nonatomic, strong) NSMutableArray *projectsArray;
@property (nonatomic, strong) JLGBGImagesView *jlgBGImagesView;
@property (nonatomic, strong) NSMutableDictionary *parametersDic;


@property (nonatomic,   copy) NSString *identifierStr;
@property (nonatomic, strong) JLGMYProExperienceTableViewCell *prototypeCell;
@property (nonatomic,   weak) IBOutlet UITableView *tableView;
@end

@implementation JLGProExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(proExperienceLoadNewData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(proExperienceLoadMoreData)];

    //注册cell的ID;
    self.identifierStr = NSStringFromClass([JLGMYProExperienceTableViewCell class]);
    UINib *cellNib = [UINib nibWithNibName:self.identifierStr bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:self.identifierStr];
    self.prototypeCell  = [self.tableView dequeueReusableCellWithIdentifier:self.identifierStr];
    
    [self.tableView.mj_header beginRefreshing];
    self.maxImageCount = 9;
    self.tableView.hidden = YES;
}

- (void)proExperienceLoadNewData{
    self.pageNum = 1;
    [self JLGHttpRequest:YES];
}

- (void)proExperienceLoadMoreData{
    [self JLGHttpRequest:NO];
}


- (void)JLGHttpRequest:(BOOL )loadNewData{
    [TYLoadingHub showLoadingWithMessage:@""];
    self.parametersDic[@"pg"] = @(self.pageNum);
    __weak typeof(self) weakSelf = self;

    [JLGHttpRequest_AFN PostWithApi:@"jlwork/getproexperience" parameters:self.parametersDic success:^(NSArray *responseObject) {
        if (responseObject) {
            loadNewData?[weakSelf.projectsArray removeAllObjects]:nil;//如果是获取新数据
            [responseObject enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                JLGProjectModel *jlgProjectModel = [[JLGProjectModel alloc] init];
                [jlgProjectModel setValuesForKeysWithDictionary:obj];
                [weakSelf.projectsArray addObject:jlgProjectModel];
            }];
            
            if (responseObject.count > 0) {
                ++weakSelf.pageNum;
            }
        }
        
        if (weakSelf.tableView.hidden == YES) {
            weakSelf.tableView.hidden = NO;
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [TYLoadingHub hideLoadingView];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - tableView
//cell数量
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.projectsArray.count > 0? self.projectsArray.count:1;
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果没有数据的处理情况
    if (self.projectsArray.count < 1) {
        YZGNoProExperienceDefaultTableViewCell *returnCell = [YZGNoProExperienceDefaultTableViewCell cellWithTableView:tableView];
        returnCell.delegate = self;
        
        return returnCell;
    }
    
    JLGMYProExperienceTableViewCell *cell = [JLGMYProExperienceTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.isGetCellHeight = NO;
    cell.hiddenAddButton = YES;
    cell.jlgProjectModel = self.projectsArray[indexPath.row];

    cell.hiddenTopLine = indexPath.row == 0;
    cell.showBottomPointView = indexPath.row == self.projectsArray.count - 1;

    return cell;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.projectsArray.count < 1) {
        return tableView.size.height;
    }
    
    JLGProjectModel *jlgProjectModel = self.projectsArray[indexPath.row];
    JLGMYProExperienceTableViewCell *cell = (JLGMYProExperienceTableViewCell *)self.prototypeCell;

    cell.hiddenAddButton = YES;
    cell.isGetCellHeight = YES;
    cell.jlgProjectModel = jlgProjectModel;
    
    if (indexPath.row == (self.projectsArray.count - 1)) {
        return cell.cellHeight + LastCellExtraHeight;
    }else{
        return cell.cellHeight;
    }
}

#pragma mark - 点击cell里面的图片
- (void )CollectionCellDidSelected:(NSUInteger )cellIndex imageIndex:(NSUInteger )imageIndex{
    if (imageIndex >= 9) {
        [TYShowMessage showPlaint:@"最多可以上传9张图片"];
        return ;
    }
    
    _cellIndex = cellIndex;
    self.imageSelectedIndex = imageIndex;

    //上传照片的情况
    JLGProjectModel *jlgProjectModel = self.projectsArray[cellIndex];
    if (imageIndex == jlgProjectModel.imgs.count) {
        _cellIndex = cellIndex;
        self.imageSelectedIndex = imageIndex;
        [self.sheet showInView:self.view];
        return ;
    }
    
    [self pushPhotoBroswerWithStyle:LGShowImageTypeImageURL];
}

#pragma mark - 修改项目经验
- (void)CollectionCellEdit:(NSUInteger)cellIndex{
    JLGProjectModel *jlgProjectModel = self.projectsArray[cellIndex];
    JLGAddProExperienceViewController *addProExper = [[UIStoryboard storyboardWithName:@"MateMine" bundle:nil] instantiateViewControllerWithIdentifier:@"JLGAddProExperienceViewController"];

    addProExper.isBackLevel = YES;
    addProExper.pid = [NSString stringWithFormat:@"%@",@(jlgProjectModel.pid)];
    addProExper.parametersDic[@"pid"] = [NSString stringWithFormat:@"%@",@(jlgProjectModel.pid)];
    addProExper.parametersDic[@"id"] = [NSString stringWithFormat:@"%@",@(jlgProjectModel.proid)];
    addProExper.parametersDic[@"proaddress"] =  jlgProjectModel.proaddress;
    addProExper.parametersDic[@"proname"] = jlgProjectModel.proname;
    addProExper.parametersDic[@"region"] = @(jlgProjectModel.region);
    addProExper.parametersDic[@"regionname"] = jlgProjectModel.regionname;
    addProExper.addProExperienceInfo[@"proaddress"] =  jlgProjectModel.proaddress;
    addProExper.addProExperienceInfo[@"proname"] = jlgProjectModel.proname;
    addProExper.addProExperienceInfo[@"region"] = @(jlgProjectModel.region);
    addProExper.addProExperienceInfo[@"regionname"] = jlgProjectModel.regionname;
    addProExper.imageUrlArray = [jlgProjectModel.imgs copy];

    [self.navigationController pushViewController:addProExper animated:YES];
}

#pragma mark - 没有数据的时候，发布项目经验
- (void )NoProExperienceAddProExperience:(YZGNoProExperienceDefaultTableViewCell *)noProExperienceCell{
    UIViewController *proExperienceDetailVc = [[UIStoryboard storyboardWithName:@"MateMine" bundle:nil]
                                               instantiateViewControllerWithIdentifier:@"JLGAddProExperienceViewController"];
    [self.navigationController pushViewController:proExperienceDetailVc animated:YES];
}

#pragma mark 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // info中就包含了选择的图片
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    
    //隐藏当前的模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self uploadImage:@[image]];
}

- (void)uploadImage:(NSArray *)imgesArray{
    [TYLoadingHub showLoadingWithMessage:@""];
    __block JLGProjectModel *jlgProjectModel = self.projectsArray[_cellIndex];
    
    __block NSMutableArray *imgsArray = [jlgProjectModel.imgs mutableCopy];
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    
    parametersDic[@"proname"] = jlgProjectModel.proname;
    parametersDic[@"proaddress"] = jlgProjectModel.proaddress;
    parametersDic[@"region"] = @(jlgProjectModel.region);
    parametersDic[@"pid"] = @(jlgProjectModel.pid);
    parametersDic[@"id"] = @(jlgProjectModel.proid);
    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN uploadImagesWithApi:@"jlwork/showskill" parameters:parametersDic imagearray:[imgesArray mutableCopy] success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showSuccess:@"发布成功"];

        [imgsArray addObjectsFromArray:responseObject];
        jlgProjectModel.imgs = [imgsArray copy];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_cellIndex inSection:0];
        [weakSelf.projectsArray replaceObjectAtIndex:_cellIndex withObject:jlgProjectModel];
        
        [TYShowMessage hideHUD];
        //重新加载
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

//懒加载
- (JLGBGImagesView *)jlgBGImagesView
{
    if (!_jlgBGImagesView) {
        CGRect frame = self.tableView.frame;
        _jlgBGImagesView = [[JLGBGImagesView alloc] initWithFrame:frame];
    }
    return _jlgBGImagesView;
}

/**
 *  初始化相册选择器
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    self.pickerVc.selectPickers = self.selectedAssets;
    
    JLGProjectModel *jlgProjectModel = self.projectsArray[_cellIndex];
    self.pickerVc.showType = style;
    self.pickerVc.maxCount = self.maxImageCount - jlgProjectModel.imgs.count;// 最多能选N张图片
    [self.pickerVc showPickerVc:self];
}

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    NSMutableArray *imagesArray = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^( LGPhotoAssets *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imagesArray addObject:obj.YZGGetImage];
    }];
    [self uploadImage:imagesArray];
}

#pragma mark - LGPhotoPickerBrowserViewControllerDataSource
- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    JLGProjectModel *jlgProjectModel = self.projectsArray[_cellIndex];
    return jlgProjectModel.imgs.count;
}

- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    
    JLGProjectModel *jlgProjectModel = self.projectsArray[_cellIndex];
    
    NSMutableArray *LGPhotoPickerBrowserURLArray = [[NSMutableArray alloc] init];
    for (NSString *picUrl in jlgProjectModel.imgs) {
        LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
        NSString *finalPicUrl = [JLGHttpRequest_Public stringByAppendingString:picUrl];
        photo.photoURL = [NSURL URLWithString:finalPicUrl];
        [LGPhotoPickerBrowserURLArray addObject:photo];
    }
    return [LGPhotoPickerBrowserURLArray objectAtIndex:indexPath.item];
}

#pragma mark - 懒加载
- (NSMutableArray *)projectsArray
{
    if (!_projectsArray) {
        _projectsArray = [NSMutableArray array];
    }
    return _projectsArray;
}

- (NSMutableDictionary *)parametersDic
{
    if (!_parametersDic) {
        _parametersDic = [NSMutableDictionary dictionary];
    }
    return _parametersDic;
}

@end
