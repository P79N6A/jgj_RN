//
//  JGJTeamListTableViewCell.h
//  mix
//
//  Created by Tony on 2017/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJAvatarView.h"

@interface JGJTeamListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *desciptionLable;
@property (nonatomic ,strong)NSString *dsec;
@property (strong, nonatomic) IBOutlet UILabel *leftLbale;
@property (nonatomic ,strong)JgjRecordlistModel *modellist;
@property (strong, nonatomic) IBOutlet UIImageView *selectImageView;

//@property (weak, nonatomic) IBOutlet JGJAvatarView *avatarView;

@property (nonatomic, copy) NSString *searchValue;


@end
