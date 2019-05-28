//
//  JGJRecordWorkPointsFilterView.h
//  mix
//
//  Created by yj on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJRecordWorkPointsFilterProButtonType = 1,
    
    JGJRecordWorkPointsFilterMemberButtonType,

} JGJRecordWorkPointsFilterButtonType;

typedef void(^JGJRecordWorkPointsFilterViewBlock)(JGJSynBillingModel *memberModel, JGJRecordWorkPointFilterModel *proModel);

@interface JGJRecordWorkPointsFilterView : UIView

//全部的项目
@property (nonatomic, strong) NSArray *allPros;

//全部的班组长
@property (nonatomic, strong) NSArray *allMembers;


@property (nonatomic, copy) JGJRecordWorkPointsFilterViewBlock recordWorkPointsFilterViewBlock;

//默认选中参数
@property (nonatomic, strong) JGJRecordWorkStaListModel *staListModel;

//代理班组长
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;

//移除筛选界面
- (void)removeFilterView;

@end
