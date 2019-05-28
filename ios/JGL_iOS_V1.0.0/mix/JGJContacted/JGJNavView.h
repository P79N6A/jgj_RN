//
//  JGJNavView.h
//  mix
//
//  Created by Tony on 2017/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJNavView : UIView
@property (strong, nonatomic) IBOutlet UIButton *DownButton;
@property (strong, nonatomic) IBOutlet UILabel *monthLable;
@property (strong, nonatomic) IBOutlet UILabel *weekLable;
@property (strong, nonatomic) NSDate *timeDate;
@property (strong, nonatomic) UILabel *monthLables;
@property (strong, nonatomic) UILabel *weekLables;

@end
