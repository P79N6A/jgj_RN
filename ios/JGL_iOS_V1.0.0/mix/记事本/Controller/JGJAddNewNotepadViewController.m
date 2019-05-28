//
//  JGJAddNewNotepadViewController.m
//  mix
//
//  Created by Tony on 2018/4/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJAddNewNotepadViewController.h"
#import "JGJAddNewNotepadTopView.h"
#import "JGJNewSelectedDataPickerView.h"
#import "NSDate+Extend.h"
#import "JLGAddProExperienceTableViewCell.h"
#import "JGJNotePostToolView.h"

#import "JGJSelPhotoTool.h"

#import "JGJNineAvatarCell.h"
#import "JGJAddNotePadInputCell.h"
@interface JGJAddNewNotepadViewController ()
<

    UITableViewDelegate,

    UITableViewDataSource,

    JLGMYProExperienceTableViewCellDelegate,

    JGJNotePostToolViewDelegate,

    JGJNineAvatarCellDelegate,
JGJAddNotePadInputCellDelegate

>
{
    NSString *_imagesStr;
    
   
}
@property (nonatomic, strong) JGJAddNewNotepadTopView *topView;

@property (nonatomic, strong) UITableView *contentViewTableView;// 内容和图片

@property (nonatomic, strong) NSDateComponents *comp;

@property (nonatomic, copy) NSString *weekDay;

@property (nonatomic, copy) NSString *timeStr;

@property (nonatomic, strong) JGJNewSelectedDataPickerView *dataPicker;

//底部工具栏(标记重要、拍照)
@property (nonatomic, strong) JGJNotePostToolView *toolView;

//选择照片工具

@property (nonatomic, strong) JGJSelPhotoTool *selPhotoTool;

//是否标记重要

@property (nonatomic, assign) BOOL is_import;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) JGJNineAvatarCell *avatarCell;
@property (nonatomic, strong) JGJAddNotePadInputCell *inputCell;
@end

@implementation JGJAddNewNotepadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isNeedRemoveImagesArray = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeAppearance];

    [self.view addSubview:self.toolView];
    
    //注册键盘通知
    
    [self chatListAddKeyBoardObserver];
    
    JGJNineAvatarCell *avatarCell = [JGJNineAvatarCell cellWithTableView:self.tableView];
    
    self.avatarCell = avatarCell;
    
    JGJAddNotePadInputCell *inputCell = [JGJAddNotePadInputCell cellWithTableViewNotXib:self.tableView];
    inputCell.delegate = self;
    self.inputCell = inputCell;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setToDayTimeStr];
    }
    return self;
}

#pragma mark - 键盘监控
- (void)chatListAddKeyBoardObserver{
    
    [TYNotificationCenter addObserver:self selector:@selector(chatListKeyboardDidShowFrame:) name:UIKeyboardWillShowNotification object:nil];
    
    [TYNotificationCenter addObserver:self selector:@selector(chatListKeyboardDidHiddenFrame:) name:UIKeyboardWillHideNotification object:nil];

}

- (JGJNewSelectedDataPickerView *)dataPicker {
    
    if (!_dataPicker) {
        
        _dataPicker = [[JGJNewSelectedDataPickerView alloc] init];
        _dataPicker.timeAfterYear = 2;
        _dataPicker.isNeedShowToday = NO;
        _dataPicker.isNeddShowMoreDayChoiceBtn = NO;
#pragma mark - v3.5.0修改 不能记录今天之后的记事本事件
        _dataPicker.isNeedLimitTimeChoice = NO;
    }
    return _dataPicker;
}


- (void)initializeAppearance {
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.contentViewTableView];
    [self setUpLayout];
    
    __weak typeof(self) weakSelf = self;
    __strong typeof(self) strongSelf = self;
    // 返回
    _topView.close = ^{
      
        [weakSelf.view endEditing:YES];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    
    // 选择时间
    _topView.choiceTheSaveTime = ^() {
      
        [weakSelf.view endEditing:YES];
        
        weakSelf.dataPicker.selectedTimeStr = weakSelf.timeStr;
        
        [weakSelf.dataPicker show];
        weakSelf.dataPicker.choiceData = ^(NSArray *dataArray,NSString *timeStr) {
          
            weakSelf.timeStr = timeStr;
            [weakSelf.topView setTheTitleWithTimeArray:dataArray weekIndex:[NSDate weekdayStringFromDate:[NSDate dateFromString:timeStr withDateFormat:@"yyyy-MM-dd"]]];
            
            NSInteger index = [NSDate weekdayStringFromDate:[NSDate dateFromString:timeStr withDateFormat:@"yyyy-MM-dd"]];
            weakSelf.weekDay = [weakSelf getTheWeekDayWithWeekIndex:index];
        };
        
    };
    
    
    // 保存
    _topView.saveNotepad = ^{
      
        if (weakSelf.inputCell.inputContentView.text.length < 2) {
            
            [TYShowMessage showPlaint:@"请至少输入2个字"];
            return;
        }
        [TYLoadingHub showLoadingWithMessage:@""];
        
        NSMutableArray *theLeftImageStrArr = [NSMutableArray new];
        NSMutableArray *theLeftImage = [NSMutableArray new];
        for (int i = 0; i < weakSelf.photos.count; i ++) {
            
            // 代表原来de图片地址
            if ([weakSelf.photos[i] isKindOfClass:[NSString class]]) {
                
                [theLeftImageStrArr addObject:weakSelf.imagesArray[i]];
                
            }else {
                
                [theLeftImage addObject:weakSelf.photos[i]];
            }
            
        }
        [JLGHttpRequest_AFN newUploadImagesWithApi:@"file/upload" parameters:nil imagearray:theLeftImage otherDataArray:nil dataNameArray:nil success:^(id responseObject) {
            
            NSString *theLeftImageStr = [theLeftImageStrArr componentsJoinedByString:@","];
            strongSelf -> _imagesStr = [responseObject componentsJoinedByString:@","];
            // 编辑记事本
            if (weakSelf.isEditeNotepad) {
                
                NSString *imageStr;
                // 如果原来有图片，且没有被删除完，则将剩下的链接，与新增图片返回的链接拼接
                if (theLeftImageStr.length != 0) {
                    
                    if ([strongSelf -> _imagesStr length] != 0) {
                        
                        imageStr = [NSString stringWithFormat:@"%@,%@",theLeftImageStr,strongSelf -> _imagesStr];
                        
                    }else {
                        
                        imageStr = [NSString stringWithFormat:@"%@",theLeftImageStr];
                    }
                    
                    
                }else {// 原来没有图片。或者被删除完，则用新增图片返回的链接
                    
                    imageStr = strongSelf -> _imagesStr;
                }
                NSDictionary *param = @{@"id":@(weakSelf.noteModel.noteId),
                                        @"weekday":weakSelf.weekDay,
                                        @"publish_time":[NSString stringWithFormat:@"%@ %02ld:%02ld:%02ld",weakSelf.timeStr,weakSelf.comp.hour,weakSelf.comp.minute,weakSelf.comp.second],
                                        @"content":weakSelf.inputCell.inputContentView.text ? : @"",
                                        @"images":imageStr,
                                        @"is_import" : @(weakSelf.is_import)
                                        };
                
                [JLGHttpRequest_AFN PostWithNapi:@"notebook/put-one" parameters:param success:^(id responseObject) {
                    
                    [TYLoadingHub hideLoadingView];
                    [weakSelf dismissViewControllerAnimated:NO completion:^{
                        
                        [weakSelf.tagVC.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTheNotepadList" object:nil];
                    }];
                    
                } failure:^(NSError *error) {
                    
                    [TYLoadingHub hideLoadingView];
                    
                }];
            }else {
                
                NSDictionary *param = @{@"weekday":weakSelf.weekDay,
                                        @"publish_time":[NSString stringWithFormat:@"%@ %02ld:%02ld:%02ld",weakSelf.timeStr,weakSelf.comp.hour,weakSelf.comp.minute,weakSelf.comp.second],
                                        @"content":weakSelf.inputCell.inputContentView.text ? : @"",
                                        @"images":strongSelf -> _imagesStr,
                                        @"is_import" : @(weakSelf.is_import)
                                        };
                
                [JLGHttpRequest_AFN PostWithNapi:@"notebook/post-one" parameters:param success:^(id responseObject) {
                    
                    [TYLoadingHub hideLoadingView];
                    [weakSelf dismissViewControllerAnimated:NO completion:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTheNotepadList" object:nil];
                    
                } failure:^(NSError *error) {
                    
                    
                    [TYLoadingHub hideLoadingView];
                }];
            }
            
        } failure:^(NSError *error) {
            
            [TYLoadingHub showLoadingWithMessage:@""];
        }];
        
    };
}

- (void)setUpLayout {
    
    _topView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(JGJ_NAV_HEIGHT);
    
    _contentViewTableView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(_topView, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, self.toolView.height);
}

- (void)setToDayTimeStr {
    
    self.timeStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld", self.comp.year,self.comp.month,self.comp.day];
    self.weekDay = [self getTheWeekDayWithWeekIndex:[NSDate weekdayStringFromDate:[NSDate dateFromString:self.timeStr withDateFormat:@"yyyy-MM-dd"]]];
    [self.topView setTheTitleWithTimeArray:@[[NSString stringWithFormat:@"%ld",self.comp.year],[NSString stringWithFormat:@"%ld",self.comp.month],[NSString stringWithFormat:@"%ld",self.comp.day]] weekIndex:[NSDate weekdayStringFromDate:[NSDate dateFromString:self.timeStr withDateFormat:@"yyyy-MM-dd"]]];
}

- (void)setIsEditeNotepad:(BOOL)isEditeNotepad {
    
    _isEditeNotepad = isEditeNotepad;
}

- (void)setNoteModel:(JGJNotepadListModel *)noteModel {
    
    _noteModel = noteModel;
    
    self.is_import = self.noteModel.is_import;

    NSArray *timeArr = [_noteModel.publish_time componentsSeparatedByString:@" "];
    NSArray *yearMDArr = [timeArr[0] componentsSeparatedByString:@"-"];
    self.timeStr = timeArr[0];
    self.weekDay = _noteModel.weekday;
    
    [self.topView setTheTitleWithTimeArray:@[yearMDArr[0],yearMDArr[1],yearMDArr[2]] weekIndex:[NSDate weekdayStringFromDate:[NSDate dateFromString:timeArr[0] withDateFormat:@"yyyy-MM-dd"]]];
    
}

- (void)setTagVC:(UIViewController *)tagVC {
    
    _tagVC = tagVC;
}

- (void)setOrignalImgArr:(NSMutableArray *)orignalImgArr {
    
    _orignalImgArr = orignalImgArr;
    self.imagesArray = [[NSMutableArray alloc] initWithArray:_orignalImgArr.copy];
    [self.contentViewTableView reloadData];
}


- (NSString *)getTheWeekDayWithWeekIndex:(NSInteger)index {
    
    switch (index) {
        case 1:
        {
            return @"星期日";
        }
            break;
        case 2:
        {
            return @"星期一";
        }
            break;
        case 3:
        {
            return @"星期二";
        }
            break;
        case 4:
        {
            return @"星期三";
        }
            break;
        case 5:
        {
            return @"星期四";
        }
            break;
        case 6:
        {
            return @"星期五";
        }
            break;
        case 7:
        {
            return @"星期六";
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}


#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self registerNineAvatarCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
    
    return  cell;
}

- (UITableViewCell *)registerNineAvatarCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.row == 0) {
        
        JGJAddNotePadInputCell *cell = self.inputCell;
        
        if (_noteModel) {
            
            cell.inputContentView.text = _noteModel.content;
        }
        
        NSMutableAttributedString *text = [cell.inputContentView.attributedText mutableCopy];
        text.yy_lineSpacing = 8;
        cell.inputContentView.attributedText = text;
        
        return cell;
    }else {
        
        JGJNineAvatarCell *cell = self.avatarCell;
        
        cell.isShowAddBtn = NO;
        
        cell.delegate = self;
        
        if (self.photos.count > 0) {
            
            cell.photos = self.photos;
            
        }
        
        return cell;
    }
    
}

- (void)phoneVc:(UIPhotoViewController *)phoneVc imagesArrayAddEnd:(NSArray *)imagesArr {

    [self.contentViewTableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0.0;
    if (indexPath.row == 0) {
        
        height = 235.0;
        
    }else {
        
        height = [JGJCusNineAvatarView avatarViewHeightWithPhotoCount:self.photos.count];
        
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return nil;
//    self.inputContentView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(235);
//    return self.inputContentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


- (void)inputContentViewInputWithText:(NSString *)content {
    
    if (_noteModel) {
        
        _noteModel.content = content;
    }
    
}
#pragma mark - JGJNineAvatarCellDelegate

- (void)nineAvatarCell:(JGJNineAvatarCell *)cell avatarView:(JGJCusNineAvatarView *)avatarView checkView:(JGJCusCheckView *)checkView {
    
    self.photos = avatarView.photos.mutableCopy;
    
    _selPhotoTool.photos = avatarView.photos.mutableCopy;
    
}

- (JGJAddNewNotepadTopView *)topView {
    
    if (!_topView) {
        
        _topView = [[JGJAddNewNotepadTopView alloc] init];
    }
    return _topView;
}

- (UITableView *)contentViewTableView {
    
    if (!_contentViewTableView) {
        
        _contentViewTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _contentViewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentViewTableView.delegate = self;
        _contentViewTableView.dataSource = self;
        _contentViewTableView.backgroundColor = [UIColor whiteColor];
    }
    return _contentViewTableView;
}

- (NSDateComponents *)comp {
    
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    _comp = [calendar components: unitFlags fromDate:[NSDate date]];
  
    return _comp;
}

#pragma mark - JGJNotePostToolViewDelegate

- (void)notePostToolView:(JGJNotePostToolView *)toolView buttonType:(JGJNotePostToolViewButtonType)buttonType button:(UIButton *)button {
    
    switch (buttonType) {
            
        case JGJNotePostMarkImportButtonType: {//标记重要
            
            button.selected = !button.selected;
            
            [self markImportButtonPressed:button];
            
            self.is_import = button.selected ? 1 : 0;
        }
            
            break;
            
        case JGJNotePostMarkPhotoButtonType: {//拍照
            
            [self photoButtonPressed:button];
            
        }
            
            break;
            
        default:
            break;
    }
    
}

- (void)chatListKeyboardDidShowFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat toolViewHeight = [JGJNotePostToolView toolViewHeight];
    
    CGFloat yEndOffset = endKeyboardRect.origin.y - toolViewHeight;

    //增加高度
    [UIView animateWithDuration:duration animations:^{

        self.toolView.frame = CGRectMake(0, yEndOffset, TYGetUIScreenWidth, [JGJNotePostToolView toolViewHeight]);
        
        
    }];
    
}


//恢复
- (void)chatListKeyboardDidHiddenFrame:(NSNotification *)notification{
    
    double duration = 0.25;
    
    //增加高度
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat y = TYGetUIScreenHeight - [JGJNotePostToolView toolViewHeight] - JGJ_IphoneX_BarHeight;
        
        CGFloat height = [JGJNotePostToolView toolViewHeight] + JGJ_IphoneX_BarHeight;
        
        self.toolView.frame = CGRectMake(0, y, TYGetUIScreenWidth, height);
    }];
    
}

#pragma mark - 拍照按钮按下
- (void)photoButtonPressed:(UIButton *)sender {
    
    [self.selPhotoTool showSelPhotoTool];
    
}

#pragma mark - 标记重要按钮按下
- (void)markImportButtonPressed:(UIButton *)sender {
    
    
}

// 如果 子类不重写这个方法，会导致父类里面调用这个方法，点击图片的celll,弹出城市选择器 -> 错误 #19399 【记事本 】点击删除图片弹出了下面的弹框
- (void)subClassTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
}

- (JGJNotePostToolView *)toolView {
    
    if (!_toolView) {

        _toolView = [[JGJNotePostToolView alloc] initWithFrame:CGRectMake(0, TYGetUIScreenHeight - ([JGJNotePostToolView toolViewHeight] + JGJ_IphoneX_BarHeight) - 64, TYGetUIScreenWidth, [JGJNotePostToolView toolViewHeight] + JGJ_IphoneX_BarHeight)];
        
        _toolView.delegate = self;
        
        [_toolView.markButton setImage:[UIImage imageNamed:@"note_unImport_icon"] forState:UIControlStateNormal];
        
        [_toolView.markButton setImage:[UIImage imageNamed:@"note_import_icon"] forState:UIControlStateSelected];
        
        [_toolView.markButton setTitle:@"标记为重要" forState:UIControlStateNormal];
        
        [_toolView.markButton setTitle:@"重要" forState:UIControlStateSelected];
        [_toolView.markButton setTitleColor:AppFontFF6600Color forState:UIControlStateSelected];
        
        _toolView.markButton.selected = self.noteModel.is_import;
        
    }
    
    return _toolView;
}

- (JGJSelPhotoTool *)selPhotoTool {
    
    if (!_selPhotoTool) {
        
        TYWeakSelf(self);
        
        _selPhotoTool = [JGJSelPhotoTool selPhotoWithTargetVc:self selPhotosBlock:^(NSArray * _Nonnull photos) {
           
            TYLog(@"----%@", photos);
            NSInteger maxCount = weakself.photos.count + photos.count;
            
            if (maxCount > 9) {
                
                [TYShowMessage showPlaint:@"最多只能上传9张照片"];
                
                return ;
            }
            
            if (photos.count > 0) {
                
                [weakself.photos addObjectsFromArray:photos];
                
            }
            
            [weakself.contentViewTableView reloadData];
            
        }];
        
        _selPhotoTool.selPhotoToolBtnPressedBlock = ^(NSInteger index) {
           
            [weakself.broswerVc.selectedAssets removeAllObjects];
            
        };
        
         [self.broswerVc.selectedAssets removeAllObjects];
        
        _selPhotoTool.maxImageCount = 9;
    }
    
    return _selPhotoTool;
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
