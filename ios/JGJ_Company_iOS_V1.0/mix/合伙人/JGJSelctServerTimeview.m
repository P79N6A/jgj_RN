//
//  JGJSelctServerTimeview.m
//  JGJCompany
//
//  Created by Tony on 2017/7/29.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSelctServerTimeview.h"
#import "JGJWorkTypeCell.h"
#import "JGJReusableFooterView.h"
#import "JGJReusableHeaderView.h"
#import "TYFMDB.h"
#import "JLGFHLeaderModel.h"
#import "MJExtension.h"
#import "UIView+GNUtil.h"
#import "NSString+Extend.h"
#define TopViewY (TYIS_IPHONE_4_OR_LESS ? 64 : 0)
@interface JGJSelctServerTimeview ()
<UICollectionViewDataSource, UICollectionViewDelegate>
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
@property (nonatomic, assign) SelectlistedTimeTypess selectedTimeType;//存储选择的类型

@end
@implementation JGJSelctServerTimeview
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

- (instancetype)initWithFrame:(CGRect)frame timeModel:(JGJShowTimeModel *)timeModel SelectedTimeType:(SelectlistedTimeTypess)selectedTimeType isOnlyShowHeaderView:(BOOL)isOnlyShowHeaderView blockSelectedTime:(void(^)(JGJShowTimeModel *timeModel)) blockSelectedTime {
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
    if (_timeModel.ispayModel) {
//        return  11 - (int)_timeModel.currentTime / 180;
        if (_timeModel.currentTime < 90) {
            return 8;
        }else if (_timeModel.currentTime >= 90 &&_timeModel.currentTime < 180)
        {
            return 7;
        }else if (_timeModel.currentTime >= 180 && _timeModel.currentTime < 360){
        
            return 6;
        }else{
        
            return 1 + 5 - (int)(_timeModel.currentTime/360);
        }
        return  0;
//        return [self getCollectionViewShowCount:self.workTypes.count];
    }else{
    
        return 7;
    }
//    return self.isOnlyShowHeaderView ? self.timeModels.count - 1 : [self getCollectionViewShowCount:self.workTypes.count];
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
    if (self.selectedTimeType >= NormalWorkTimeTypes) {
        
        void(^blockTimeModel)(JGJShowTimeModel *) = self.blockSelectedTime;
        JGJShowTimeModel *timeModel = self.timeModels[indexPath.row];
        //此处添加
        if ((self.timeModel.ispayModel && indexPath.row == 0) || (self.timeModel.ispayModel &&timeModel.time == 90)) {
            timeModel.isDaySelect = YES;
        }else if(indexPath.row == 0){
            timeModel.isDaySelect = YES;
        }
        
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
        if (self.selectedTimeType == WageLevelNormalWorkTimeType || self.selectedTimeType == NormalWorkTimeTypes) {
            header.titleLable.text = self.timeModel.titleStr;
        }else {
            header.titleLable.text = self.timeModel.timeStr?:[NSString stringWithFormat:@"选择%@时长", self.selectedTimeType == NormalWorkTimeTypes ? @"上班" : @"加班"];
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
    
    
    
    
    if (self.timeModel.ispayModel  && _timeModel.currentTime > 0 ) {
    return 11 - (int)_timeModel.currentTime / 180;
    }
    
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
    if (self.timeModel.ispayModel) {
//        index = (int)roundf(_timeModel.currentTime / 180) - 1;
        if (_timeModel.currentTime < 90) {
            
            index = 0;
        }else if (_timeModel.currentTime >= 90 &&_timeModel.currentTime < 180)
        {
            index = 1;
        }else if (_timeModel.currentTime >= 180 && _timeModel.currentTime < 360){
            
            index = 2;
        }else{
            
            index = 1 + 5 - (int)(_timeModel.currentTime/360);
        }

        for (NSInteger i = index; i <= self.timeModel.endTime + 2; i ++) {
            JGJShowTimeModel *halfTimeModel = [[JGJShowTimeModel alloc] init];

            if (index == 0) {
                if (i==0) {
                    halfTimeModel.timeStr = [NSString stringWithFormat:@"%.0f 天", _timeModel.currentTime];
                    halfTimeModel.time = _timeModel.currentTime;
                    [times addObject:halfTimeModel];
                }else if (i == 1){
                    halfTimeModel.timeStr = @"3个月";
                    halfTimeModel.time = 90;
                    [times addObject:halfTimeModel];
                }else if(i == 2){
                    halfTimeModel.timeStr = @"0.5年(半年)";
                    halfTimeModel.time = 0.5;
                    [times addObject:halfTimeModel];
                }else{
                    halfTimeModel.timeStr = [NSString stringWithFormat:@"%ld年",i-2];
                    halfTimeModel.time = (i - 2) ;
                    [times addObject:halfTimeModel];
                }
            }else if (index == 1){
                if (i==1) {
                    halfTimeModel.timeStr = [NSString stringWithFormat:@"%.0f 天", _timeModel.currentTime];
                    halfTimeModel.time = _timeModel.currentTime;
                    [times addObject:halfTimeModel];
                }else if (i == 2){
                    halfTimeModel.timeStr = @"0.5年(半年)";
                    halfTimeModel.time = 0.5;
                    [times addObject:halfTimeModel];
                }else{
                    halfTimeModel.timeStr = [NSString stringWithFormat:@"%ld年",i-2];
                    halfTimeModel.time = (i - 2) ;
                    [times addObject:halfTimeModel];
                }
                
            }else if (index == 2){
                if (i==2) {
                    halfTimeModel.timeStr = [NSString stringWithFormat:@"%.0f 天", _timeModel.currentTime];
                    halfTimeModel.time = _timeModel.currentTime;
                    [times addObject:halfTimeModel];
                }else{
                    halfTimeModel.timeStr = [NSString stringWithFormat:@"%ld年",i-2];
                    halfTimeModel.time = (i - 2) ;
                    [times addObject:halfTimeModel];
                }
                
            }else{
                halfTimeModel.timeStr = [NSString stringWithFormat:@"%ld年",i-2];
                halfTimeModel.time = (i - 2) ;
                [times addObject:halfTimeModel];

            }
            /*
            if (times.count == 0) {
                halfTimeModel.timeStr = [NSString stringWithFormat:@"%.0f 天", _timeModel.currentTime];
                halfTimeModel.time = _timeModel.currentTime;
                [times addObject:halfTimeModel];
   
            }else {
                if (index == 0) {
                    
                }
                
            CGFloat halfTime = i ;
                if (halfTime == (int)halfTime) {
                    halfTimeModel.timeStr = [NSString stringWithFormat:@"%.0f 年 ", halfTime];

                }else{
                    halfTimeModel.timeStr = [NSString stringWithFormat:@"%.1f 年 ", halfTime];

                }
#pragma mark - 增加个半年
                 halfTimeModel.time = halfTime;
                if (halfTimeModel.time == 0.5) {
                    halfTimeModel.timeStr = @"0.5年(半年)";
                }
           
            halfTimeModel.isSelected = (halfTime == self.timeModel.currentTime);
            [times addObject:halfTimeModel];
            }*/
        
        }
        /*
         index = (int)_timeModel.currentTime / 360;
         if ((_timeModel.currentTime / 180) > 1) {
         index = index + 1;
         }
         
         
        for (NSInteger i = index; i <= self.timeModel.endTime; i ++) {
            
            NSLog(@"---======== int %ld",(long)i);
            if (i > 0) {
                JGJShowTimeModel *timeModel = [[JGJShowTimeModel alloc] init];
                NSString *workTimeDetail = ((i == self.timeModel.limitTime) ? @"\n" :(i == self.timeModel.limitTime / 2.0 ? @"\n" : @""));
                if (times.count == 0) {

                timeModel.timeStr =   [NSString stringWithFormat:@"%.0f", self.timeModel.currentTime];
                timeModel.time = _timeModel.currentTime;
                timeModel.isSelected = (i == self.timeModel.currentTime);
                }else{
                if (_isShowZero) {
                timeModel.timeStr = (self.selectedTimeType == OverWorkTimeTypes && i == 0) ? @"" : [NSString stringWithFormat:@"%ld年%@", (unsigned long)i, self.timeModel.isShowWorkTime?workTimeDetail:@""];
                    }else{
                timeModel.timeStr = (self.selectedTimeType == OverWorkTimeTypes && i == 0) ? @"" : [NSString stringWithFormat:@"%ld年%@", (unsigned long)i, self.timeModel.isShowWorkTime?workTimeDetail:@""];
                    }

                timeModel.time = i;
                timeModel.isSelected = (i == self.timeModel.currentTime);
                    
                }
                [times addObject:timeModel];

                //处理无加班情况,和正常上班休息情况
            }
            
            //            处理半点时间
            
            if (!self.timeModel.isIntHour && i < self.timeModel.endTime) {
                
                CGFloat halfTime = i + 0.5;
                NSLog(@"---======== float %f",halfTime);

                JGJShowTimeModel *halfTimeModel = [[JGJShowTimeModel alloc] init];
                NSString *workTimeDetail = (halfTime == self.timeModel.limitTime / 2.0 ? @"\n年" : @"");
                
                if (times.count == 0) {
                halfTimeModel.timeStr = [NSString stringWithFormat:@"%.1f %.0f", halfTime, _timeModel.currentTime];
//                halfTimeModel.timeStr = [NSString stringWithFormat:@"%.0f", _timeModel.currentTime];

                halfTimeModel.time = _timeModel.currentTime;
                halfTimeModel.isSelected = (halfTime == self.timeModel.currentTime);
                }else{
                halfTimeModel.timeStr = [NSString stringWithFormat:@"%.1f年%@", halfTime, self.timeModel.isShowWorkTime?workTimeDetail:@""];
                
                halfTimeModel.time = halfTime;
                halfTimeModel.isSelected = (halfTime == self.timeModel.currentTime);
                
                }
                [times addObject:halfTimeModel];
                
            }
        }
  */
    }else{
        for (NSInteger i = 0; i <= 7 ; i ++) {
            JGJShowTimeModel *halfTimeModel = [[JGJShowTimeModel alloc] init];
            
            if (i == 0) {
                halfTimeModel.timeStr = @"3个月";
                halfTimeModel.time = 90;
                [times addObject:halfTimeModel];
                
            }else if(i == 1){
                
                CGFloat halfTime = i * 0.5;
                if (halfTime == (int)halfTime) {
                    halfTimeModel.timeStr = [NSString stringWithFormat:@"%.0f 年 ", halfTime];
                    
                }else{
                    halfTimeModel.timeStr = [NSString stringWithFormat:@"%.1f 年 ", halfTime];
                    
                }
                halfTimeModel.time = halfTime;
                if (halfTimeModel.time == 0.5) {
                    halfTimeModel.timeStr = @"0.5年(半年)";
                }
                
                halfTimeModel.isSelected = (halfTime == self.timeModel.currentTime);
                [times addObject:halfTimeModel];
            }else if (i == 2)
            {
                halfTimeModel.timeStr = @"1年";
                halfTimeModel.time = 1;
                [times addObject:halfTimeModel];
            
            
            }else if (i == 3)
            {
                halfTimeModel.timeStr = @"2年";
                halfTimeModel.time = 2;
                [times addObject:halfTimeModel];
                
                
            }
            else if (i == 4)
            {
                halfTimeModel.timeStr = @"3年";
                halfTimeModel.time = 3;
                [times addObject:halfTimeModel];
                
                
            }
            else if (i == 5)
            {
                halfTimeModel.timeStr = @"4年";
                halfTimeModel.time = 4;
                [times addObject:halfTimeModel];
                
                
                
                
            }else if (i == 6){
                halfTimeModel.timeStr = @"5年";
                halfTimeModel.time = 5;
                [times addObject:halfTimeModel];
                
            
            }

            
        }

        /*
    for (NSInteger i = index; i <= self.timeModel.endTime; i ++) {
        if (i > 0) {
            JGJShowTimeModel *timeModel = [[JGJShowTimeModel alloc] init];
            NSString *workTimeDetail = ((i == self.timeModel.limitTime) ? @"\n" :(i == self.timeModel.limitTime / 2.0 ? @"\n" : @""));
            //            timeModel.timeStr = (self.selectedTimeType == OverWorkTimeType && i == 0) ? @"无加班" : [NSString stringWithFormat:@"%ld小时%@", (unsigned long)i, self.timeModel.isShowWorkTime?workTimeDetail:@""];
            
            if (_isShowZero) {
                timeModel.timeStr = (self.selectedTimeType == OverWorkTimeTypes && i == 0) ? @"" : [NSString stringWithFormat:@"%ld年%@", (unsigned long)i, self.timeModel.isShowWorkTime?workTimeDetail:@""];
            }else{
                timeModel.timeStr = (self.selectedTimeType == OverWorkTimeTypes && i == 0) ? @"" : [NSString stringWithFormat:@"%ld年%@", (unsigned long)i, self.timeModel.isShowWorkTime?workTimeDetail:@""];
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
            NSString *workTimeDetail = (halfTime == self.timeModel.limitTime / 2.0 ? @"\n年" : @"");
            halfTimeModel.timeStr = [NSString stringWithFormat:@"%.1f年%@", halfTime, self.timeModel.isShowWorkTime?workTimeDetail:@""];
            halfTimeModel.time = halfTime;
            halfTimeModel.isSelected = (halfTime == self.timeModel.currentTime);
#pragma mark - 增加个半年
            if (halfTimeModel.time == 0.5) {
                halfTimeModel.timeStr = @"0.5年(半年)";
            }
            [times addObject:halfTimeModel];
        }
    }*/
    }
    //    NormalWorkTimeType = 1,
    //    OverWorkTimeType,
    
    if (self.selectedTimeType == NormalWorkTimeTypes || self.selectedTimeType == OverWorkTimeTypes) {
        JGJShowTimeModel *workTimeModel = [[JGJShowTimeModel alloc] init];
        workTimeModel.time = 0;
        workTimeModel.timeStr = self.selectedTimeType == OverWorkTimeTypes ? @"" :@"";
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
