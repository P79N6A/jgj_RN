//
//  GeoSearchingTableViewCell.m
//  HuDuoDuoCustomer
//
//  Created by jizhi on 15/10/8.
//  Copyright © 2015年 celion. All rights reserved.
//

#import "GeoSearchingTableViewCell.h"

@interface GeoSearchingTableViewCell ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end

@implementation GeoSearchingTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)activityViewStartAnimating{
    [self.activityIndicatorView startAnimating];
}

- (void)activityViewStopAnimating{
    [self.activityIndicatorView stopAnimating];
}
@end
