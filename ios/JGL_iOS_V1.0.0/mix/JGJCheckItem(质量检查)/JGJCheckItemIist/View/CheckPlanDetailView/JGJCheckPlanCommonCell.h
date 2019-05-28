//
//  JGJCheckPlanCommonCell.h
//  JGJCompany
//
//  Created by yj on 2017/11/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

@interface JGJCheckPlanCommonCellModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) CGFloat titleFont;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, copy) NSString *detailTitle;

@property (nonatomic, assign) CGFloat detailFont;

@property (nonatomic, strong) UIColor *detailColor;

@property (nonatomic, strong) UIColor *contentViewBackColor;

@end

@interface JGJCheckPlanCommonCell : UITableViewCell

@property (nonatomic, strong) JGJCheckPlanCommonCellModel *commonModel;

@property (weak, nonatomic) IBOutlet LineView *lineView;

@end
