//
//  JGJNotificationDetailTableViewCell.h
//  mix
//
//  Created by Tony on 2016/12/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"

//这个是通知详情的回复cell布局
@interface JGJNotificationDetailTableViewCell : UITableViewCell
//@property (strong, nonatomic) IBOutlet UILabel *TimeLable;
//
//@property (strong, nonatomic) IBOutlet UILabel *NameLable;
//@property (strong, nonatomic) IBOutlet UILabel *DesLable;
@property (nonatomic ,strong)JGJChatMsgListModel *listModel;
@property (nonatomic ,strong)NSMutableDictionary *DataArray;
@property(nonatomic ,strong)UILabel *RealNameLable;
@property(nonatomic ,strong)UILabel *Timelable;
@property(nonatomic ,strong)UILabel *desLable;

-(float)getheight;
@end
