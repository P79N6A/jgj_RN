//
//  JGJHaveThreeTableViewCell.h
//  mix
//
//  Created by Tony on 2017/4/1.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJHaveThreeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *upimagview;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (strong, nonatomic) IBOutlet UIImageView *centerimagviews;

@property (strong, nonatomic) IBOutlet UIView *centerimageview;
@property (strong, nonatomic) IBOutlet UIImageView *downimagview;
@end
