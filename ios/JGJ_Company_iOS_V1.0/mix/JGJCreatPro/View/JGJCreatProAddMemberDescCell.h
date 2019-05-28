//
//  JGJCreatProAddMemberDescCell.h
//  JGJCompany
//
//  Created by yj on 16/9/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCreatProAddMemberDescCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)creatProAddMemberDescCellHeight;
@property (strong, nonatomic) JGJCreatProDecModel *proDecModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLineViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLableCenterX;
@end
