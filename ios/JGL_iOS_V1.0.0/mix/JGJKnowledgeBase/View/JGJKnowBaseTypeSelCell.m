//
//  JGJKnowBaseTypeSelCell.m
//  JGJCompany
//
//  Created by yj on 2017/7/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJKnowBaseTypeSelCell.h"

#import "UIImageView+WebCache.h"

@interface JGJKnowBaseTypeSelCell ()

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (weak, nonatomic) IBOutlet UILabel *typeNameLable;

@end

@implementation JGJKnowBaseTypeSelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setKnowBaseModel:(JGJKnowBaseModel *)knowBaseModel {

    _knowBaseModel = knowBaseModel;
    
    self.typeNameLable.text = knowBaseModel.file_name;
    
    NSString *typeImageStr = _knowBaseModel.knowBaseCellType == KnowBaseCollecCellType ? @"knowBase_collect_icon" : @"knowBase_fileType_icon";
    
    NSURL *filePath =[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", JLGHttpRequest_Public, knowBaseModel.file_path]];
    
    
     [self.typeImageView sd_setImageWithURL:filePath placeholderImage: [UIImage imageNamed:typeImageStr]];
    
}

@end
