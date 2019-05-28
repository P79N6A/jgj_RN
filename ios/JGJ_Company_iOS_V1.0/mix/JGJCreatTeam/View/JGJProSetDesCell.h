//
//  JGJProSetDesCell.h
//  JGJCompany
//
//  Created by yj on 2017/8/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

@interface JGJProSetDesCellModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *detailTitle;

@property (nonatomic, strong) UIColor *detailTitleColor;

@property (nonatomic, assign) BOOL isShowTopLineView;

@property (nonatomic, assign) BOOL isShowBottomLineView;

@property (nonatomic, copy) NSString *flagImageStr;

@property (nonatomic, assign) BOOL isHiddenImageView;

@end

@interface JGJProSetDesCell : UITableViewCell

@property (nonatomic, strong) JGJProSetDesCellModel *desModel;


@property (weak, nonatomic) IBOutlet LineView *bottomLineView;

@end
