//
//  JLGDefaultTableViewCell.h
//  mix
//
//  Created by jizhi on 15/12/28.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLGDefaultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tileLayoutCenterY;
- (void)setDefaultImage:(UIImage *)defaultImage defautTitle:(NSString *)defautTitle defaultDetailTitle:(NSString *)defaultDetailTitle;
@end
