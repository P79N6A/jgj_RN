//
//  JGJRightFromCollectionViewCell.h
//  mix
//
//  Created by Tony on 2017/1/4.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"
@protocol ClickDetailButtondelegate<NSObject>
-(void)ClickDetailLeftnumberButton:(UIButton *)sender;
-(void)ClickDetailRightnumberButton:(UIButton *)sender;
@end

@interface JGJRightFromCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *departLable;
@property (strong, nonatomic) IBOutlet UILabel *FromLable;
@property (nonatomic,strong) JGJChatMsgListModel *jgjChatListModel;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;
@property (strong, nonatomic) IBOutlet UIButton *reciveButton;
@property(nonatomic,weak)id <ClickDetailButtondelegate> delegate;
//判断是否点击过了
@property (nonatomic ,assign)BOOL isClosedTeamVc;//当前项目组是否已关闭

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *departConstance;
@property (nonatomic ,assign)NSString *hadClick;
@property (nonatomic ,assign)BOOL taskType;//区别是不是任务
-(void)setTaskButtonTYpe;
@end
