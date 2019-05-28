//
//  JGJTheDiaryOfRecipientTableViewCell.m
//  mix
//
//  Created by Tony on 2018/3/9.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJTheDiaryOfRecipientTableViewCell.h"
#import "JGJCustomLable.h"
#import "UILabel+GNUtil.h"
@interface JGJTheDiaryOfRecipientTableViewCell ()

@property (nonatomic, strong) JGJCustomLable *topLabel;// 接收人
@end
@implementation JGJTheDiaryOfRecipientTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.topLabel];
    
    [self setUpLayout];
}

- (void)setUpLayout {
    
    _topLabel.sd_layout.widthIs(TYGetUIScreenWidth).heightIs(37.5).leftSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0);
}
#pragma mark - setter
- (JGJCustomLable *)topLabel {
    
    if (!_topLabel) {
        
        _topLabel = [[JGJCustomLable alloc] init];
        _topLabel.backgroundColor = AppFontf1f1f1Color;
        _topLabel.textColor = AppFont333333Color;
        _topLabel.text = @"   接收人(点击头像可删除)";
        [_topLabel markText:@"(点击头像可删除)" withColor:TYColorHex(0X878787)];
        _topLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    }
    return _topLabel;
}
@end
