//
//  JGJWorkerHeaderContactsCell.m
//  mix
//
//  Created by celion on 16/4/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkerHeaderContactsCell.h"
#import "UILabel+GNUtil.h"

@interface JGJWorkerHeaderContactsCell ()

@property (weak, nonatomic) IBOutlet UILabel *contactFriends;
@end

@implementation JGJWorkerHeaderContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contactFriends.font = [UIFont systemFontOfSize:AppFont28Size];
    self.contactFriends.textColor = AppFont666666Color;
}

-(void)setJlgFHLeaderDetailModel:(JLGFHLeaderDetailModel *)jlgFHLeaderDetailModel {
    _jlgFHLeaderDetailModel = jlgFHLeaderDetailModel;
    NSMutableString *namesStr = [NSMutableString string];
    NSInteger count = jlgFHLeaderDetailModel.contacts.count;
    if (count >= 2) {
        for (int i = 0; i < 2; i ++) {
            FindResultModel *contactModel = jlgFHLeaderDetailModel.contacts[i];
            [namesStr appendString:@" "];
            [namesStr appendString:contactModel.friendname];
        }
    } else if (count == 1) {
        FindResultModel *contactModel = jlgFHLeaderDetailModel.contacts[0];
        [namesStr appendString:contactModel.friendname];
    } else {
        return;
    }
    self.contactFriends.text = [NSString stringWithFormat:@"您的朋友  %@  等认识他", namesStr];
    [self.contactFriends markText:namesStr withColor:AppFont333333Color];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
