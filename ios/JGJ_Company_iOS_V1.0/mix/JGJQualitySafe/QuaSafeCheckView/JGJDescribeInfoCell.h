//
//  JGJDescribeInfoCell.h
//  JGJCompany
//
//  Created by yj on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJDescribeInfoModel : NSObject

@property (nonatomic, copy) NSString *desInfo;

@property (nonatomic, copy) NSString *changeColorInfo;

@end

@interface JGJDescribeInfoCell : UITableViewCell

@property (nonatomic, strong) JGJDescribeInfoModel *desInfoModel;

@end
