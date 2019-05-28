//
//  JGJWindTableViewCell.h
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol endEditeWinddelegate <NSObject>
-(void)endEditeMinWind:(NSString *)min_wind maxwind:(NSString *)max_wind;
@end

@interface JGJWindTableViewCell : UITableViewCell
<
UITextFieldDelegate
>
@property (strong, nonatomic) IBOutlet UITextField *Minlable;
@property (strong, nonatomic) IBOutlet UITextField *maxlable;
@property (strong, nonatomic) id <endEditeWinddelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *uniteLable;
@property (strong, nonatomic) NSString *windMinStr;
@property (strong, nonatomic) NSString *windMaxStr;
-(void)setTempEditewind_am:(NSString *)wind_am wind_pm:(NSString *)wind_pm;

@end
