//
//  JGJDownLoadBillTableViewCell.h
//  mix
//
//  Created by Tony on 2016/7/5.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYModel.h"

@interface DownLoadBillModel : TYModel
@property (nonatomic,assign) NSInteger role;
@property (nonatomic,assign) NSInteger year;
@property (nonatomic,assign) NSInteger month;
@property (nonatomic,assign) NSInteger cur_uid;
@property (nonatomic,copy)   NSString *type;
@end

@class JGJDownLoadBillTableViewCell;
@protocol JGJDownLoadBillTableViewCellDelegate <NSObject>
- (void)DownBillBtnClick:(JGJDownLoadBillTableViewCell *)downCell;
@end

@interface JGJDownLoadBillTableViewCell : UITableViewCell
@property (nonatomic , weak) id<JGJDownLoadBillTableViewCellDelegate> delegate;
@property (nonatomic , strong) DownLoadBillModel *downLoadBillModel;
@end
