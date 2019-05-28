//
//  JLGRegisterClickTableViewCell.h
//  mix
//
//  Created by jizhi on 15/11/17.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLGRegisterClickTableViewCell : UITableViewCell

@property (strong,nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UILabel *detailTF;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redStarImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redStarLayoutW;

@end
