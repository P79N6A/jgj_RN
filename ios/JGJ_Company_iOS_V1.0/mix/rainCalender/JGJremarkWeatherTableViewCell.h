//
//  JGJremarkWeatherTableViewCell.h
//  mix
//
//  Created by Tony on 2017/3/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol endEditeRemarkdelegate <NSObject>
-(void)endEditeRemarkContent:(NSString *)content;
@end
@interface JGJremarkWeatherTableViewCell : UITableViewCell
<
UITextViewDelegate
>
@property (strong, nonatomic) IBOutlet UILabel *placeLable;
@property (strong, nonatomic) IBOutlet UITextView *textview;
@property (strong, nonatomic) id <endEditeRemarkdelegate>delegate;
-(void)setTempEditecontent:(NSString *)content;

@end
