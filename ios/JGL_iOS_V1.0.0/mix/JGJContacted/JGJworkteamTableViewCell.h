//
//  JGJworkteamTableViewCell.h
//  mix
//
//  Created by Tony on 2017/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJworkteamTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *pronameLable;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (nonatomic, strong) NSString * proname;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightArrow;
@property (strong, nonatomic) IBOutlet UIImageView *rightArrowImage;
@property (strong, nonatomic)  NSString *manNum;

@end
