//
//  JGJTempTableViewCell.h
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol endEditeTempdelegate <NSObject>
-(void)endEditeMintemp:(NSString *)min_temp maxTemp:(NSString *)max_temp;
@end
@interface JGJTempTableViewCell : UITableViewCell
<
UITextFieldDelegate
>
@property (strong, nonatomic) IBOutlet UITextField *mintextfiled;
@property (strong, nonatomic) IBOutlet UITextField *maxtextfiled;
@property (strong, nonatomic) IBOutlet UILabel *uniteLable;
@property (strong, nonatomic) id <endEditeTempdelegate>delegate;
@property (strong, nonatomic) NSString *tempMInStr;
@property (strong, nonatomic) NSString *tempMaxStr;
-(void)setTempEditetemp_am:(NSString *)temp_am temp_pm:(NSString *)temp_pm;
@end
