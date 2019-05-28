//
//  JGJMoreLineTextCollectionViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMoreLineTextCollectionViewCell.h"
#import "UILabel+JGJCopyLable.h"

@interface JGJMoreLineTextCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *backColorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backColorViewW;

@end

@implementation JGJMoreLineTextCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentLable canCopyWithlable:nil];//添加复制功能
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHideCallback) name:UIMenuControllerDidHideMenuNotification object:nil];
    
    TYWeakSelf(self);
    
    self.contentLable.copyLableActionBlock = ^{
      
         [weakself menuDidShowCallback];
    };

}
-(void)setElementModel:(JGJElementDetailModel *)elementModel
{
    _titleLable.text = [elementModel.element_name stringByAppendingString:@"："];

    _titleLableWidth.constant = [self RowNodepartHeight:_titleLable.text];
    _contentLable.text = elementModel.element_value;
    [_contentLable SetLinDepart:5];
    [_contentLable creatInternetHyperlinks];

     self.backColorViewW.constant = [self.contentLable sizeThatFits:CGSizeMake(TYGetUIScreenWidth - 20, CGFLOAT_MAX)].width + 3;

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
    
    return expectSize.width;
    
}

- (void)menuDidHideCallback{
    
    self.backColorView.hidden = YES;
    
    self.backColorView.backgroundColor = AppFontffffffColor;
    
}

- (void)menuDidShowCallback {
    
    self.backColorView.hidden = NO;
    
    self.backColorView.backgroundColor = AppFontccccccColor;
    
}

@end
