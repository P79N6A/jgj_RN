//
//  JGJPerInfoSignatureCell.m
//  mix
//
//  Created by Json on 2019/3/29.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJPerInfoSignatureCell.h"
#import "NSString+Extend.h"

@interface JGJPerInfoSignatureCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIImageView *arrowView;

@end
@implementation JGJPerInfoSignatureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.text = @"个性签名";
    self.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    self.titleLabel.textColor = AppFont000000Color;
    
    self.contentLabel.textColor = AppFont666666Color;
    self.contentLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    self.contentLabel.numberOfLines = 0;
    
    self.lineView.backgroundColor = AppFontdbdbdbColor;
    
    self.arrowView.contentMode = UIViewContentModeCenter;
    self.arrowView.clipsToBounds = YES;

}

- (void)setSignature:(NSString *)signature
{
    _signature = [signature copy];
    self.contentLabel.text = signature;
}

- (void)setShowArrow:(BOOL)showArrow
{
    _showArrow = showArrow;
    self.arrowView.hidden = !showArrow;
}

+ (CGFloat)heightWithSignature:(NSString *)signature
{
    // 12.0:左右间距; 80.0:titleLabel宽度; 8.0:contentLabel<->arrowView间距;9.0:arrowView宽度
    CGFloat maxWidth = TYGetUIScreenWidth - 12.0 * 2 - 80.0 - 8.0 - 9.0;
    CGFloat contentH = [NSString getContentHeightWithString:signature maxWidth:maxWidth font:AppFont30Size lineSpace:0];
    return contentH + 10 * 2;
}

@end
