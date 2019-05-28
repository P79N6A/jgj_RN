//
//  JGJMoreSelectPeopleTableViewCell.h
//  mix
//
//  Created by Tony on 2017/9/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
@protocol didselectItemAndpeople <NSObject>

-(void)didselectItemAndPeople:(NSMutableArray *)peopleArr;

-(void)jumpTplAndIndexpath:(NSIndexPath *)indexpathss;

-(void)didSelectIndexpath:(NSIndexPath *)selectIndexpath;

- (void)didSelectedAllWokerWithIsHaveChoiceAllSelected:(BOOL)isSelectedAll;// 全选或者取消全选

-(void)didSelectAddWorkerToTeam:(NSIndexPath *)selectIndexpath;

- (void)didSelectDelWorker;// 点击删除工人按钮

-(void)desSelectWorker:(JgjRecordMorePeoplelistModel *)Model;//取消这个人的选中

@end
@interface JGJMoreSelectPeopleTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;

@property (nonatomic ,strong)JGJFirstMorePeoplelistModel *listModel;

@property (nonatomic ,strong)NSMutableArray <JgjRecordMorePeoplelistModel *>*peopleArr;
/*
 *点击薪资模板回来重新选中
 */
@property (nonatomic ,strong)NSMutableArray <JgjRecordMorePeoplelistModel *>*selectedArr;
/*
 *点击添加人回来重新选中
 */
@property (nonatomic ,strong)NSMutableArray <JgjRecordMorePeoplelistModel *>*addPeopleArr;
/*
 *用于设置多个人
 */
@property (nonatomic ,strong)NSMutableArray <JgjRecordMorePeoplelistModel *>*moreSelectedArr;

@property (nonatomic ,strong)id <didselectItemAndpeople> delegate;

@property (nonatomic ,strong)YZGGetBillModel *jlgGetBillModel;

// 为记工 工人数量
@property (nonatomic, strong) NSString *manNum;

// 当前选择为点工还是包工记工天
@property (nonatomic, assign) BOOL isLittleWorkOrContractorAttendance;

// 当前选择的时间用于和is_double配合，处理弹窗显示时间问题
@property (nonatomic, strong) NSString *currentRecordeTimeStr;

@end
