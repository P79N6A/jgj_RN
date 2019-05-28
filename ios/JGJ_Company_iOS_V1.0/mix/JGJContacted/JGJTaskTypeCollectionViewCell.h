//
//  JGJTaskTypeCollectionViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/6/26.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJTaskTypeCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *taskTypeLable;
@property(nonatomic ,strong)NSString *mjSTR;
@property(nonatomic ,strong)JGJChatMsgListModel *model;
@property (strong, nonatomic) IBOutlet UILabel *taskLable;

-(float)RowHeight;
@property (assign, nonatomic)  BOOL taskType;
@end
