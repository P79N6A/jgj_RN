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
    NSMutableArray *times = [NSMutableArray array];
    if (self.isOnlyShowHeaderView) {
        NSUInteger index = self.selectedTimeType == NormalWorkTimeType ? 1 : 0;
        
        for (NSUInteger i = index; i <= self.timeModel.limitTime; i ++) {
            
            JGJShowTimeModel *timeModel = [[JGJShowTimeModel alloc] init];
            NSString *workTimeDetail = ((i == self.timeModel.limitTime) ? @"\n(一个工)" :(i == self.timeModel.limitTime / 2 ? @"\n(半个工)" : @""));
            timeModel.timeStr = (self.selectedTimeType == OverWorkTimeType && i == 0) ? @"无加班" : [NSString stringWithFormat:@"%ld小时%@", (unsigned long)i, workTimeDetail];
            timeModel.time = i;
            timeModel.isSelected = (i == self.timeModel.currentTime);
            [times addObject:timeModel];
        }

        self.timeModels =  [JGJShowTimeModel mj_objectArrayWithKeyValuesArray:times];
        [self didClickedMoreOpenCollective:self.timeModels.count];
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
//        __weak typeof(self) weakSelf = self;
        cell.blockSelectedtimeModel = ^(JGJShowTimeModel *timeModel){
            
//            void(^blockTimeModel)(JGJShowTimeModel *) = weakSelf.blockSelectedTime;
//            blockTimeModel(timeModel);
//            [weakSelf removeFromSuperview];
//            NSIndexPath *temp = self.lastIndexPath;//暂存上一次选中的行
//            if(temp && temp!=indexPath)//如果上一次的选中的行存在,并且不是当前选中的这一样,则让上一行不选中
//            {
//                JGJShowTimeModel*lastTimeModel = weakSelf.timeModels[weakSelf.lastIndexPath.row];;
//                lastTimeModel.isSelected = NO;//修改之前选中的cell的数据为不选中
//                [collectionView reloadItemsAtIndexPaths:@[temp]];
//                
//            }
//            //选中的修改为当前行
//            JGJShowTimeModel *currentTimeModel = self.timeModels[indexPath.row];
//            weakSelf.lastIndexPath = indexPath;
//            currentTimeModel.isSelected = YES;//修改这个被选中的一行
//            weakSelf.selectedTimeModel = currentTimeModel;
//            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
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
        header.titleLable.text = [NSString stringWithFormat:@"请选择今天%@时长", self.selectedTimeType == NormalWorkTimeType ? @"上班" : @"加班"];
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
//    if (TYIS_IPHONE_5 || TYIS_IPHONE_4_OR_LESS) {
//        count =  workTypesCount % 3;
//        lineCount = workTypesCount < 3 ? 1 : (count == 0 ? workTypesCount / 3.0 :  (NSInteger)roundf(workTypesCount / 3.0 + 0.5));
//    } else {
//        count = workTypesCount % 4;
//         lineCount = workTypesCount < 3 ? 1 : (count == 0 ? workTypesCount / 4.0 :  (NSInteger)roundf(workTypesCount / 4.0 + 0.5));
//    }
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
