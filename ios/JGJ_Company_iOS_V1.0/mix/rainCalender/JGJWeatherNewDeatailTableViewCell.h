//
//  JGJWeatherNewDeatailTableViewCell.h
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
//@protocol tapNamelabledelegate <NSObject>
//-(void)tapDetailNameLable:(NSInteger)indexPathRow;
//@end
@interface JGJWeatherNewDeatailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bottomLbale;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tempHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstance;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *windHeight;
@property (strong, nonatomic) IBOutlet UILabel *daylable;
//@property (strong, nonatomic) IBOutlet UILabel *namelable;
//@property (strong, nonatomic) IBOutlet UIView *weatherlable;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
//@property (strong, nonatomic) IBOutlet UILabel *weathercContentLable;
@property (strong, nonatomic) IBOutlet UILabel *tempLable;
@property (strong, nonatomic) IBOutlet UILabel *windLable;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property(nonatomic,strong)JGJRainCalenderDetailModel *calendermodel;
@property (strong, nonatomic) IBOutlet UILabel *weatherLable;
//@property(nonatomic,strong)id <tapNamelabledelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *departLable;

@end
