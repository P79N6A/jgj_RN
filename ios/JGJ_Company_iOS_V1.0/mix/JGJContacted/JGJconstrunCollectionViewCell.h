//
//  JGJconstrunCollectionViewCell.h
//  mix
//
//  Created by Tony on 2017/3/30.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"
@interface JGJconstrunCollectionViewCell : UICollectionViewCell
@property (nonatomic ,strong)UIView *placeView;
@property (nonatomic ,strong)UILabel *weatherLable;
@property (nonatomic ,strong)UILabel *dispartLableone;
@property (nonatomic ,strong)UILabel *sunylablem;
@property (nonatomic ,strong)UILabel *sunylablea;
@property (nonatomic ,strong)UILabel *templable;
@property (nonatomic ,strong)UILabel *templablem;
@property (nonatomic ,strong)UILabel *templablea;
@property (nonatomic ,strong)UILabel *windlable;
@property (nonatomic ,strong)UILabel *windlablem;
@property (nonatomic ,strong)UILabel *windlablea;
@property (nonatomic ,strong)UILabel *noneLable;

@property (nonatomic ,strong)JGJChatMsgListModel *ChatMsgListModel;

@end
