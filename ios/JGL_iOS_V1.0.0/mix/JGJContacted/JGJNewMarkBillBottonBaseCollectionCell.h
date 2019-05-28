//
//  JGJNewMarkBillBottonBaseCollectionCell.h
//  mix
//
//  Created by Tony on 2018/5/22.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJNewMarkBillBottonBaseCollectionCell : UICollectionViewCell

@property (nonatomic, copy) NSDictionary *dicInfo;
@property (strong, nonatomic)  JGJRecordMonthBillModel *model;
//0.上班按工天、加班按小时 1.按工天, 2. 按小时
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *wait_confirm_num;
@end
