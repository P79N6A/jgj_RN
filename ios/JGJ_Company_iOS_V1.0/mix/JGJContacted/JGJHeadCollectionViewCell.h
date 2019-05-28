//
//  JGJHeadCollectionViewCell.h
//  mix
//
//  Created by Tony on 2016/12/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"
#import "FDAlertView.h"
@protocol ClickHeadWaitDodelegate<NSObject>
-(void)ClicknameLable;
-(void)ClickDetailRightnumberButton:(UIButton *)sender;
-(void)clickDetailPublishManInfo;

@end
@interface JGJHeadCollectionViewCell : UICollectionViewCell
<
UIAlertViewDelegate,
FDAlertViewDelegate
>
@property (strong, nonatomic) IBOutlet UIButton *waitDoButton;
@property (strong, nonatomic) IBOutlet UIButton *ImageButton;
@property (strong, nonatomic) IBOutlet UILabel *NameLable;
@property (strong, nonatomic) IBOutlet UILabel *TimeLable;
@property (strong, nonatomic) IBOutlet UIImageView *PhotoImage;
@property (strong, nonatomic) IBOutlet UILabel *DepatLable;
@property(nonatomic ,strong)JGJChatMsgListModel *model;
@property(nonatomic,weak)id <ClickHeadWaitDodelegate> delegate;
@property(nonatomic,assign)BOOL closeTeam;

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@end
