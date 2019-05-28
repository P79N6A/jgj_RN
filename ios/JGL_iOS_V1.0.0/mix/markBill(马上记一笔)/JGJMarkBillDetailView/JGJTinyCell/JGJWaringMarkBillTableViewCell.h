//
//  JGJWaringMarkBillTableViewCell.h
//  mix
//
//  Created by Tony on 2018/1/10.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJWaringMarkBillTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) UIImageView *imageViews;
@property (strong, nonatomic) NSTimer *timer;

@end
