//
//  JGJNotepadListCell.m
//  mix
//
//  Created by Tony on 2018/4/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
// 大青蛙多

#import "JGJNotepadListCell.h"
#import "JGJCustomLable.h"
#import "UILabel+GNUtil.h"
#import "JGJNotepadListImageView.h"
#import "JGJNotePadOneDaylistMarkImportView.h"
@interface JGJNotepadListCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet JGJCustomLable *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstrain;
@property (weak, nonatomic) IBOutlet JGJNotepadListImageView *imageListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeightContrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markImpoetViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markImportViewBottom;
@property (weak, nonatomic) IBOutlet JGJNotePadOneDaylistMarkImportView *markNoteImportView;

@property (weak, nonatomic) IBOutlet UIImageView *noteImportFlag;


@end
@implementation JGJNotepadListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = AppFontf1f1f1Color;
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    [_backView.layer setLayerCornerRadius:5];
    
    _contentLabel.font = FONT(16);
    
    TYWeakSelf(self);
    _markNoteImportView.markImport = ^(BOOL is_import) {
      
        if (_markNoteImportWithNoteModel) {
            
            weakself.markNoteImportWithNoteModel(weakself.noteModel,self.indexPath);
        }
    };
    
}

- (void)setNoteModel:(JGJNotepadListModel *)noteModel {
    
    _noteModel = noteModel;
    
    _contentLabel.text = _noteModel.content;
    
    _markNoteImportView.is_import = _noteModel.is_import;
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    if (![NSString isEmpty:self.searchKey]) {

        [self.contentLabel markattributedTextArray:@[self.searchKey] color:AppFontEF272FColor font:self.contentLabel.font isGetAllText:YES];
        [self.contentLabel markattributedTextArray:@[self.searchKey] color:AppFontEF272FColor font:self.contentLabel.font isGetAllText:YES withLineSpacing:5];
    }
    
    self.noteImportFlag.hidden = !noteModel.is_import || self.isOneDayComing;
    
}

- (void)setImageViewListwWithNoteModel:(JGJNotepadListModel *)noteModel {
    
    if (_noteModel.images.count == 0) {
        
        _imageHeightConstrain.constant = 0;
        _contentLabelHeightContrain.constant = 0;
        
    }else {
        
        _imageHeightConstrain.constant = (TYGetUIScreenWidth - 70) / 4;
        _imageListView.images = _noteModel.images;
        _contentLabelHeightContrain.constant = 10;
    }
}


- (void)setIsOneDayComing:(BOOL)isOneDayComing {
    
    _isOneDayComing = isOneDayComing;
    
    if (_isOneDayComing) {
        
        _markImpoetViewHeight.constant = 44;
        _markNoteImportView.hidden = NO;
        
    }else {
        
        _markImpoetViewHeight.constant = 0;
        _markNoteImportView.hidden = YES;
    }
}

@end
