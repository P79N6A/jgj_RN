//
//  JGJWorkTypeCollectionView.m
//  mix
//
//  Created by yj on 16/4/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkTypeCollectionView.h"
#import "JGJWorkTypeCell.h"
#import "JGJReusableFooterView.h"
#import "JGJReusableHeaderView.h"
#import "TYFMDB.h"
#import "JLGFHLeaderModel.h"
#import "MJExtension.h"
#import "UIView+GNUtil.h"
#import "NSString+Extend.h"
#define TopViewY (TYIS_IPHONE_4_OR_LESS ? 64 : 0)

@interface JGJWorkTypeCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *workTypes;
@property (nonatomic, strong) JGJReusableFooterView *footerview;
@property (nonatomic, strong) NSArray *workTypesArray;
@property (nonatomic, strong) id blockWorkTypeModel;
@property (nonatomic, strong) id blockSelectedTime;
@property (nonatomic, assign) NSInteger count;//记录换行数量
@property (nonatomic, strong) JGJShowTimeModel *timeModel;//记录传进来的时间模型
@property (nonatomic, assign) CGFloat collectionViewHeight;
@property (nonatomic, strong) NSArray *timeModels;//时间模型
@property (nonatomic, strong) JGJShowTimeModel *selectedTimeModel;//选中的时间模型
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, weak)   JGJReusableHeaderView *header;
@property (nonatomic, assign) SelectedTimeType selectedTimeType;//存储选择的类型
@end

@implementation JGJWorkTypeCollectionView

- (NSMutableArray *)workTypes
{
    if (_workTypes == nil) {
        _workTypes = [NSMutableArray array];
    }
    return _workTypes;
}

static NSString *const ID = @"JGJWorkTypeCell";
static NSString * const FooterID = @"footer";
static NSString * const HeaderID = @"header";
- (instancetype)initWithFrame:(CGRect)frame workType:(void(^)(FHLeaderWorktype *workTypeModel)) workTypeModel {

    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = TYColorRGBA(1, 1, 1, 0.5);
        self.blockWorkTypeModel = workTypeModel;
        [self commonSet];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame timeModel:(JGJShowTimeModel *)timeModel SelectedTimeType:(SelectedTimeType )selectedTimeType isOnlyShowHeaderView:(BOOL)isOnlyShowHeaderView blockSelectedTime:(void(^)(JGJShowTimeModel *timeModel)) blockSelectedTime {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = TYColorRGBA(1, 1, 1, 0.5);
        self.blockSelectedTime = blockSelectedTime;
        self.timeModel = timeModel;
        self.selectedTimeType = selectedTimeType;
        self.isOnlyShowHeaderView = isOnlyShowHeaderView;
        self.isShowZero = timeModel.isShowZero;
        [self commonSet];
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)commonSet {

    // 1.初始化数据
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat headerHeight = self.isOnlyShowHeaderView ? HeaderHegiht : 0;
    CGFloat footerHeight = self.isOnlyShowHeaderView ? 0 : FooterHegiht;
    layout.footerReferenceSize = CGSizeMake(TYGetUIScreenWidth - 50, footerHeight);
    layout.headerReferenceSize = CGSizeMake(TYGetUIScreenWidth, headerHeight);
    layout.sectionInset = UIEdgeInsetsMake(LinePadding, LinePadding, LinePadding, LinePadding);
    CGFloat ItemW = (TYIS_IPHONE_5 || TYIS_IPHONE_4_OR_LESS) ? ItemOtherWidth : ItemWidth;
    layout.itemSize = CGSizeMake(ItemW, ItemHeight);
    CGRect rect = CGRectMake(0, TopViewY, TYGetViewW(self), TYGetViewH(self));
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    collectionView.scrollEnabled = NO;
    collectionView.backgroundColor = AppFontf1f1f1Color;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"JGJWorkTypeCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [collectionView registerClass:[JGJReusableFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterID];
    [collectionView registerClass:[JGJReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderID];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
//    isOnlyShowHeaderView = YES 用于记工记账只显示头部，根据传入的限制确定高度   NO用于工种显示
    if (self.isOnlyShowHeaderView) {
        [self recordWorkpointsDidCellShowTime];
    } else {
        collectionView.y = TopViewY;
        NSArray *workTypes =  [TYFMDB searchTable:TYFMDBWorkTypeName];
        self.workTypes =  [FHLeaderWorktype mj_objectArrayWithKeyValuesArray:workTypes];
        //    是否展开
        [self didClickedMoreOpenCollective:self.workTypes.count];
    }
}

- (CGFloat)workTypeHeight {

    if (!_workTypeHeight) {
        
        self.isOpen = NO;
       [self getCollectionViewShowCount:self.workTypes.count];
    }
    return self.collectionViewHeight;
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.isOnlyShowHeaderView ? self.timeModels.count : [self getCollectionViewShowCount:self.workTypes.count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JGJWorkTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (self.isOnlyShowHeaderView) {
        cell.timeModel = self.timeModels[indexPath.row];
        cell.blockSelectedtimeModel = ^(JGJShowTimeModel *timeModel){
            
        };
    } else {
    
        FHLeaderWorktype *workTypeModel = self.workTypes[indexPath.item];
        workTypeModel.workTypeHeight = self.collectionViewHeight;
        cell.workTypeModel = workTypeModel;
        if (!self.isOpen) {
            [cell setMoreCount:self.count indexPath:indexPath];
        }
        __weak typeof(self) weakSelf = self;
        cell.blockLoadMoreWorktype = ^{
            weakSelf.isOpen = YES;
            [weakSelf.collectionView reloadData];
            if ([weakSelf.delegate respondsToSelector:@selector(didClickedMoreButtonPressed:)]) {
                [weakSelf.delegate didClickedMoreButtonPressed:weakSelf];
            }
        };
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    点击时间
    if (self.selectedTimeType >= NormalWorkTimeType) {
        
        void(^blockTimeModel)(JGJShowTimeModel *) = self.blockSelectedTime;
        JGJShowTimeModel *timeModel = self.timeModels[indexPath.row];
        timeModel.isSelected = YES;
        blockTimeModel(timeModel);
        [UIView animateWithDuration:0.5 animations:^{
           self.collectionView.y = TYGetUIScreenHeight;
        } completion:^(BOOL finished) {
           [self removeFromSuperview];
        }];
        return;
    }
//    点击工种不移除
    void(^blockWorkType)(FHLeaderWorktype *) = self.blockWorkTypeModel;
    blockWorkType(self.workTypes[indexPath.row]);

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        JGJReusableFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FooterID forIndexPath:indexPath];
        footer.backgroundColor =  AppFontf1f1f1Color;
        footer.blockCancel = ^{
            weakSelf.isOpen = NO;
            [weakSelf getCollectionViewShowCount:self.workTypes.count];
            [weakSelf.collectionView reloadData];
            if ([weakSelf.delegate respondsToSelector:@selector(didClickedCancelButtonPressed:)]) {
                [weakSelf.delegate didClickedCancelButtonPressed:weakSelf];
            }
        };
        reusableview = footer;
    }
    
    if (kind == UICollectionElementKindSectionHeader) {
        JGJReusableHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderID forIndexPath:indexPath];
        
        //这个条件是2.1.0版本发版前添加
        if (self.selectedTimeType == WageLevelNormalWorkTimeType || self.selectedTimeType == NormalWorkTimeType) {
            header.titleLable.text = self.timeModel.titleStr;
        }else {
            header.titleLable.text = self.timeModel.timeStr?:[NSString stringWithFormat:@"选择%@时长", self.selectedTimeType == NormalWorkTimeType ? @"上班" : @"加班"];
        }
        __weak typeof(self) weakSelf = self;
        header.cancelBlock = ^{
            [weakSelf removeFromSuperview];
        };
        header.okBlock = ^{
            [weakSelf removeFromSuperview];
        };
        reusableview = header;
    }
    
    return reusableview;
}

//是否展开
- (void)didClickedMoreOpenCollective:(NSInteger) workTypesCount {
    NSInteger lineCount = 0;
    int count = 0;
    count = workTypesCount % 4;
    lineCount = workTypesCount < 3 ? 1 : (count == 0 ? workTypesCount / 4.0 :  (NSInteger)roundf(workTypesCount / 4.0 + 0.5));
    
    if (self.isOnlyShowHeaderView) {
        CGFloat collectionViewHeight = (lineCount + 1) * LinePadding + lineCount * ItemHeight + HeaderHegiht ;
        self.collectionViewHeight = collectionViewHeight;
        CGRect rect = CGRectMake(0, TYGetUIScreenHeight, TYGetUIScreenWidth, collectionViewHeight);
        self.collectionView.frame = rect;
        [UIView animateWithDuration:0.5 animations:^{
           
            self.collectionView.y = TYGetUIScreenHeight - collectionViewHeight;
        }];
        
        self.frame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight);
    } else {
        CGFloat collectionViewHeight = (lineCount + 1) * LinePadding + lineCount * ItemHeight + (!self.isOpen ? 0 : FooterHegiht) ;
        self.collectionViewHeight = collectionViewHeight;
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, collectionViewHeight);
        self.collectionView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, collectionViewHeight);
        self.frame = !self.isOpen ? rect: CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - 64);
    }
}

- (NSInteger)getCollectionViewShowCount:(NSInteger)workTypeCount {
    NSInteger count = 0;
//    默认显示的数量
     if (workTypeCount > self.limitCount) {
        count = self.limitCount;
    } else {
        count = self.workTypes.count;
    }
    count = self.isOpen ? workTypeCount : count;
    self.count = count;
    [self didClickedMoreOpenCollective:self.count];//根据数据确定collectionView大小
    return count;
}

//   用于记工记账只显示头部，根据传入的限制确定高度   NO用于工种显示
- (void)recordWorkpointsDidCellShowTime {
    NSMutableArray *times = [NSMutableArray array];
    NSInteger index = 0;
    
//    WageLevelNormalWorkTimeType, //工资标准上班时长
//    WageLevelOverWorkTimeType //工资标准加班时长
    if (self.selectedTimeType == WageLevelNormalWorkTimeType) {
        index = 4;
    }else if (self.selectedTimeType == WageLevelOverWorkTimeType) {
        index = 1;
    }
    for (NSInteger i = index; i <= self.timeModel.endTime; i ++) {
        if (i > 0) {
            JGJShowTimeModel *timeModel = [[JGJShowTimeModel alloc] init];
            NSString *workTimeDetail = ((i == self.timeModel.limitTime) ? @"\n(1个工)" :(i == self.timeModel.limitTime / 2.0 ? @"\n(0.5个工)" : @""));
//            timeModel.timeStr = (self.selectedTimeType == OverWorkTimeType && i == 0) ? @"无加班" : [NSString stringWithFormat:@"%ld小时%@", (unsigned long)i, self.timeModel.isShowWorkTime?workTimeDetail:@""];

            if (_isShowZero) {
                timeModel.timeStr = (self.selectedTimeType == OverWorkTimeType && i == 0) ? @"无加班" : [NSString stringWithFormat:@"%ld.0小时%@", (unsigned long)i, self.timeModel.isShowWorkTime?workTimeDetail:@""];
            }else{
                timeModel.timeStr = (self.selectedTimeType == OverWorkTimeType && i == 0) ? @"无加班" : [NSString stringWithFormat:@"%ld小时%@", (unsigned long)i, self.timeModel.isShowWorkTime?workTimeDetail:@""];
            }
            
            timeModel.time = i;
            timeModel.isSelected = (i == self.timeModel.currentTime);
            [times addObject:timeModel];
            
            //处理无加班情况,和正常上班休息情况
        }
        
        //            处理半点时间
        if (!self.timeModel.isIntHour && i < self.timeModel.endTime) {
            CGFloat halfTime = i + 0.5;
            JGJShowTimeModel *halfTimeModel = [[JGJShowTimeModel alloc] init];
            NSString *workTimeDetail = (halfTime == self.timeModel.limitTime / 2.0 ? @"\n(0.5个工)" : @"");
            halfTimeModel.timeStr = [NSString stringWithFormat:@"%.1f小时%@", halfTime, self.timeModel.isShowWorkTime?workTimeDetail:@""];
            halfTimeModel.time = halfTime;
            halfTimeModel.isSelected = (halfTime == self.timeModel.currentTime);
            [times addObject:halfTimeModel];
        }
    }
    
//    NormalWorkTimeType = 1,
//    OverWorkTimeType,
    
    if (self.selectedTimeType == NormalWorkTimeType || self.selectedTimeType == OverWorkTimeType) {
        JGJShowTimeModel *workTimeModel = [[JGJShowTimeModel alloc] init];
        workTimeModel.time = 0;
        workTimeModel.timeStr = self.selectedTimeType == OverWorkTimeType ? @"无加班" :@"休息";
        workTimeModel.isSelected = (workTimeModel.time == self.timeModel.currentTime);
        [times addObject:workTimeModel];
    }
    
    self.timeModels =  [JGJShowTimeModel mj_objectArrayWithKeyValuesArray:times];
    [self didClickedMoreOpenCollective:self.timeModels.count];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.isOnlyShowHeaderView) {
        
        [self removeFromSuperview];
    } else {
        
        self.isOpen = NO;
        [self getCollectionViewShowCount:self.workTypes.count];
        [self.collectionView reloadData];
    }
}

@end
