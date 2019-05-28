//
//  JGJleaderWorkViewController.h
//  mix
//
//  Created by Tony on 2017/2/20.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJRecordsViewController.h"
@interface JGJleaderWorkViewController : JGJRecordsViewController
@property (strong, nonatomic) IBOutlet UIImageView *images;
@property (strong, nonatomic) IBOutlet UIImageView *imagLeftdistance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imagedistance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightdistance;
@property (strong, nonatomic) IBOutlet UILabel *departLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lederConstace;
@end
