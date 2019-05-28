//
//  JGJNewContractorListCell.h
//  mix
//
//  Created by Tony on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGGetBillModel.h"
@interface JGJContractorListAttendanceCell : UITableViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, assign) BOOL hiddenLine;
@property (nonatomic, assign) NSInteger cellTag;
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@property (nonatomic, assign) BOOL isMarkBillMore;// 是否记多人进入
@property (nonatomic, assign) BOOL isAgentMonitor;// 是否为代班长
@property (nonatomic, assign) BOOL manGo;
@end
