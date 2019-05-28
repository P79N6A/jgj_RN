//
//  JGJTOPHeadview.h
//  mix
//
//  Created by Tony on 2016/12/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"

@interface JGJTOPHeadview : UIView
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *realName;
@property (strong, nonatomic) IBOutlet UILabel *TimeLable;
@property(strong ,nonatomic)NSMutableDictionary *dic;
@property (nonatomic ,strong)JGJChatMsgListModel *listModel;

@end
