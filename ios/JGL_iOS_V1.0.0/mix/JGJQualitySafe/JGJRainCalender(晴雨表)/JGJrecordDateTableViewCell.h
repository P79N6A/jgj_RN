//
//  JGJrecordDateTableViewCell.h
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJrecordDateTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateTimeLable;
@property (strong, nonatomic) IBOutlet UILabel *proLable;
-(void)setDateTimeLableText:(NSString *)time andProText:(NSString *)pro;
@end
