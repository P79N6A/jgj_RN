//
//  JGJCommonDesCell.h
//  mix
//
//  Created by yj on 2018/3/21.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCommonDesCellModel : NSObject

@property (nonatomic, copy) NSString *title;

@end

@interface JGJCommonDesCell : UITableViewCell

@property (nonatomic, strong) JGJCommonDesCellModel *desModel;

@end
