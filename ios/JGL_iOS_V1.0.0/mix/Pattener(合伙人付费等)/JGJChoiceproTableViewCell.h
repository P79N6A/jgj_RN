//
//  JGJChoiceproTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJChoiceproTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UILabel *proLable;
@property (strong, nonatomic) IBOutlet UILabel *closeLable;
@property (nonatomic, strong) JGJMyRelationshipProModel *MyRelationshipProModel;

@end
