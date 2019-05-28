//
//  JGJTaskRightFromCollectionViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol clickTaskcellButtondelegate <NSObject>
-(void)ClickDetailLeftnumberButton:(UIButton *)sender;
-(void)ClickDetailRightnumberButton:(UIButton *)sender;
@end
@interface JGJTaskRightFromCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *FromLable;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;
@property (strong, nonatomic) IBOutlet UIButton *reciveButton;
@property (nonatomic,strong) JGJChatMsgListModel *jgjChatListModel;
@property (nonatomic ,assign)BOOL isClosedTeamVc;//当前项目组是否已关闭
@property (nonatomic ,assign)NSString *hadClick;
@property (nonatomic ,assign)BOOL taskType;//区别是不是任务
@property(nonatomic,weak)id <clickTaskcellButtondelegate> delegate;

-(void)setTaskButtonTYpe;
@end
