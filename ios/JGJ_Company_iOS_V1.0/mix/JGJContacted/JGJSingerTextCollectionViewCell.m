//
//  JGJSingerTextCollectionViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSingerTextCollectionViewCell.h"
#import "UILabel+JGJCopyLable.h"
@implementation JGJSingerTextCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setElementModel:(JGJElementDetailModel *)elementModel
{
    if (![elementModel.element_type isEqualToString:@"number"]) {
        _contentLable.text = elementModel.element_value;

    }else{
        _contentLable.text = [elementModel.element_value stringByAppendingString:elementModel.element_unit];
    }
    _titleLable.text = [elementModel.element_name stringByAppendingString:@"："];

    _titleLableWidth.constant = [self RowNodepartHeight:_titleLable.text];
    
    _contentLable.userInteractionEnabled = YES;
    
    [_contentLable creatInternetHyperlinks];
}
-(float)RowNodepartHeight:(NSString *)Str
{
    UILabel *lable = [[UILabel alloc]init];
    lable = [[UILabel alloc] init];
    lable.font = [UIFont systemFontOfSize:15];
    lable.text = Str;
    lable.backgroundColor = [UIColor clearColor];
    lable.numberOfLines = 0;
    lable.textColor = [UIColor darkTextColor];
    lable.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 2000);
    CGSize expectSize = [lable sizeThatFits:maximumLabelSize];
    
    return expectSize.width + 1;
    
}
@end
