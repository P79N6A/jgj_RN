//
//  JGJModifyInfoCell.h
//  mix
//
//  Created by yj on 2018/6/11.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TYTextField.h"

@interface JGJModifyInfoModel : NSObject

@property (assign, nonatomic) NSInteger maxLength;

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *des;

@end

@interface JGJModifyInfoCell : UITableViewCell

@property (strong, nonatomic) JGJModifyInfoModel *desModel;

@end
