//
//  JGJModifyInfoVc.m
//  mix
//
//  Created by yj on 2018/6/11.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJModifyInfoVc.h"

#import "JGJCustomAlertView.h"

#import "JGJPushContentCell.h"

#import "JGJCustomLable.h"

#import "UILabel+GNUtil.h"

#import "JGJNineAvatarCell.h"

#import "JGJModifyInfoCell.h"

#import "JGJSelPhotoTool.h"

@interface JGJModifyInfoVc ()<JGJNineAvatarCellDelegate>

@property (nonatomic, strong) JGJModifyInfoModel *desModel;

//@property (nonatomic, strong) JGJCusNineAvatarView *avatarView;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) JGJNineAvatarCell *avatarCell;

//选择照片工具

@property (nonatomic, strong) JGJSelPhotoTool *selPhotoTool;


@end

@implementation JGJModifyInfoVc

@synthesize dataSource = _dataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveItemPressed)];
//
//    [self.view addSubview:self.tableView];
//
//    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    
    self.title = @"修改信息";
    
    [self.tableView reloadData];
    
    JGJNineAvatarCell *avatarCell = [JGJNineAvatarCell cellWithTableView:self.tableView];
    
    self.avatarCell = avatarCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 60;
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            height = TYGetUIScreenWidth < 375 ? 170 : 150;
            
        }else if (indexPath.row == 1) {
            
            height = [JGJCusNineAvatarView avatarViewHeightWithPhotoCount:self.photos.count];
                        
            TYLog(@"height----%@,count------%@", @(height),@(self.photos.count));
            
        }
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JGJCustomLable *headerLable = nil;
    
    if (section == 1) {
        
        headerLable = [[JGJCustomLable alloc] initWithFrame:CGRectMake(10, 0, TYGetUIScreenWidth, 33)];
        
        headerLable.textInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        headerLable.textColor = AppFont333333Color;
        
        headerLable.font = [UIFont systemFontOfSize:AppFont28Size];
        
        headerLable.text = @"添加备注(最多200个字)";
        
        [headerLable markText:@"(最多200个字)" withFont:[UIFont systemFontOfSize:AppFont24Size] color:AppFont666666Color];
        
    }

    headerLable.backgroundColor = AppFontf1f1f1Color;
    
    return headerLable;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat height = CGFLOAT_MIN;
    
    if (section == 1) {
        
        height = 33;
    }
    
    return height;
}

#pragma mark - 子类使用确定行数
- (NSInteger)numberOfRowWithSection:(NSInteger)section {
    
    NSInteger count = self.memberModel.is_not_telph ? self.dataSource.count - 1 : self.dataSource.count;
    
    if (section == 1) {
        
        count = 2;
    }
    
    return count;
}

#pragma mark - 重写父类的方法

- (UITableViewCell *)registerSubOtherCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [UITableViewCell cellWithTableViewNotXib:tableView];
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            cell = [self registerModifyRemarkCellWithCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
            
        }else if (indexPath.row == 1) {
            
            cell = [self registerNineAvatarCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }
    }
    
    return cell;
    
}


- (UITableViewCell *)registerModifyRemarkCellWithCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJPushContentCell *contentCell = [JGJPushContentCell cellWithTableView:tableView];
    
    contentCell.lineView.hidden = YES;
    
    contentCell.maxContentWords = 200;
    
    contentCell.placeholderText = @"请输入备注内容";
    
    TYWeakSelf(self);
    
    contentCell.pushContentCellBlock = ^(YYTextView *textView) {
        
        if (weakself.dataSource.count > 0) {
            
            JGJCommonInfoDesModel *remarkDesModel = weakself.dataSource.firstObject;
            
            remarkDesModel.notes_txt = textView.text;
        }
        
    };
    
    if (![NSString isEmpty:self.mangerModel.notes_txt]) {

        contentCell.checkRecordDefaultText = self.mangerModel.notes_txt;

    }
    
    return contentCell;
    
}

- (UITableViewCell *)registerNineAvatarCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    JGJNineAvatarCell *cell = [JGJNineAvatarCell cellWithTableView:tableView];
    
    JGJNineAvatarCell *cell = self.avatarCell;
    
    cell.isShowAddBtn = YES;
        
    cell.delegate = self;
    
    cell.photos = self.photos;
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

#pragma mark - 点击编辑框以后的键盘位置
- (void)CollectionCellTouch{
    
    [self.view endEditing:YES];
}

- (void)nineAvatarCell:(JGJNineAvatarCell *)cell avatarView:(JGJCusNineAvatarView *)avatarView checkView:(JGJCusCheckView *)checkView {
    
//    self.avatarView = avatarView;
    
    self.photos = avatarView.photos.mutableCopy;
    
    _selPhotoTool.photos = avatarView.photos.mutableCopy;
    
    TYLog(@"选择图片_selPhotoTool.photos----%@  self.photos===%@", _selPhotoTool.photos, @(self.photos.count));
    
    if (checkView.is_sel_photo) {
        
         [self.selPhotoTool showSelPhotoTool];
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self.tableView beginUpdates];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
    
}

#pragma mark - 保存成员信息按下
- (void)saveMemberInfoItemPressed {
    
    TYWeakSelf(self);
    
    [self.view endEditing:YES];
    
    [self uploadSelImage:^(JGJCommonInfoDesModel *remarkDesModel) {
       
//        JGJCommonInfoDesModel *nameDesModel = self.dataSource.firstObject;
        
        if (weakself.modifyInfoBlock) {
            
            weakself.modifyInfoBlock(remarkDesModel);
            
        }
        
    }];
    
    
}

- (void)uploadSelImage:(JGJModifyInfoBlock)modifyInfoBlock {
    
//    [JLGHttpRequest_AFN newUploadImagesWithApi:@"file/upload" parameters:nil imagearray:theLeftImage otherDataArray:nil dataNameArray:nil success:^(id responseObject) {
    
    NSMutableArray *images = [NSMutableArray array];
    
    NSMutableArray *imageUrls = [NSMutableArray array];
    
    for (UIImage *image in self.photos) {
        
        if ([image isKindOfClass:[UIImage class]]) {
            
            [images addObject:image];
            
        }else if ([image isKindOfClass:[NSString class]]) {
            
            [imageUrls addObject:image];
        }
    }
    
    if (images.count == 0) {
        
        JGJCommonInfoDesModel *remarkDesModel = self.dataSource.firstObject;
        
        if (imageUrls.count > 0) {
            
            NSString *exist_img = [imageUrls componentsJoinedByString:@","];
            
            remarkDesModel.notes_img = exist_img;
            
        }
        
        if (modifyInfoBlock) {
            
            modifyInfoBlock(remarkDesModel);
        }
        
        return;
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN newUploadImagesWithApi:@"file/upload" parameters:nil imagearray:images otherDataArray:nil dataNameArray:nil success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        if (modifyInfoBlock) {
            
            NSArray *imgs = (NSArray *)responseObject;
            
            NSMutableString *notes_img = [NSMutableString string];
            
            if (imageUrls.count > 0) {
                
                NSString *exist_img = [imageUrls componentsJoinedByString:@","];
                
                [notes_img appendString:exist_img];
                
                [notes_img appendString:@","];
            }
            
            if ([imgs isKindOfClass:[NSArray class]]) {
                
                NSString *upload_img = [imgs componentsJoinedByString:@","];
                
                [notes_img appendString:upload_img];
                
            }
            
            JGJCommonInfoDesModel *remarkDesModel = self.dataSource.firstObject;
            
            remarkDesModel.notes_img = notes_img;
            
            modifyInfoBlock(remarkDesModel);
        }
        
    } failure:^(NSError *error) {
       
        [TYLoadingHub hideLoadingView];
        
    }];
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
        
        NSArray *titles = @[@"工人姓名", @"工人电话"];
        
        NSArray *desTitles = @[@"请输入工人的姓名", @"请输入工人的电话号码"];
        
        if (JLGisMateBool) {
            
            titles = @[@"班组长姓名", @"班组长电话"];
            
            desTitles = @[@"请输入班组长的姓名", @"请输入班组长的电话号码"];
        }
        
        for (NSInteger index = 0; index < titles.count; index++) {
            
            JGJCommonInfoDesModel *desModel = [[JGJCommonInfoDesModel alloc] init];
            
            desModel.desType = index == 0 ? JGJCommonInfoDesNameType : JGJCommonInfoTelType;
            
            desModel.title = titles[index];
            
            if (index == 0) {
               
                if (![NSString isEmpty:self.memberModel.name]) {
                    
                    desModel.des = self.memberModel.name;
                    
                }
            
            }
            
            if (titles.count - 1 == index && !self.memberModel.is_not_telph) {
                
                desModel.placeholder = self.memberModel.telephone;
                
                desModel.isUnCanEdit = YES;
                
            }else {
            
                desModel.placeholder = desTitles[index];
            }
            
            [_dataSource addObject:desModel];
            
        }
        
    }
    
    return _dataSource;
}

#pragma mark - 子类使用
- (void)registerSubClassWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
   
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            
            NSString *role = JLGisLeaderBool ? @"工人" :@"班组长";
            
            NSString *des = [NSString stringWithFormat:@"%@电话无法修改哦，如果该%@换了电话，可以重新添加新的电话号码为他记工。",role, role];
            
            [JGJCustomAlertView customAlertViewShowWithMessage:des];
            
        }
        
    }
    
}

- (JGJSelPhotoTool *)selPhotoTool {
    
    if (!_selPhotoTool) {
        
        TYWeakSelf(self);
        
        NSInteger maxImageCount = 8;
        
        _selPhotoTool = [JGJSelPhotoTool selPhotoWithTargetVc:self selPhotosBlock:^(NSArray * _Nonnull photos) {
            
            TYLog(@"photos----%@", photos);
            
            NSInteger maxCount = weakself.photos.count + photos.count;
            
            if (maxCount > maxImageCount) {
                
                [TYShowMessage showPlaint:@"最多只能上传8张照片"];
                
                return ;
            }
            
            [weakself.photos addObjectsFromArray:photos];
            
            [weakself.tableView reloadData];
            
        }];
        
        _selPhotoTool.maxImageCount = maxImageCount;
    }
    
    return _selPhotoTool;
}

- (NSMutableArray *)photos {
    
    if (!_photos) {
        
        _photos = [[NSMutableArray alloc] init];
        
        if (self.mangerModel.notes_img.count > 0) {
            
            [_photos addObjectsFromArray:self.mangerModel.notes_img];
            
        }
    
    }
    
    return _photos;
}

@end
