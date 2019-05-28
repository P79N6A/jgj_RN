//
//  JGJComImageTitleCell.h
//  mix
//
//  Created by yj on 2018/12/17.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJComImageTitleModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *detailTitle;

@end

@interface JGJComImageTitleCell : UITableViewCell

@property (nonatomic, strong) JGJMineInfoThirdModel *infoModel;

@end
