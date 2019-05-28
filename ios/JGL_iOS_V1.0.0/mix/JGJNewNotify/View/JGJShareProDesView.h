//
//  JGJShareProDesView.h
//  JGJCompany
//
//  Created by yj on 16/9/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JGJShareProDesView : UIView
+ (JGJShareProDesView *)shareProDesViewWithProDesModel:(JGJShareProDesModel *)proDesModel;

@property (nonatomic, strong) JGJShareProDesModel *proDesModel;

@property (weak, nonatomic) IBOutlet UILabel *popDetailLable;
@end
