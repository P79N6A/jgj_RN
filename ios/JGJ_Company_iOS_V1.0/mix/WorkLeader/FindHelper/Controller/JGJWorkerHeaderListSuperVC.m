//
//  JGJWorkerHeaderListSuperVC.m
//  mix
//
//  Created by Tony on 16/4/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkerHeaderListSuperVC.h"
#import "TYBaseTool.h"
#import "MultipleChoiceTableView.h"
#import "JGJWorkerHeaderListVC.h"
#import "JGJFilterTypeContentButtonView.h"
#import "JGJWorkTypeCollectionView.h"

static const NSInteger workerHeaderListSuperSegmentY = 40;
static const NSInteger workerHeaderListSuperSegmentH = 0;
#define TopViewY (TYIS_IPHONE_4_OR_LESS ? 64 : 0)
@interface JGJWorkerHeaderListSuperVC ()
<
    JGJWorkerHeaderListVCDelegate,
    MultipleChoiceTableViewDelegate,
    JGJFilterTypeContentButtonViewDelegate
>

@property (assign, nonatomic) NSInteger selectedVcTag;//记录对应的tag值，1代表firstVeiw,2代表secondView,3代表third
@property (strong, nonatomic) NSMutableArray *controllsArray;
@property (strong, nonatomic) MultipleChoiceTableView *mulChoiceView;
@property (strong, nonatomic) UISegmentedControl *segmentTapView;

@property (strong, nonatomic) CityMenuView *cityMenuView;
@property (strong, nonatomic)  JGJWorkTypeCollectionView *workTypeView;
@property (strong, nonatomic) JGJWorkTypeSelectedView *workTypeSelectedView;

@property (weak, nonatomic)  JGJFilterTypeContentButtonView *filterTypeContentView;

@end

@implementation JGJWorkerHeaderListSuperVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSegmentView];
    [self MultipleChoiceTableView];
}


-(void)initSegmentView{
    self.segmentTapView = [[UISegmentedControl alloc] initWithItems:@[@"班组长", @"工人"]];
    self.segmentTapView.frame = (CGRect){0, 0, 154, 30};
    [self.segmentTapView addTarget:self action:@selector(segementSelectedIndex:) forControlEvents:UIControlEventValueChanged];
    self.segmentTapView.tintColor = TYColorRGB(220, 0, 49);
    self.segmentTapView.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.segmentTapView;
//    添加顶部选择按钮
    JGJFilterTypeContentButtonView *filterTypeContentView = [[JGJFilterTypeContentButtonView alloc] initWithFrame:CGRectMake(0, 0  + TopViewY, TYGetViewW(self.view), 40)];
    self.filterTypeContentView = filterTypeContentView;
    filterTypeContentView.delegate = self;
    filterTypeContentView.cityName.text =   [TYUserDefaults objectForKey:JLGSelectCityName];
    [self.view addSubview:filterTypeContentView];
}

-(void)MultipleChoiceTableView{
    if (!self.controllsArray) {
        self.controllsArray = [[NSMutableArray alloc] init];
    }

    JGJWorkerHeaderListVC *firstVc = [[UIStoryboard storyboardWithName:@"FindHelper" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJWorkerHeaderListVC"];
    JGJWorkerHeaderListVC *secondVc = [[UIStoryboard storyboardWithName:@"FindHelper" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJWorkerHeaderListVC"];

    firstVc.view.tag = 1;
    secondVc.view.tag = 2;
    
    firstVc.delegate = self;
    secondVc.delegate = self;

    [self.controllsArray addObject:firstVc];
    [self.controllsArray addObject:secondVc];
    self.selectedVcTag = firstVc.view.tag - 1;//必须要放在self.controllsArray 后面
    
    CGFloat mulChoiceY = workerHeaderListSuperSegmentY + workerHeaderListSuperSegmentH + TopViewY;
    self.mulChoiceView = [[MultipleChoiceTableView alloc] initWithFrame:CGRectMake(0, mulChoiceY, TYGetUIScreenWidth, TYGetUIScreenHeight - (mulChoiceY + 40)) withArray:_controllsArray];
    
    self.mulChoiceView.delegate = self;
    [self.view addSubview:self.mulChoiceView];

}

- (void)dealloc{
    self.mulChoiceView = nil;
    self.controllsArray = nil;
    self.mulChoiceView.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]&&self.navigationController.interactivePopGestureRecognizer.enabled) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 结束以后开启手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]&&!self.navigationController.interactivePopGestureRecognizer.enabled) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - delegate
- (void)scrollChangeToIndex:(NSInteger)index{
    self.selectedVcTag = index - 1;
    self.segmentTapView.selectedSegmentIndex = self.selectedVcTag;
}

- (void)segementSelectedIndex:(UISegmentedControl *)sender {
    self.selectedVcTag = sender.selectedSegmentIndex;
    [self.mulChoiceView selectIndex:self.selectedVcTag];
}

#pragma mark - 进入子界面
- (void )WorkerHeaderList:(JGJWorkerHeaderListVC *)workerHeaderVc pushVc:(UIViewController *)pushVc{
    self.selectedVcTag = workerHeaderVc.view.tag - 1;
    [self.navigationController pushViewController:pushVc animated:YES];
}


- (void)removeCurrentView {
    if (self.workTypeSelectedView) {
        [self.workTypeSelectedView removeFromSuperview];
    }
    
    if (self.cityMenuView) {
        [self.cityMenuView removeFromSuperview];
    }
}

- (JGJWorkerHeaderListVC *)getSuvVc{
    JGJWorkerHeaderListVC *suvListVc = self.controllsArray[self.selectedVcTag];
    return suvListVc;
}

#pragma setter
-(void)setSelectedVcTag:(NSInteger)selectedVcTag{
    _selectedVcTag = selectedVcTag;
    
    JGJWorkerHeaderListVC *subListVc = self.controllsArray[selectedVcTag];

    self.filterTypeContentView.workTypeFlagImageView.image = [UIImage imageNamed:@"down_press"];
    self.filterTypeContentView.workTypeName.text = subListVc.workTypeModel.type_name;
    
    self.filterTypeContentView.cityFlagImageView.image = [UIImage imageNamed:@"down_press"];
    self.filterTypeContentView.cityName.text = subListVc.workTypeModel.cityName;
}

#pragma Mark - JGJFilterTypeContentButtonViewDelegate

- (void)filterCityTypeMenuButtonPressed:(UIButton *)sender {

    sender.selected = !sender.selected;
    if (sender.selected) {
       self.filterTypeContentView.workTypeButton.selected = NO;
    }
    CGRect rect = CGRectMake(0, TYGetViewH(sender)  + TopViewY, TYGetUIScreenWidth, TYGetUIScreenHeight - TYGetViewH(sender) - 64);
    __weak typeof(self) weakSelf = self;
    if (sender.selected || self.filterTypeContentView.workTypeButton.selected) {
        self.filterTypeContentView.cityFlagImageView.image = [UIImage imageNamed:@"up_press"];
        self.filterTypeContentView.workTypeFlagImageView.image = [UIImage imageNamed:@"down_press"];
        [self removeCurrentView];
        CityMenuView *cityMenuView = [[CityMenuView alloc] initWithFrame:rect cityName:^(JLGCityModel *cityModel) {
            weakSelf.filterTypeContentView.cityFlagImageView.image = [UIImage imageNamed:@"down_press"];
            weakSelf.filterTypeContentView.cityButton.selected = NO;
            weakSelf.filterTypeContentView.cityName.text = cityModel.city_name;
            JGJWorkerHeaderListVC *subListVc = [weakSelf getSuvVc];
            subListVc.workTypeModel.cityNameID = cityModel.city_code;
            subListVc.workTypeModel.cityName = cityModel.city_name;
            [subListVc loadNetData];
        }];
        self.cityMenuView = cityMenuView;
        [self.view addSubview:cityMenuView];
    } else {
        self.filterTypeContentView.cityFlagImageView.image = [UIImage imageNamed:@"down_press"];
        [self removeCurrentView];
    }
}

- (void)filterWorkTypeButtonPressed:(UIButton *)sender {

    sender.selected = !sender.selected;
    if (sender.selected) {
        self.filterTypeContentView.cityButton.selected = NO;
    }
    __weak typeof(self) weakSelf = self;
    CGRect rect = CGRectMake(0, TYGetViewH(sender)  + TopViewY, TYGetUIScreenWidth, TYGetUIScreenHeight - TYGetViewH(sender) - 64);
    if ( sender.selected  || self.filterTypeContentView.cityButton.selected)  {
        self.filterTypeContentView.workTypeFlagImageView.image = [UIImage imageNamed:@"up_press"];
        self.filterTypeContentView.cityFlagImageView.image = [UIImage imageNamed:@"down_press"];
        [self removeCurrentView];
        
        __block JGJWorkerHeaderListVC *subListVc = [self getSuvVc];
        subListVc.workTypeModel.currentPageType = FindHelperType;
        JGJWorkTypeSelectedView *workTypeSelectedView = [[JGJWorkTypeSelectedView alloc] initWithFrame:rect workType:subListVc.workTypeModel blockWorkType:^(FHLeaderWorktypeCity *workTypeModel) {
            weakSelf.filterTypeContentView.workTypeFlagImageView.image = [UIImage imageNamed:@"down_press"];
            subListVc.workTypeModel.workTypeID = [NSString stringWithFormat:@"%@",@(workTypeModel.type_id)];
            weakSelf.filterTypeContentView.workTypeButton.selected = NO;
            weakSelf.filterTypeContentView.workTypeName.text = workTypeModel.type_name;
            subListVc.workTypeModel = workTypeModel;
            [subListVc loadNetData];
        }];

        self.workTypeSelectedView = workTypeSelectedView;
        [self.view addSubview:workTypeSelectedView];
    } else {
        self.filterTypeContentView.workTypeFlagImageView.image = [UIImage imageNamed:@"down_press"];
        [self removeCurrentView];
    }
}


@end
