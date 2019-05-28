//
//  JGJpeopleRecTableViewCell.h
//  mix
//
//  Created by Tony on 2017/3/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol tapSummernamedelegate <NSObject>
-(void)tapSumerNameLableandTag:(NSInteger)indexpathRow;
@end
@interface JGJpeopleRecTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *recordPeoplelable;
@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (nonatomic ,strong)JGJRainCalenderDetailModel *model;
@property (nonatomic ,strong)id <tapSummernamedelegate> delegate;

@end
