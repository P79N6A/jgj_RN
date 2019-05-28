//
//  YZGGetIndexRecordHeaderTableViewCell.m
//  mix
//
//  Created by Tony on 16/3/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGGetIndexRecordHeaderTableViewCell.h"

@interface YZGGetIndexRecordHeaderTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *subdayLable;
@property (strong, nonatomic) IBOutlet UILabel *dayLable;
@property (weak, nonatomic) IBOutlet UILabel *otherMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation YZGGetIndexRecordHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.otherMonthLabel.textColor = JGJMainColor;
    self.contentView.backgroundColor = JGJMainBackColor;
}


- (void)setTitleLabelText:(NSString *)text{
    self.titleLabel.text = text;

}
-(void)setDayLableText:(NSString *)Dtext andSubDayLableText:(NSString *)subText
{
    if (![NSString isEmpty:Dtext]) {
        if (![Dtext containsString:@"日"]) {
            Dtext = [Dtext stringByAppendingString:@"日"];
        }
    }
    self.dayLable.text = Dtext;
//    self.subdayLable.text = subText;

}
@end
