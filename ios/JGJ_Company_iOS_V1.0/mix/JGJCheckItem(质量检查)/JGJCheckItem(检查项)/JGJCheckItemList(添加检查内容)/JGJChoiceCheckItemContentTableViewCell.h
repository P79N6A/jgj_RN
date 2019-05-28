//
//  JGJChoiceCheckItemContentTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/11/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJChoiceCheckItemContentTableViewCellDelegate <NSObject>

-(void)clickCheckItemContentBtn:(NSIndexPath *)indexpath;

@end
@interface JGJChoiceCheckItemContentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UIImageView *selectImage;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImage;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) NSIndexPath *indexpaths;
@property (strong, nonatomic) id <JGJChoiceCheckItemContentTableViewCellDelegate> delegate;
@property (strong, nonatomic) JGJCheckContentDetailModel *model;

@property (strong, nonatomic) JGJCheckContentListModel *checkItemModel;

@end
