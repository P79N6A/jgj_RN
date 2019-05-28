//
//  JGJAccountHeaderTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol changeAccountDelegate <NSObject>
- (void)changeAccountFrom;
@end
@interface JGJAccountHeaderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumLable;
@property (strong, nonatomic) IBOutlet UILabel *hadBoundLable;
@property (strong, nonatomic) IBOutlet UILabel *otherAccount;
@property (strong, nonatomic) id <changeAccountDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageview;
@property (strong, nonatomic) JGJAccountListModel *model;

@end
