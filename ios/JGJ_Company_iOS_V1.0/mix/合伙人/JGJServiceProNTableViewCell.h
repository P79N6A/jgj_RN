//
//  JGJServiceProNTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJServiceProNTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *proNameLable;
@property (nonatomic, strong) JGJMyRelationshipProModel *MyRelationshipProModel;
@property (strong ,nonatomic)JGJOrderListModel *orderListModel;

@property (strong, nonatomic) IBOutlet UILabel *pronameLables;
@end
