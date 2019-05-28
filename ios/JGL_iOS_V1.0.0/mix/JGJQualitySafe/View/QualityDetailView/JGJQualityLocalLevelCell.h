//
//  JGJQualityLocalLevelCell.h
//  mix
//
//  Created by yj on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

@interface JGJQualityLocalModel : NSObject

@property (nonatomic, copy) NSString *flagIcon;

@property (nonatomic, copy) NSString *desTitle;

@property (nonatomic, copy) NSString *changeColorStr;

@property (nonatomic, strong) UIColor *changeColor;

@property (nonatomic, assign) BOOL isHiddenArrowRightImageView;

@end

@interface JGJQualityLocalLevelCell : UITableViewCell

@property (nonatomic, strong) JGJQualityLocalModel *localInfoModel;

@property (weak, nonatomic) IBOutlet LineView *lineView;


@end
