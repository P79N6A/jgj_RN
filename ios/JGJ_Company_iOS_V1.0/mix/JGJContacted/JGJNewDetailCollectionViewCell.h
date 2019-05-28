//
//  JGJNewDetailCollectionViewCell.h
//  test
//
//  Created by Tony on 2016/12/30.
//  Copyright © 2016年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"
@protocol JGJNewDetailCollectionViewCellDelegate <NSObject>
-(void)JGJNewDetailCollectionViewCellTapNameLableAndIndexpathRow:(NSInteger)row;
@end
@interface JGJNewDetailCollectionViewCell : UICollectionViewCell
@property(nonatomic ,strong)JGJChatMsgListModel *model;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameHeightConstance;
@property (strong, nonatomic) IBOutlet UILabel *NameLbale;
@property (strong, nonatomic) IBOutlet UILabel *Timelable;
@property (strong, nonatomic) IBOutlet UILabel *ContentLable;
@property(nonatomic ,strong)NSMutableDictionary *DataArray;
@property (strong, nonatomic) IBOutlet UILabel *departLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *timeConstance;
@property (strong, nonatomic) IBOutlet UIImageView *systemImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameLableConstance;
@property(nonatomic ,strong)id <JGJNewDetailCollectionViewCellDelegate> delegate;
@end
