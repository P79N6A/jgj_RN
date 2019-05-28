//
//  JGJReportTableViewCell.m
//  mix
//
//  Created by Tony on 16/4/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJReportTableViewCell.h"

static NSString *defaultContentString = @"请输入";

@implementation JGJReportModel
@end

@interface JGJReportTableViewCell ()
<
    UITextViewDelegate
>

@property (nonatomic,strong) JGJReportModel *reportModel;

@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UIView *otherView;

@property (weak, nonatomic) IBOutlet UILabel *normalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *normalDescLabel;

@property (weak, nonatomic) IBOutlet UILabel *otherTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *reportSelectedImageView;
@property (weak, nonatomic) IBOutlet UIView *contentOtherView;

@end

@implementation JGJReportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.normalTitleLabel.textColor = AppFont333333Color;
    self.normalDescLabel.textColor = AppFont999999Color;
    self.otherTitleLabel.textColor = JGJMainColor;
    [self.otherDescTextView.layer setLayerBorderWithColor:JGJMainColor width:0.5 ration:0.02];
    [self.contentOtherView.layer setLayerBorderWithColor:TYColorHex(0Xe1aaaa) width:0.5 radius:0];
    self.otherDescTextView.delegate = self;
    [self setUpDefaultText];
}
- (void)setReportType:(JGJReportType)reportType setReportModel:(JGJReportModel *)reportModel{
    self.reportType = reportType;
    self.reportModel = reportModel;
    
    if (self.reportType == JGJReportTypeNormal) {
        self.normalTitleLabel.text = reportModel.name;
        self.normalDescLabel.text = reportModel.desc;
    }
    
    self.normalView.hidden = reportType == JGJReportTypeOther;
    self.otherView.hidden = reportType == JGJReportTypeNormal;
    self.reportSelectedImageView.hidden = !reportModel.selected;
    self.otherDescTextView.hidden = self.otherView.hidden || self.reportSelectedImageView.hidden;
    self.otherTitleLabel.textColor = self.otherDescTextView.hidden?AppFont333333Color:JGJMainColor;
}

//默认的文本
- (void)setUpDefaultText{
    if (self.otherDescTextView.text.length == 0) {
        self.otherDescTextView.text = defaultContentString;
        self.otherDescTextView.textColor = AppFontccccccColor;
    }
}

//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self setUpDefaultText];
}

//开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:defaultContentString]) {
        textView.text = @"";
        [textView setTextColor:AppFont333333Color];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length > 100) {
        
        self.otherDescTextView.text = [textView.text substringToIndex:100];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲, 输入文字过长" delegate:nil cancelButtonTitle:nil otherButtonTitles: @"确定",nil];
        [alertView show];
        
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length >= 100 && text.length > range.length) {
        return NO;
    }
    if ([text isEqualToString:@"\n"])
    {
        return YES;
    }
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
    
    if (![toBeString isEqualToString:defaultContentString]) {
        [textView setTextColor:AppFont333333Color];
    }else{
        textView.textColor = AppFontccccccColor;
    }
    
    //延迟的目的主要是避免还是没有修改的值
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(JGJReportTextChange:textString:)]) {
            [self.delegate JGJReportTextChange:self textString:toBeString];
        }
    });

    return YES;
}
@end
