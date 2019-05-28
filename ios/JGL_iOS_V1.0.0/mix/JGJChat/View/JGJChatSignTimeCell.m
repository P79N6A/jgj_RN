//
//  JGJChatSignTimeCell.m
//  JGJCompany
//
//  Created by Tony on 16/9/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatSignTimeCell.h"

@interface JGJChatSignTimeCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation JGJChatSignTimeCell

- (void)setAddSignModel:(JGJAddSignModel *)addSignModel{
    _addSignModel = addSignModel;
    self.timeLabel.text = addSignModel.sign_time;
}

@end
