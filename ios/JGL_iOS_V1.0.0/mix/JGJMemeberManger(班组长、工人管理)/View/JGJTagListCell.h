//
//  JGJTagListCell.h
//  mix
//
//  Created by yj on 2018/4/24.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomView.h"

#import "JGJMemberMangerModel.h"

@interface JGJTagListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (strong, nonatomic) JGJMemberImpressTagViewModel *tagModel;

@end
