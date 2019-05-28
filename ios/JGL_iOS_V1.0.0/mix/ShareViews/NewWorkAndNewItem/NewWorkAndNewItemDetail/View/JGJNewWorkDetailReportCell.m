//
//  JGJNewWorkDetailReportCell.m
//  mix
//
//  Created by celion on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNewWorkDetailReportCell.h"
@interface JGJNewWorkDetailReportCell ()
@property (weak, nonatomic) IBOutlet UIImageView *reportFlagImageView;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *detailContent;
@property (weak, nonatomic) IBOutlet UILabel *reportTitle;

@end
@implementation JGJNewWorkDetailReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (TYIS_IPHONE_4_OR_LESS || TYIS_IPHONE_5) {
        self.content.font = [UIFont systemFontOfSize:26 * 0.48];
        self.reportTitle.font = [UIFont systemFontOfSize:26 * 0.48];
    } else {
        self.content.font = [UIFont systemFontOfSize:AppFont28Size];
        self.reportTitle.font = [UIFont systemFontOfSize:AppFont28Size];
    }
    self.detailContent.font = [UIFont systemFontOfSize:AppFont24Size];
    self.content.textColor = AppFont333333Color;
    self.detailContent.textColor = AppFont999999Color;
    self.reportTitle.text = @"我要举报";
    self.reportTitle.textColor = AppFontd7252cColor;
    self.content.text = @"如遇无效、 虚假 、诈骗信息,请立即举报!";
    self.detailContent.text = @"求职过程请勿缴纳费用,谨防诈骗!若信息不实请举报";
    self.reportFlagImageView.image = [UIImage imageNamed:@"warn"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedReportButtonPressed:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

-(void)didClickedReportButtonPressed:(UITapGestureRecognizer *)tap {
    if (self.blockReportButtonDidClickedPressed) {
        self.blockReportButtonDidClickedPressed();
    }
}

//- (IBAction)reportButtonPressed:(UIButton *)sender {
//    
//    if (self.blockReportButtonDidClickedPressed) {
//        self.blockReportButtonDidClickedPressed();
//    }
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
