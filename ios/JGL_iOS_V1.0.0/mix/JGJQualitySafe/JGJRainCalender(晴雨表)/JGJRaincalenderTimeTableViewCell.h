//
//  JGJRaincalenderTimeTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/8/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol tapNamelabledelegate <NSObject>
-(void)tapDetailNameLable:(NSInteger)indexPathRow;
@end
@interface JGJRaincalenderTimeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timelable;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property(nonatomic,strong)JGJRainCalenderDetailModel *calendermodel;
@property(nonatomic,strong)id <tapNamelabledelegate> delegate;

@end
