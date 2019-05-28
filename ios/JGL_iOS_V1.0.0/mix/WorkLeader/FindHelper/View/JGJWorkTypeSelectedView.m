//
//  JGJWorkTypeSelectedView.m
//  mix
//
//  Created by celion on 16/4/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkTypeSelectedView.h"
#import "JGJWorkerHeaderListVC.h"
#import "JGJWorkTypeSelectedCell.h"
#import "TYFMDB.h"
@interface JGJWorkTypeSelectedView () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) id blockWorkTypeModel;
@property (strong, nonatomic) NSArray *workTypes;
@property (strong, nonatomic) FHLeaderWorktypeCity *lastWorkTypeModel;
@property (strong, nonatomic) JGJWorkTypeSelectedCell *selectedCell;
@property (strong, nonatomic) NSIndexPath *lastIndexPath;
@property (assign, nonatomic) BOOL isInitialSelected;
@end

@implementation JGJWorkTypeSelectedView

- (instancetype)initWithFrame:(CGRect)frame workType:(FHLeaderWorktypeCity *)workType blockWorkType:(void (^)(FHLeaderWorktypeCity *))workTypeModel {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.workTypeModel = workType;
        self.blockWorkTypeModel = workTypeModel;
        [self commonSet];
    }
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJWorkTypeSelectedView" owner:self options:nil] lastObject];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    NSArray *workTypes =  [TYFMDB searchTable:TYFMDBWorkTypeName];
    FHLeaderWorktypeCity *allWorkType = [[FHLeaderWorktypeCity alloc] init];
    allWorkType.type_id = -1;//经后台讨论-1表示全部工种
    allWorkType.type_name = @"全部工种";
    FHLeaderWorktypeCity *myWorkType = [[FHLeaderWorktypeCity alloc] init];
    myWorkType.type_id = 0; //经后台讨论0表示我的工种
    myWorkType.type_name = @"我的工种";
    if (!self.workTypes) {
        self.workTypes = [NSArray array];
    }
    BOOL isCompleteInfo = (JLGisMateBool && !JLGMateIsInfoBool) || (JLGisLeaderBool && !JLGLeaderIsInfoBool);
    
    if ((self.workTypeModel.currentPageType == FindHelperType) || isCompleteInfo || !JLGisLoginBool) {
        self.workTypes = [self.workTypes arrayByAddingObjectsFromArray:@[allWorkType]];
    } else {
          self.workTypes = [self.workTypes arrayByAddingObjectsFromArray:@[allWorkType, myWorkType]];
    }
    self.workTypes =  [self.workTypes arrayByAddingObjectsFromArray:[FHLeaderWorktypeCity mj_objectArrayWithKeyValuesArray:workTypes]];
    
    for (int index = 0; index < self.workTypes.count; index ++) {
        FHLeaderWorktypeCity *workType = self.workTypes[index];
        workType.roleStr = self.workTypeModel.roleStr;
        workType.cityNameID = self.workTypeModel.cityNameID;
        workType.cityName = self.workTypeModel.cityName;
        workType.workTypeID = [NSString stringWithFormat:@"%@",@(workType.type_id)];
        
        if ([self.workTypeModel.type_name isEqualToString: workType.type_name]) {
            workType.isSelected = YES;
        }
    }
}

#pragma mark - 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.workTypes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJWorkTypeSelectedCell *cell = [JGJWorkTypeSelectedCell cellWithTableView:tableView];
    self.selectedCell = cell;
    FHLeaderWorktypeCity *workType = self.workTypes[indexPath.row];
    cell.workTypeModel =  workType;
    if (!self.isInitialSelected && workType.isSelected) {
        self.lastIndexPath = indexPath;
        self.isInitialSelected = YES;
    }
      return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    void(^blockWorkType)(FHLeaderWorktypeCity *) = self.blockWorkTypeModel;
    blockWorkType(self.workTypes[indexPath.row]);
    NSIndexPath *temp = self.lastIndexPath;//暂存上一次选中的行
    if(temp && temp!=indexPath)//如果上一次的选中的行存在,并且不是当前选中的这一样,则让上一行不选中
    {
        FHLeaderWorktypeCity*lastWorkTypeModel = self.workTypes[self.lastIndexPath.row];;
        lastWorkTypeModel.isSelected = NO;//修改之前选中的cell的数据为不选中
        [tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationAutomatic];//刷新该行
        
    }
    //选中的修改为当前行
    FHLeaderWorktypeCity *workTypeModel = self.workTypes[indexPath.row];
    self.lastIndexPath = indexPath;
    workTypeModel.isSelected = YES;//修改这个被选中的一行
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];//重新刷新这一行
    [self removeFromSuperview];
}
@end
