//
//  JGJChatSignCreatorCell.h
//  JGJCompany
//
//  Created by Tony on 16/9/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatSignModel.h"

@interface JGJChatSignCreatorCell : UITableViewCell

@property (nonatomic,strong) ChatSign_Sign_List *chatSign_Sign_List;

@property (nonatomic,assign) BOOL isHiddenLineView;

@property (nonatomic,strong) JGJChatSignModel *chatSignModel;

@end
