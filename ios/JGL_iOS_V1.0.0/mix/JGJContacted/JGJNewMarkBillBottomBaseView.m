//
//  JGJNewMarkBillBottomBaseView.m
//  mix
//
//  Created by Tony on 2018/5/22.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJNewMarkBillBottomBaseView.h"
#import "JGJNewMarkBillBottonBaseCollectionCell.h"
@interface JGJNewMarkBillBottomBaseView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation JGJNewMarkBillBottomBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    

    // 是否是班组长
    if (JLGisLeaderBool) {
        
        self.dataSource = @[
                            @[
                              @{@"title":@"记工流水",@"image":@"markBillWater",@"isShowDetail":@(0)},
                              @{@"title":@"记工统计",@"image":@"markBillTotal",@"isShowDetail":@(0)},
                              @{@"title":@"未结工资",@"image":@"OutstandingWages",@"isShowDetail":@(0)}
                              ],
                            
                            @[
                              @{@"title":@"我要对账",@"image":@"reconciliationIcon",@"isShowDetail":@(0)},
                              @{@"title":@"工人管理",@"image":@"employeeManagement",@"isShowDetail":@(1)},
                              @{@"title":@"晒工天",@"image":@"markBillShowWorkDay",@"isShowDetail":@(0)},
                              ],
                            
                            @[
                              @{@"title":@"同步记工",@"image":@"homeMarkBillSyc",@"isShowDetail":@(0)},
                              @{@"title":@"记工设置",@"image":@"markBillSettingUpType",@"isShowDetail":@(0)},
                              @{@"title":@"记工说明",@"image":@"markBillExplainType",@"isShowDetail":@(0)}
                              ]
     
                            ];
    }else {
        
        self.dataSource = @[
                            @[
                                @{@"title":@"记工流水",@"image":@"markBillWater",@"isShowDetail":@(0)},
                                @{@"title":@"记工统计",@"image":@"markBillTotal",@"isShowDetail":@(0)},
                                @{@"title":@"未结工资",@"image":@"OutstandingWages",@"isShowDetail":@(0)}
                            ],
                           
                            @[
                                @{@"title":@"我要对账",@"image":@"reconciliationIcon",@"isShowDetail":@(0)},
                                @{@"title":@"班组长",@"image":@"employeeManagement",@"isShowDetail":@(1)},
                                @{@"title":@"晒工天",@"image":@"markBillShowWorkDay",@"isShowDetail":@(0)},
                              ],
                            
                            @[
                                @{@"title":@"记工设置",@"image":@"markBillSettingUpType",@"isShowDetail":@(0)},
                                @{@"title":@"记工说明",@"image":@"markBillExplainType",@"isShowDetail":@(0)}
                              ]
                            ];
        
    }
    
    [self addSubview:self.collectionView];
    [self.collectionView reloadData];
}

#pragma mark - 更新选择类型
- (void)updateAccountSelType {
    
    [self initializeAppearance];
}

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置collectionView的滚动方向，需要注意的是如果使用了collectionview的headerview或者footerview的话， 如果设置了水平滚动方向的话，那么就只有宽度起作用了了
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumInteritemSpacing = 0;// 垂直方向的间距
        layout.minimumLineSpacing = 0; // 水平方向的间距
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[JGJNewMarkBillBottonBaseCollectionCell class] forCellWithReuseIdentifier:@"cellId"];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        
    }
    return _collectionView;
}

- (NSArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [[NSArray alloc] init];
    }
    return _dataSource;
}

- (void)setModel:(JGJRecordMonthBillModel *)model{
    
    if (!_model) {
        
        _model = [[JGJRecordMonthBillModel alloc]init];
    }
    _model = model;
    
    [self.collectionView reloadData];
}


- (void)setType:(NSInteger)type {
    
    _type = type;
    [self.collectionView reloadData];
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    NSArray *sectionArr = self.dataSource[section];
    return sectionArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGJNewMarkBillBottonBaseCollectionCell *cell = (JGJNewMarkBillBottonBaseCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.type = _type;
    cell.wait_confirm_num = _wait_confirm_num;
    cell.dicInfo = self.dataSource[indexPath.section][indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = _model;
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(TYGetUIScreenWidth / 3, TYGetUIScreenWidth / 3);
    
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (JLGisLeaderBool) {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {// 记工流水
                
                self.didSelectMarkBillBlock(JGJMarkBillWaterType);
                
            }else if (indexPath.row == 1) {// 记工统计
                
                self.didSelectMarkBillBlock(JGJMarkBillTotalType);
                
            }else if (indexPath.row == 2) {// 未结工资
                
                self.didSelectMarkBillBlock(JGJRemaingAmountType);
                
            }
            
        }else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {// 我要对账
                
                self.didSelectMarkBillBlock(JGJMarkBillGoToAccountCheckingType);
                
            }else if (indexPath.row == 1) {// 工人管理
                
                self.didSelectMarkBillBlock(JGJMarkBillWorkerManagement);
                
            }else if (indexPath.row == 2) {// 晒工天
                
                self.didSelectMarkBillBlock(JGJShowWarkDayType);
                
            }
            
        }else {
            
            if (indexPath.row == 0) {// 同步记工
                
                self.didSelectMarkBillBlock(JGJMarkBillSynchronizationType);
                
            }else if (indexPath.row == 1) {// 记工设置
                
                self.didSelectMarkBillBlock(JGJMarkBillSettingUpType);
                
            }else if (indexPath.row == 2) {// 记工说明
                
                self.didSelectMarkBillBlock(JGJMarkBillExplainType);
            }
        }
        
    }else {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {// 记工流水
                
                self.didSelectMarkBillBlock(JGJMarkBillWaterType);
                
            }else if (indexPath.row == 1) {// 记工统计
                
                self.didSelectMarkBillBlock(JGJMarkBillTotalType);
                
            }else if (indexPath.row == 2) {// 未结工资
                
                self.didSelectMarkBillBlock(JGJRemaingAmountType);
                
            }
            
        }else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {// 我要对账
                
                self.didSelectMarkBillBlock(JGJMarkBillGoToAccountCheckingType);
                
            }else if (indexPath.row == 1) {// 班组长
                
                self.didSelectMarkBillBlock(JGJMarkBillJobForemanType);
                
            }else if (indexPath.row == 2) {// 晒工天
                
                self.didSelectMarkBillBlock(JGJShowWarkDayType);
                
            }
            
        }else {
            
            if (indexPath.row == 0) {// 记工设置
                
                self.didSelectMarkBillBlock(JGJMarkBillSettingUpType);
                
            }else if (indexPath.row == 1) {// 记工说明
                
                self.didSelectMarkBillBlock(JGJMarkBillExplainType);
            }
        }
    }
    
}


@end
