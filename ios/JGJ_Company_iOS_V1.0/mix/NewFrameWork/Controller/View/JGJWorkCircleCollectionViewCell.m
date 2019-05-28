//
//  JGJWorkCircleCollectionViewCell.m
//  JGJCompany
//
//  Created by yj on 16/9/20.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkCircleCollectionViewCell.h"
#import "JSBadgeView.h"
@interface JGJWorkCircleCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *desLable;
@property (strong, nonatomic) JSBadgeView *badgeView ;
@property (weak, nonatomic) IBOutlet UIView *contentBadgeView;

@end
@implementation JGJWorkCircleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setInfoModel:(JGJWorkCircleMiddleInfoModel *)infoModel {
    _infoModel = infoModel;
    self.imageView.image = [UIImage imageNamed:_infoModel.InfoImageIcon];
    self.desLable.text = _infoModel.desc;
    self.badgeView.badgeText = _infoModel.unread_msg_count;
    self.contentBadgeView.hidden = [_infoModel.unread_msg_count isEqualToString:@"0"];
}
- (JSBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[JSBadgeView alloc] initWithParentView:self.contentBadgeView alignment:JSBadgeViewAlignmentTopRight];
        _badgeView.badgeBackgroundColor = TYColorHex(0xef272f);
    }
    return _badgeView;
}

@end
