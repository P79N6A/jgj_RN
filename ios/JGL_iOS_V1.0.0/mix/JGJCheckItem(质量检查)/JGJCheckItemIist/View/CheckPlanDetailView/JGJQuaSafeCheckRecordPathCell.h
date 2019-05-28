//
//  JGJQuaSafeCheckRecordPathCell.h
//  JGJCompany
//
//  Created by yj on 2017/11/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJQuaSafeCheckRecordPathCell;

@protocol JGJQuaSafeCheckRecordPathCellDelegate <NSObject>

@optional

- (void)JGJQuaSafeCheckRecordPathCell:(JGJQuaSafeCheckRecordPathCell *)cell listModel:(JGJInspectPlanRecordPathReplyModel *)listModel;

-(void)JGJQuaSafeCheckRecordPathCell:(JGJQuaSafeCheckRecordPathCell *)cell imageViews:(NSArray *)imageViews didSelectedIndex:(NSInteger)index;

@end

@interface JGJQuaSafeCheckRecordPathCell : UITableViewCell

@property (nonatomic, strong) JGJInspectPlanRecordPathReplyModel *listModel;

@property (weak, nonatomic) IBOutlet UIView *rightTopLineView;

@property (weak, nonatomic) IBOutlet UIView *rightBottomLineView;

@property (weak, nonatomic) id <JGJQuaSafeCheckRecordPathCellDelegate> delegate;
@end
