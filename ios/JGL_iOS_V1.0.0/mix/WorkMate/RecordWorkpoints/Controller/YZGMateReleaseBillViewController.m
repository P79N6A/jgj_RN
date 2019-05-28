//
//  YZGMateReleaseBillViewController.m
//  mix
//
//  Created by Tony on 16/3/1.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGMateReleaseBillViewController.h"
#import "TYBaseTool.h"
#import "SegmentTapView.h"
#import "SMCustomSegment.h"
#import "MultipleChoiceTableView.h"

#import "JGJChatRootVc.h"
#import "JGJMarkDayBillVc.h"
#import "JGJMarkContractBillVc.h"
#import "JGJMarkBorrowBillVc.h"

static const NSInteger mateReleaseBillFPSegmentY = 85;
static const NSInteger mateReleaseBillFPSegmentH = 0;

@interface YZGMateReleaseBillViewController ()
<
    UIActionSheetDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    MultipleChoiceTableViewDelegate,
    JGJMarkBillBaseVcDelegate,
    JGJMarkBillBaseVcDelegate,
    SMCustomSegmentDelegate
>

@property (assign, nonatomic) NSInteger selectedVcTag;//记录对应的tag值，1代表firstVeiw,2代表secondView,3代表third
@property (weak, nonatomic) IBOutlet UIButton *rightSaveButton;
@property (weak, nonatomic) IBOutlet UIButton *leftSaveButton;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) NSMutableArray <JGJMarkBillBaseVc *>*controllsArray;
@property (strong, nonatomic) MultipleChoiceTableView *mulChoiceView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentTapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomH;

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveLeftButtonLayoutW;

@property (copy, nonatomic) NSArray *typeArr;

@property (nonatomic,strong) SMCustomSegment * segment;
@end

@implementation YZGMateReleaseBillViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBottomButtonColor];
    
    [self.rightSaveButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
    [self.leftSaveButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
    
    self.bottomView.backgroundColor = AppFontfafafaColor;
    
    self.typeArr = @[@"",@"点工工钱",@"包工工钱",@"借支工钱"];
    [self setButtonLayout:1];//第一次进入为1
    [self SegmentView];
    
    [self MultipleChoiceTableView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)setBottomButtonColor{
    self.rightSaveButton.backgroundColor = JLGisMateBool?JGJMainColor:[UIColor whiteColor];
    [self.rightSaveButton setTitleColor:(!JLGisMateBool?JGJMainColor:[UIColor whiteColor]) forState:UIControlStateNormal];
    
    self.leftSaveButton.backgroundColor = !JLGisMateBool?JGJMainColor:[UIColor whiteColor];
    [self.leftSaveButton setTitleColor:(JLGisMateBool?JGJMainColor:[UIColor whiteColor]) forState:UIControlStateNormal];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

- (void)setSelectedVcTag:(NSInteger)selectedVcTag{
    if (_selectedVcTag == selectedVcTag) {
        return;
    }
    _selectedVcTag = selectedVcTag;
    [self setButtonLayout:selectedVcTag];
}

- (void)setButtonLayout:(NSInteger )index{
    self.saveLeftButtonLayoutW.constant =  ((self.roleType == 1 && index == 1)?0:0.5)*(TYGetUIScreenWidth - 30.0);
    
    if (self.saveLeftButtonLayoutW.constant == 0) {
        [self.rightSaveButton setBackgroundColor:JGJMainColor];
        [self.rightSaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [self setBottomButtonColor];
    }
}

-(void)SegmentView{
    self.segmentTapView.hidden = YES;
    CGRect segmentFrame = self.segmentTapView.frame;
    segmentFrame.origin.x = (TYGetUIScreenWidth - segmentFrame.size.width)/2.0;
    self.segment = [[SMCustomSegment alloc] initWithFrame:segmentFrame titleArray:@[@"点工", @"包工",@"借支"]];
    
    self.segment.selectIndex = 0;
    self.segment.delegate = self;
    self.segment.normalBackgroundColor = self.titleView.backgroundColor;
    self.segment.selectBackgroundColor = [UIColor whiteColor];
    self.segment.titleNormalColor = self.segment.selectBackgroundColor;
    self.segment.titleSelectColor = self.segment.normalBackgroundColor;
    self.segment.normalTitleFont = 16;
    self.segment.selectTitleFont = self.segment.normalTitleFont;
    
    [self.titleView addSubview:self.segment];
}

-(void)MultipleChoiceTableView{
    if (!self.controllsArray) {
        self.controllsArray = [[NSMutableArray alloc] init];
    }

    MateWorkitemsItems *firstMateWorkitemsItem = [[MateWorkitemsItems alloc] init];
    MateWorkitemsItems *secondMateWorkitemsItem = [[MateWorkitemsItems alloc] init];
    MateWorkitemsItems *thirdMateWorkitemsItem = [[MateWorkitemsItems alloc] init];
    
    firstMateWorkitemsItem.accounts_type.code = 1;
    secondMateWorkitemsItem.accounts_type.code = 2;
    thirdMateWorkitemsItem.accounts_type.code = 3;
    
    //如果没有设置角色，就使用本地的角色
    if (self.roleType == 0) {
        self.roleType = JLGisMateBool?:2;
    }

    firstMateWorkitemsItem.role = self.roleType ;
    secondMateWorkitemsItem.role = self.roleType;
    thirdMateWorkitemsItem.role = self.roleType;
    
    JGJMarkDayBillVc *firstVc = [[JGJMarkDayBillVc alloc] init];
    JGJMarkContractBillVc *secondVc = [[JGJMarkContractBillVc alloc] init];
    JGJMarkBorrowBillVc *thirdVc = [[JGJMarkBorrowBillVc alloc] init];
    
    //先将数据设置好
    firstVc.mateWorkitemsItems = firstMateWorkitemsItem;
    secondVc.mateWorkitemsItems = secondMateWorkitemsItem;
    thirdVc.mateWorkitemsItems = thirdMateWorkitemsItem;
    
    MarkBillType markBillType = self.workProListModel?MarkBillTypeChat:MarkBillTypeNewBill;
    
    firstVc.markBillType = markBillType;
    secondVc.markBillType = markBillType;
    thirdVc.markBillType = markBillType;
    
    if (markBillType == MarkBillTypeChat) {
        firstVc.workProListModel = self.workProListModel;
        secondVc.workProListModel = self.workProListModel;
        thirdVc.workProListModel = self.workProListModel;
    }

    firstVc.selectedDate = self.selectedDate;
    secondVc.selectedDate = self.selectedDate;
    thirdVc.selectedDate = self.selectedDate;
    
    firstVc.delegate = self;
    secondVc.delegate = self;
    thirdVc.delegate = self;

    firstVc.view.tag = firstMateWorkitemsItem.accounts_type.code;
    secondVc.view.tag = secondMateWorkitemsItem.accounts_type.code;
    thirdVc.view.tag = thirdMateWorkitemsItem.accounts_type.code;
    
    self.selectedVcTag = firstVc.view.tag;
    [self.controllsArray addObject:firstVc];
    [self.controllsArray addObject:secondVc];
    [self.controllsArray addObject:thirdVc];
    
    CGFloat mulChoiceY = mateReleaseBillFPSegmentY + mateReleaseBillFPSegmentH;
    self.mulChoiceView = [[MultipleChoiceTableView alloc] initWithFrame:CGRectMake(0, mulChoiceY, TYGetUIScreenWidth, TYGetUIScreenHeight - (mulChoiceY + 127)) withArray:_controllsArray];
    
    self.mulChoiceView.delegate = self;
    self.mulChoiceView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.mulChoiceView];
    [self.view insertSubview:self.mulChoiceView belowSubview:self.bottomView];
    
    [self addObserver];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (change[@"new"]) {
        CGFloat newSalaryFloat = [change[@"new"] floatValue];
        
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",newSalaryFloat];
    }
}

- (void)dealloc{
    [self removeObserver];
    
    self.mulChoiceView = nil;
    self.controllsArray = nil;
    self.mulChoiceView.delegate = nil;
    if (UseIQKeyBoardManager) {
        [TYNotificationCenter removeObserver:self];
    }
}

- (void)addObserver{
    [self.controllsArray enumerateObjectsUsingBlock:^(JGJMarkBillBaseVc * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.yzgGetBillModel addObserver:self forKeyPath:@"salary" options:NSKeyValueObservingOptionNew context:nil];
    }];
}

- (void)removeObserver{
    [self.controllsArray enumerateObjectsUsingBlock:^(JGJMarkBillBaseVc * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.yzgGetBillModel removeObserver:self forKeyPath:@"salary"];
    }];
}

#pragma mark - 监控键盘
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)MateReleaseBillKeyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGFloat yOffset =  TYGetUIScreenHeight - endKeyboardRect.origin.y;
    
    [self MateReleaseBillKeyboradChangeYOffset:yOffset duration:duration];
}

- (void)MateReleaseBillKeyboradChangeYOffset:(CGFloat )yOffset duration:(double) duration{
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        //显示
        self.bottomViewBottomH.constant = yOffset;
        [self.bottomView layoutIfNeeded];
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]&&self.navigationController.interactivePopGestureRecognizer.enabled) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    if (UseIQKeyBoardManager) {
        // 键盘的frame发生改变时发出的通知（位置和尺寸）
        [TYNotificationCenter addObserver:self selector:@selector(MateReleaseBillKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    
    //更新数据
    [self updateData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!CGColorEqualToColor(self.navigationController.navigationBar.barTintColor.CGColor, JGJMainColor.CGColor)) {
        SEL selector = NSSelectorFromString(@"getWhiteLeftBarButton");
        IMP imp = [self.navigationController methodForSelector:selector];
        UIBarButtonItem *(*func)(id, SEL) = (void *)imp;
        if (func) {
            UIBarButtonItem *whiteLeftBarButton = func(self.navigationController, selector);
            self.navigationItem.leftBarButtonItem = whiteLeftBarButton;
        }
        
        [TYBaseTool setupNavByNarBar:self.navigationController.navigationBar BybarTintColor:JGJMainColor tintColor:[UIColor whiteColor] titleColor:[UIColor whiteColor]];
    }
    
    if (UseIQKeyBoardManager) {
        [IQKeyboardManager sharedManager].contentOffsetIfNeed = NO;
    }
    
    [self setNavBarImage:[UIImage imageNamed:@"barButtonItem_transparent"]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 结束以后开启手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]&&!self.navigationController.interactivePopGestureRecognizer.enabled) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    if (!CGColorEqualToColor(self.navigationController.navigationBar.barTintColor.CGColor, AppFontfafafaColor.CGColor)) {
        SEL selector = NSSelectorFromString(@"getLeftBarButton");
        IMP imp = [self.navigationController methodForSelector:selector];
        UIBarButtonItem *(*func)(id, SEL) = (void *)imp;
        if (func) {
            UIBarButtonItem *leftBarButtonItem = func(self.navigationController, selector);
            self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        }
        
        [TYBaseTool setupNavByNarBar:self.navigationController.navigationBar BybarTintColor:AppFontfafafaColor tintColor:JGJMainRedColor titleColor:AppFont333333Color];
    }

//    [self setNavBarImage:[UIImage imageNamed:@"barButtonItem_lineBackImage"]];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"barButtonItem_lineBackImage"]];
    if (UseIQKeyBoardManager) {
        [IQKeyboardManager sharedManager].contentOffsetIfNeed = YES;
    }
    
    [self.view endEditing:YES];
}

- (void)setNavBarImage:(UIImage *)image{
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];
}

#pragma mark - delegate
- (void)scrollChangeToIndex:(NSInteger)index{
    JGJMarkBillBaseVc *oldMateGetBillDetailVc = (JGJMarkBillBaseVc *)[self getSubViewController];
    [oldMateGetBillDetailVc removeKeyBoardObserver];
    if (self.selectedVcTag == index) {
        return;
    }
    [oldMateGetBillDetailVc.view endEditing:YES];
    
    self.selectedVcTag = index;
    self.segment.selectIndex = index - 1;
    
    //更新数据
    [self updateData];
}

- (void)customSegmentSelectIndex:(NSInteger)selectIndex
{
    [self segementSelectedByIndex:selectIndex];
}


- (void)segementSelectedByIndex:(NSInteger )index{
    JGJMarkBillBaseVc *oldMateGetBillDetailVc = (JGJMarkBillBaseVc *)[self getSubViewController];
    [oldMateGetBillDetailVc removeKeyBoardObserver];
    if (self.selectedVcTag == (index + 1)) {
        return;
    }
    
    [oldMateGetBillDetailVc.view endEditing:YES];
    self.selectedVcTag = index + 1;
    [self.mulChoiceView selectIndex:index];
    
    //更新数据
    [self updateData];
}

#pragma mark - 进入子界面
- (void)MateGetBillPush:(JGJMarkBillBaseVc *)mateGetBillVc ByVc:(UIViewController *)Vc{
    self.selectedVcTag = mateGetBillVc.view.tag;
    [self.navigationController pushViewController:Vc animated:YES];
}

- (void)MateGetBillPresentView:(JGJMarkBillBaseVc *)mateGetBillVc ByVc:(UIViewController *)Vc{
    [self presentViewController:Vc animated:YES completion:nil];
    UIImagePickerController *imagePickerController = (UIImagePickerController *)Vc;
    imagePickerController.delegate = self;
}

- (void)MateGetBillPopView:(UIViewController *)Vc getBillVc:(JGJMarkBillBaseVc *)mateGetBillVc{
    MarkBillType markBillType = self.workProListModel?MarkBillTypeChat:MarkBillTypeNewBill;
    
    BOOL isMarkBill = mateGetBillVc.yzgGetBillModel.accounts_type.code == 1;
    if (isMarkBill && markBillType == MarkBillTypeChat) {
        //2.1.0-yj
//        JGJChatRootVc *chatRootVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
//        
//        NSDictionary *dataInfo = @{@"chatListType":@(JGJChatListRecord),@"record_id":mateGetBillVc.record_id};
//        
//        [chatRootVc addAllNotice:dataInfo]; //记账聊天不显示
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)RefreshOtherInfo{
    JGJMarkBillBaseVc *mateGetBillDetailVc = (JGJMarkBillBaseVc *)[self getSubViewController];
    [mateGetBillDetailVc RefreshOtherInfo];
}


- (void)querypro:(JGJMarkBillQueryproBlock )queryproBlock{
    JGJMarkBillBaseVc *mateGetBillDetailVc = (JGJMarkBillBaseVc *)[self getSubViewController];
    [mateGetBillDetailVc querypro:queryproBlock];
}

-(void)deleteSelectProByPid:(NSInteger )pid{
    JGJMarkBillBaseVc *mateGetBillDetailVc = (JGJMarkBillBaseVc *)[self getSubViewController];
    [mateGetBillDetailVc deleteSelectProByPid:pid];
}

#pragma mark - setter
- (void)setAddForemanModel:(YZGAddForemanModel *)addForemanModel{
    _addForemanModel = addForemanModel;
    JGJMarkBillBaseVc *mateGetBillDetailVc = (JGJMarkBillBaseVc *)[self getSubViewController];
    mateGetBillDetailVc.addForemanModel = _addForemanModel;
}

- (void)setAddForemandataArray:(NSMutableArray *)addForemandataArray{
    _addForemandataArray = addForemandataArray;
    JGJMarkBillBaseVc *mateGetBillDetailVc = (JGJMarkBillBaseVc *)[self getSubViewController];
    mateGetBillDetailVc.addForemandataArray = self.addForemandataArray;
}

#pragma mark - 获取子Vc
- (UIViewController *)getSubViewController{
    JGJMarkBillBaseVc *mateGetBillDetailVc = self.controllsArray[_selectedVcTag - 1];
    return mateGetBillDetailVc;
}

- (IBAction)saveAndRecordAgainBtnClick:(UIButton *)sender {
    JGJMarkBillBaseVc *mateGetBillDetailVc = (JGJMarkBillBaseVc *)[self getSubViewController];
    mateGetBillDetailVc.isNeedRecordAgain = YES;
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",0.0];
    
    [mateGetBillDetailVc saveDataToServer];
}

- (IBAction)saveBtnClick:(id)sender {
    JGJMarkBillBaseVc *mateGetBillDetailVc = (JGJMarkBillBaseVc *)[self getSubViewController];
    mateGetBillDetailVc.isNeedRecordAgain = NO;
    [mateGetBillDetailVc saveDataToServer];
}

#pragma mark - 使用说明
- (IBAction)UseIntroductionsBtnClick:(UIBarButtonItem *)sender {
    JGJMarkBillBaseVc *mateGetBillDetailVc = (JGJMarkBillBaseVc *)[self getSubViewController];
    [mateGetBillDetailVc UseIntroductionsDisPlay:mateReleaseBillFPSegmentY + mateReleaseBillFPSegmentH + 64 segMentView:self.segment];
}

- (void)ModifySalaryTemplateData{
    JGJMarkBillBaseVc *mateGetBillDetailVc = (JGJMarkBillBaseVc *)[self getSubViewController];
    [mateGetBillDetailVc ModifySalaryTemplateData];
}

- (void)updateData{
    JGJMarkBillBaseVc *newMateGetBillDetailVc = (JGJMarkBillBaseVc *)[self getSubViewController];
    [newMateGetBillDetailVc viewWillAppear:YES];
    
    [newMateGetBillDetailVc hiddenRecordWorkPointGuideView];
    [newMateGetBillDetailVc firstShowUseIntroductions:self.segment];
    CGFloat salaryFloat = [newMateGetBillDetailVc getSalary];
    if (salaryFloat == -2.f) {
        salaryFloat = 0.f;
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",salaryFloat];
    
    self.typeLabel.text = self.typeArr[newMateGetBillDetailVc.accountTypeCode];
}
@end
