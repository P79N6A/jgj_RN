//
//  JGJNotepadEditeViewController.m
//  mix
//
//  Created by Tony on 2018/4/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJNotepadDetailInfoViewController.h"
#import "YYText.h"
#import "JGJCusActiveSheetView.h"
#import "JGJAddNewNotepadViewController.h"
#import "JGJCustomPopView.h"
#import "NSString+Extend.h"
#import "YYTextContainerView.h"
#import "JLGAddProExperienceTableViewCell.h"

#import "JGJNotePostToolView.h"

#import "JGJNineAvatarCell.h"

@interface JGJNotepadDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource,JLGMYProExperienceTableViewCellDelegate, JGJNotePostToolViewDelegate,JGJNineAvatarCellDelegate>
{
    
    CGFloat _textHeight;
}
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UITableView *contentViewTableView;// 内容和图片
@property (nonatomic, strong) YYTextView *contentView;
@property (nonatomic, strong) UIButton *editeBtn;

//底部工具栏(标记重要、拍照)
@property (nonatomic, strong) JGJNotePostToolView *toolView;

@property (nonatomic, strong) JGJNineAvatarCell *avatarCell;

@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation JGJNotepadDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = AppFontffffffColor;
    [self setRightBarItem];
    
    [self initializeAppearance];
    
    //底部工具栏
    [self.view addSubview:self.toolView];
    
    JGJNineAvatarCell *avatarCell = [JGJNineAvatarCell cellWithTableView:self.tableView];
    
    self.avatarCell = avatarCell;
    
    NSArray *timeArr = [_noteModel.publish_time componentsSeparatedByString:@" "];
    
    if (timeArr.count > 0) {
        
        NSArray *yearMDArr = [timeArr[0] componentsSeparatedByString:@"-"];
        
        if (yearMDArr.count > 1) {
            
            self.title = [NSString stringWithFormat:@"%@年%@月%@日 %@",yearMDArr[0],[yearMDArr[1] stringByReplacingOccurrencesOfString:@"0" withString:@""],yearMDArr[2],_noteModel.weekday];
            
        }
        
    }
    
}

- (void)setRightBarItem {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.line];
    [self.view addSubview:self.contentViewTableView];
//    [self.view addSubview:self.editeBtn];
    
    [self setUpLayout];
    
    [self getNoteDetail];
}


- (void)setUpLayout {
    
    _line.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(1);
    _contentViewTableView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(_line, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, self.toolView.height);
//    _editeBtn.sd_layout.rightSpaceToView(self.view, 10).bottomSpaceToView(self.view, 25).widthIs(80).heightIs(80);
}

- (void)getNoteDetail {
    
    [TYLoadingHub showLoadingWithMessage:@""];
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{
                            @"id":@(self.noteModel.noteId),
                            };
    
    [JLGHttpRequest_AFN PostWithNapi:@"notebook/get-one" parameters:param success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        self.contentView.text = responseObject[@"content"];
        
        
        NSMutableAttributedString *text = [self.contentView.attributedText mutableCopy];
        text.yy_lineSpacing = 8;
        self.contentView.attributedText = text;

        // 计算出文字高度加上内边距
        _textHeight = [NSString stringWithYYContentWidth:TYGetUIScreenWidth - 30 font:AppFont32Size lineSpace:8 content:self.contentView.text] + 30;
        
        if ([responseObject[@"images"] isKindOfClass:[NSString class]]) {
            
            if ([responseObject[@"images"] length] != 0) {
                
                self.imagesArray = [[NSMutableArray alloc] initWithArray:[responseObject[@"images"] componentsSeparatedByString:@","]];
                
            }
        }else {
            
            if ([responseObject[@"images"] count] != 0) {
                
                self.imagesArray = [[NSMutableArray alloc] initWithArray:responseObject[@"images"]];
                
            }
        }
        
        [weakSelf.contentViewTableView reloadData];
        
        weakSelf.noteModel.content = responseObject[@"content"];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)setNoteModel:(JGJNotepadListModel *)noteModel {
    
    _noteModel = noteModel;
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.imagesArray.count == 0) {
        
        return 0;
        
    }else {
        
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    JLGAddProExperienceTableViewCell *returnCell = [JLGAddProExperienceTableViewCell cellWithTableView:tableView];
//    returnCell.delegate = self;
//    returnCell.imagesArray = self.imagesArray.mutableCopy;
//    returnCell.imagesCollectionCell.imagesCollection.directionalLockEnabled = NO;
//    returnCell.imagesCollectionCell.hiddenAddButton = YES;
//    returnCell.imagesCollectionCell.showDeleteButton = NO;
    
    UITableViewCell *cell = [self registerNineAvatarCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)CollectionCellDidSelected:(NSUInteger)cellIndex imageIndex:(NSUInteger)imageIndex {
    
    LGPhotoPickerBrowserViewController *broswerVC = [[LGPhotoPickerBrowserViewController alloc] init];
    broswerVC.delegate = self;
    broswerVC.dataSource = self;
    broswerVC.showType = LGShowImageTypeImageURL;
    broswerVC.imageSelectedIndex = imageIndex;
    [self presentViewController:broswerVC animated:YES completion:nil];
}
#pragma mark - 图片浏览器
- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{

    return self.imagesArray.count;
}

- (UITableViewCell *)registerNineAvatarCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    JGJNineAvatarCell *cell = [JGJNineAvatarCell cellWithTableView:tableView];
    
    JGJNineAvatarCell *cell = self.avatarCell;
    
    cell.isShowAddBtn = NO;
    
    cell.isCheckImage = YES;
    
    cell.delegate = self;
    
    if (self.photos.count > 0) {
        
        cell.photos = self.photos;
        
    }
    
    return cell;
}

- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{


    NSMutableArray *LGPhotoPickerBrowserArray = [[NSMutableArray alloc] init];

    [self.imagesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];

        NSString *finalPicUrl = [JLGHttpRequest_Public stringByAppendingString:obj];
        photo.photoURL = [NSURL URLWithString:finalPicUrl];

        [LGPhotoPickerBrowserArray addObject:photo];
    }];

    return [LGPhotoPickerBrowserArray objectAtIndex:indexPath.item];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    JLGAddProExperienceTableViewCell *cell = [JLGAddProExperienceTableViewCell new];
//    CGFloat height = [cell getHeightWithImagesArray:self.imagesArray];
    
    CGFloat height = [JGJCusNineAvatarView avatarViewHeightWithPhotoCount:self.photos.count];
    
    return height;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return _textHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    self.contentView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(_textHeight);
    
    return self.contentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

#pragma mark - method
- (void)rightItemClick {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.leftTilte = @"取消";
    
    desModel.rightTilte = @"确认";
    
    JGJCustomPopView *alertView = nil;
    
    if (self.noteModel.is_import) {
        
        desModel.popDetail = @"该条记录已标记为重要，删除后不能找回，确认删除该记录吗？";
        alertView = [JGJCustomPopView showWithMessage:desModel];
        alertView.messageLable.textAlignment = NSTextAlignmentLeft;
        
    }else {
        
        desModel.popDetail = @"是否确认删除该记录？";
        alertView = [JGJCustomPopView showWithMessage:desModel];
        alertView.messageLable.textAlignment = NSTextAlignmentCenter;
        
    }
    
    __weak typeof(self) weakSelf = self;
    alertView.onOkBlock = ^{
        
        [TYLoadingHub showLoadingWithMessage:@""];
        
        NSDictionary *param = @{
                                @"id":@(_noteModel.noteId)
                                };
        
        [JLGHttpRequest_AFN PostWithNapi:@"notebook/delete-one" parameters:param success:^(id responseObject) {
            
            [TYLoadingHub hideLoadingView];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTheNotepadList" object:nil];
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub hideLoadingView];
        }];
    };

}

// 开始编辑记事内容
- (void)editeTheNotepad {
 
    JGJAddNewNotepadViewController *addController = [[JGJAddNewNotepadViewController alloc] init];
    addController.isEditeNotepad = YES;
    addController.noteModel = _noteModel;
    addController.tagVC = self;
    addController.orignalImgArr = [[NSMutableArray alloc] initWithArray:self.imagesArray.copy];
    [self presentViewController:addController animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - JGJNotePostToolViewDelegate

- (void)notePostToolView:(JGJNotePostToolView *)toolView buttonType:(JGJNotePostToolViewButtonType)buttonType button:(UIButton *)button {
    
    switch (buttonType) {
            
        case JGJNotePostMarkImportButtonType: {//标记重要
        
            [self markImportButtonPressed:button];

        }
            
            break;
            
        case JGJNotePostMarkPhotoButtonType: {//修改按钮
            
            [self editeTheNotepad];
        }
            
            break;
            
        default:
            break;
    }
    
}

- (void)markImportButtonPressed:(UIButton *)sender {
    
    BOOL is_import = sender.selected ? 1 : 0;
    
    if (!sender.selected) {
        
        [self requestNoteBookImport:YES successBlock:^(id responseObject) {
            
            sender.selected = !sender.selected;
            
        }];
        
    }else {
        
        JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
        
        desModel.popDetail = @"该记事本内容是标记为重要的，确认要取消标记为重要吗？";
        
        desModel.rightTilte = @"确认";
        
        desModel.leftTilte = @"取消";
        
        desModel.popTextAlignment = NSTextAlignmentLeft;
        
        JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
        
        alertView.messageLable.textAlignment = NSTextAlignmentLeft;
        
        TYWeakSelf(self);
        
        alertView.onOkBlock = ^{
            
            [weakself requestNoteBookImport:NO successBlock:^(id responseObject) {
                
                sender.selected = !sender.selected;
                
            }];
            
        };
        
    }
    
}

- (void)requestNoteBookImport:(BOOL)is_import successBlock:(void(^)(id responseObject))successBlock{
    
    NSDictionary *param = @{ @"id" : @(self.noteModel.noteId),
                             
                             @"is_import" : @(is_import)
                             };
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"notebook/put-one" parameters:param success:^(id responseObject) {
        
        self.noteModel.is_import = is_import;
        
        [TYLoadingHub hideLoadingView];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTheNotepadList" object:nil];
        
        if (successBlock) {
            
            successBlock(responseObject);
        }
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (UIView *)line {
    
    if (!_line) {
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = AppFontf1f1f1Color;
    }
    return _line;
}

- (UITableView *)contentViewTableView {
    
    if (!_contentViewTableView) {
        
        _contentViewTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _contentViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentViewTableView.delegate = self;
        _contentViewTableView.dataSource = self;
        _contentViewTableView.backgroundColor = [UIColor whiteColor];
        _contentViewTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
    }
    return _contentViewTableView;
}
- (YYTextView *)contentView {
    
    if (!_contentView) {
        
        _contentView = [[YYTextView alloc] init];
        _contentView.textAlignment = NSTextAlignmentLeft;
        _contentView.placeholderFont = FONT(AppFont32Size);
        _contentView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _contentView.backgroundColor = AppFontffffffColor;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.editable = NO;
        _contentView.scrollEnabled = NO;
        _contentView.font = FONT(AppFont32Size);
        
    }
    return _contentView;
}

- (UIButton *)editeBtn {
    
    if (!_editeBtn) {
        
        _editeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editeBtn.contentMode = UIViewContentModeCenter;
        [_editeBtn setBackgroundImage:IMAGE(@"notepad_edite") forState:UIControlStateNormal];
        [_editeBtn addTarget:self action:@selector(editeTheNotepad) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editeBtn;
}

- (JGJNotePostToolView *)toolView {
    
    if (!_toolView) {
        
        
        CGFloat height = [JGJNotePostToolView toolViewHeight] + JGJ_IphoneX_BarHeight;
        
        _toolView = [[JGJNotePostToolView alloc] initWithFrame:CGRectMake(0, TYGetUIScreenHeight - height - JGJ_NAV_HEIGHT, TYGetUIScreenWidth, height)];
        
        _toolView.delegate = self;
        
        [_toolView.markButton setImage:[UIImage imageNamed:@"note_unImport_icon"] forState:UIControlStateNormal];
        
        [_toolView.markButton setImage:[UIImage imageNamed:@"note_import_icon"] forState:UIControlStateSelected];
        
        [_toolView.markButton setTitle:@"标记为重要" forState:UIControlStateNormal];
        
        [_toolView.markButton setTitle:@"重要" forState:UIControlStateSelected];
        [_toolView.markButton setTitleColor:AppFontFF6600Color forState:UIControlStateSelected];
        
        [_toolView.photoButton setTitle:@"修改" forState:UIControlStateNormal];
        
        [_toolView.photoButton setImage:[UIImage imageNamed:@"note_modify_icon"] forState:UIControlStateNormal];
        
        _toolView.markButton.selected = self.noteModel.is_import;
        
    }
    
    return _toolView;
}

- (NSMutableArray *)photos {
    
    if (!_photos) {
        
        _photos = [[NSMutableArray alloc] init];
        
        if (self.noteModel.images.count > 0) {
            
            [_photos addObjectsFromArray:self.noteModel.images];
            
        }
        
    }
    
    return _photos;
}

@end
