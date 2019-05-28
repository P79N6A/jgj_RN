//
//  JGJHaveTwoTableViewCell.h
//  mix
//
//  Created by Tony on 2017/4/1.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJHaveTwoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *upimagview;

@property (strong, nonatomic) IBOutlet UIImageView *downimageview;
@property (nonatomic, strong) NSMutableArray *imageArr;

@end
