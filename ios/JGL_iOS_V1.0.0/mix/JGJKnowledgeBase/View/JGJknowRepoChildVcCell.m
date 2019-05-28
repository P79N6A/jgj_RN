//
//  JGJknowRepoChildVcCell.m
//  mix
//
//  Created by YJ on 17/4/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJknowRepoChildVcCell.h"
#import "UIView+GNUtil.h"
#import "JGJCusProgress.h"
#import "UILabel+GNUtil.h"

#import "NSString+Extend.h"

@interface JGJknowRepoChildVcCell ()
@property (weak, nonatomic) IBOutlet UIImageView *fileIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLable;
@property (weak, nonatomic) IBOutlet UIButton *fileFlagButton;
@property (weak, nonatomic) IBOutlet JGJCusProgress *progressView;
@property (strong, nonatomic) UIView *progress;
@end

@implementation JGJknowRepoChildVcCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.fileNameLable.textColor = AppFont333333Color;
    self.fileNameLable.font = [UIFont systemFontOfSize:AppFont30Size];
    [self.fileFlagButton setTitleColor:AppFont999999Color forState:UIControlStateNormal];
    self.fileFlagButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    self.fileFlagButton.titleLabel.lineBreakMode = 0;
    self.fileFlagButton.titleLabel.numberOfLines = 0;
    self.fileNameLable.lineBreakMode = NSLineBreakByCharWrapping;
    
    self.fileNameLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 142;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setKnowBaseModel:(JGJKnowBaseModel *)knowBaseModel {

    _knowBaseModel = knowBaseModel;
    
    NSString *fileIcon = ![knowBaseModel.file_type isEqualToString:@"dir"] ? @"knowBase_file_icon" : @"knowBase_dir_icon";
    
    self.fileIconImageView.image = [UIImage imageNamed:fileIcon];
    
    self.fileNameLable.text = _knowBaseModel.file_name;
    
    [self.fileNameLable markText:self.searchValue withColor:AppFontd7252cColor];
    
    [self.fileFlagButton setImage:nil forState:UIControlStateNormal];
    
    [self.fileFlagButton setTitle:@"" forState:UIControlStateNormal];

    NSString *fileSize = knowBaseModel.file_size;
    
//    if (knowBaseModel.progress > 0) {
//        
//        fileSize = [NSString stringWithFormat:@"%.1lfM", (knowBaseModel.totalBytesRead / 1024.0 * 1024.0) * knowBaseModel.progress];
//        
//    }else {
//        
//        fileSize = knowBaseModel.file_size;
//    }
    

    
    self.progressView.progressHeight = knowBaseModel.cellHeight;
    
    self.progressView.progress = knowBaseModel.progress;
    
    if (_knowBaseModel.knowBaseCellType == KnowBaseCollecCellType) {
        
        [self.fileFlagButton setTitle:knowBaseModel.isDownLoadSuccess?@"":knowBaseModel.file_size forState:UIControlStateNormal];
        
    }else if (![knowBaseModel.file_type isEqualToString:@"dir"]) { //非文件夹
     
        NSString *collecStr = knowBaseModel.is_collection ? @"\n(已收藏)" : @"";
        
        NSString *buttonTitle = [NSString stringWithFormat:@"%@%@", knowBaseModel.file_size, collecStr];
        
        NSString *buttonTempTitle = buttonTitle;
        
        if (!knowBaseModel.isDownLoadSuccess && knowBaseModel.is_collection) { //已收藏且未下载 显示大小且已收藏标记
            
            buttonTempTitle = buttonTitle;
            
        }else if (knowBaseModel.isDownLoadSuccess && knowBaseModel.is_collection) { //已收藏且已下载 显示已收藏标记
            
            buttonTempTitle = @"(已收藏)";
            
        }else if (!knowBaseModel.isDownLoadSuccess && !knowBaseModel.is_collection) { //未下载和未收藏。显示大小
            
            buttonTempTitle = fileSize;
            
        }else if (knowBaseModel.isDownLoadSuccess && !knowBaseModel.is_collection) { //下载和未收藏。不显示
            
            buttonTempTitle = @"";
        }
        
        [self.fileFlagButton setTitle:buttonTempTitle forState:UIControlStateNormal];
        
    }else if ([knowBaseModel.file_type isEqualToString:@"dir"]) { //文件夹
    
        [self.fileFlagButton setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    }
}

+ (CGFloat)knowRepoChildVcCellHeight {

    return 50;
}

@end
