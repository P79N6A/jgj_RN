//
//  JGJNewDetailCollectionViewCell.h
//  test
//
//  Created by Tony on 2016/12/30.
//  Copyright © 2016年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"
#import "JGJCoreTextLable.h"
@protocol JGJNewDetailCollectionViewCellDelegate <NSObject>
-(void)JGJNewDetailCollectionViewCellTapNameLableAndIndexpathRow:(NSInteger)row;
@end
@interface JGJNewDetailCollectionViewCell : UICollectionViewCell
@property(nonatomic ,strong)JGJChatMsgListModel *model;
@property (strong, nonatomic) IBOutlet UILabel *NameLbale;
@property (strong, nonatomic) IBOutlet UILabel *Timelable;
@property (strong, nonatomic) IBOutlet UILabel *ContentLable;
@property(nonatomic ,strong)NSMutableDictionary *DataArray;
@property (strong, nonatomic) IBOutlet UIImageView *systemNoticeImageview;
@property (strong, nonatomic) IBOutlet UILabel *DepartLable;
@property(nonatomic ,strong)id <JGJNewDetailCollectionViewCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameLableConstance;

@end
