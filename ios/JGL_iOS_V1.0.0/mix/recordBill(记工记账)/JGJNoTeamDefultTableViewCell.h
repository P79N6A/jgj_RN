//
//  JGJNoTeamDefultTableViewCell.h
//  mix
//
//  Created by Tony on 2017/9/26.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJNoTeamDefultTableViewCellDelegate <NSObject>
-(void)JGJNoTeamDefultTableViewClickCreateTeamButton;
-(void)JGJNoTeamDefultTableViewClickUserCaseTeamButton;
@end
@interface JGJNoTeamDefultTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *createButton;

@property (weak, nonatomic) IBOutlet UILabel *des;

@property (weak, nonatomic) IBOutlet UIButton *userCaseBtn;
@property (weak, nonatomic) IBOutlet UILabel *userCaseDetail;

@property (nonatomic ,strong) id <JGJNoTeamDefultTableViewCellDelegate>delegate;
@end
