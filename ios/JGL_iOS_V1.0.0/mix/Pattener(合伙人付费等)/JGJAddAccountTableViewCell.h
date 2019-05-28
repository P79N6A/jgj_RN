//
//  JGJAddAccountTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/7/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol deleteDelegate <NSObject>
-(void)clickDeleteButtonAndIndexpathRow:(NSInteger)indexpathRow;
@end
@interface JGJAddAccountTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageViewTy;
@property (strong, nonatomic) IBOutlet UILabel *accountTypeLable;
@property (strong, nonatomic) IBOutlet UILabel *useingLable;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic)  id <deleteDelegate> delegate;
@property (strong, nonatomic) JGJAccountListModel *accountModel;
@end
