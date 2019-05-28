//
//  JGJCheckAccountModulesCell.h
//  mix
//
//  Created by yj on 2018/8/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJCheckAccountModulesView.h"

@class JGJCheckAccountModulesCell;

@protocol JGJCheckAccountModulesCellDelegate <NSObject>

@optional

- (void)checkAccountModulesCell:(JGJCheckAccountModulesCell *)cell JGJCheckAccountModulesButtontype:(JGJCheckAccountModulesButtontype)buttonType;

@end

@interface JGJCheckAccountModulesCell : UITableViewCell

@property (weak, nonatomic) id <JGJCheckAccountModulesCellDelegate> delegate;

@property (weak, nonatomic,readonly) IBOutlet JGJCheckAccountModulesView *modulesView;

@property (strong, nonatomic) JGJHomeWorkRecordTotalModel *recordTotalModel;

+(CGFloat)checkAccountModulesCellHeight;

@end
