//
//  JGJChatWorkMyBusinessCardCell.h
//  mix
//
//  Created by ccclear on 2019/3/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatListBaseCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface JGJChatWorkMyBusinessCardCell : JGJChatListBaseCell

@property (nonatomic, strong) JGJChatMsgListModel *chatListModel;

@property (weak, nonatomic) IBOutlet UIImageView *popImageView;

@end

NS_ASSUME_NONNULL_END
