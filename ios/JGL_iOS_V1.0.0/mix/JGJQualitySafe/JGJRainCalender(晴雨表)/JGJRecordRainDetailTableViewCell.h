//
//  JGJRecordDetailTableViewCell.h
//  mix
//
//  Created by Tony on 2017/3/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol clickRecordWeatherButton <NSObject>

-(void)clicKRecordWeatherButtonTagert;
@end
@interface JGJRecordRainDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *departLable;

@property (strong, nonatomic) IBOutlet UILabel *placeLable;
@property (strong, nonatomic) IBOutlet UIButton *placeButton;
@property (nonatomic ,assign)BOOL hiddenButton;
@property (strong, nonatomic) IBOutlet UILabel *detailLable;
@property (nonatomic ,retain) id <clickRecordWeatherButton>delegate;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (nonatomic ,strong)JGJRainCalenderDetailModel *model;

@end
