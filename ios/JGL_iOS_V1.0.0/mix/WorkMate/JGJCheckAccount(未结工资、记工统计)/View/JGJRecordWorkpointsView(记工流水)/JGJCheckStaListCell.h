//
//  JGJCheckStaListCell.h
//  mix
//
//  Created by yj on 2018/6/4.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCheckStaListCellModel : NSObject

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *nextImageStr;

@property (assign, nonatomic) CGFloat topLineHeight;

@property (assign, nonatomic) CGFloat bottomLineHeight;

@property (strong, nonatomic) UIColor *bottomLineColor;

@property (strong, nonatomic) UIColor *topLineColor;

@end

@interface JGJCheckStaListCell : UITableViewCell

@property (nonatomic, strong) JGJCheckStaListCellModel *desInfoModel;

+(CGFloat)cellHeight;

@end
