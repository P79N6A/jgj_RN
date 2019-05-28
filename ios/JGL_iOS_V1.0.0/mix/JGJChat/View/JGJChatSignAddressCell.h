//
//  JGJChatSignAddressCell.h
//  JGJCompany
//
//  Created by Tony on 16/9/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJAddSignModel.h"
#import "CustomView.h"
@interface JGJChatSignAddressCell : UITableViewCell
@property (nonatomic,copy) JGJAddSignModel *addSignModel;

@property (weak, nonatomic) IBOutlet LineView *lineView;
@end
