//
//  JGJHadReciveCollectionViewCell.h
//  test
//
//  Created by Tony on 2016/12/30.
//  Copyright © 2016年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"

@protocol ClickreciveButtondelesgate<NSObject>
-(void)ClickDetailLeftButton:(UIButton *)sender;
-(void)ClickDetailRightButton:(UIButton *)sender;
@end

@interface JGJHadReciveCollectionViewCell : UICollectionViewCell
@property(nonatomic ,strong)JGJChatMsgListModel *model;
@property (strong, nonatomic) IBOutlet UILabel *LeftLable;
@property(nonatomic ,strong)NSString *HadStr;
@property (strong, nonatomic) IBOutlet UILabel *RightLable;
@property (strong, nonatomic) IBOutlet UILabel *numLable;
@property(nonatomic ,strong)UIView *lable;
@property (strong, nonatomic) IBOutlet UIButton *hadRecive;
@property (strong, nonatomic) IBOutlet UIButton *DontReply;
@property(nonatomic,weak)id <ClickreciveButtondelesgate> delegate;
@property(nonatomic ,strong)UILabel *leftlable;
@property(nonatomic ,strong)UILabel *rightlable;
@property(nonatomic ,strong)NSString *numpepole;
@property(nonatomic ,assign)BOOL taskType;
@property (nonatomic ,assign)NSString *normalStr;
@property(nonatomic ,strong)NSString *recivepepole;

-(void)setTaskTypeButton;
@end
