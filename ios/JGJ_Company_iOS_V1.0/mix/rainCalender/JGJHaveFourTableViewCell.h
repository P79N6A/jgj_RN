//
//  JGJHaveFourTableViewCell.h
//  mix
//
//  Created by Tony on 2017/4/1.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJHaveFourTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *upleftimagview;
@property (strong, nonatomic) IBOutlet UIImageView *uprightimagview;
@property (nonatomic, strong) NSMutableArray *imageArr;

@property (strong, nonatomic) IBOutlet UIImageView *downleftimagview;
@property (strong, nonatomic) IBOutlet UIImageView *downRightimagview;
@end
