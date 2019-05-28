//
//  JGJMemberImpressTagCell.m
//  mix
//
//  Created by yj on 2018/4/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemberImpressTagCell.h"

#import "JGJMemberImpressTagView.h"

@interface JGJMemberImpressTagCell () <JGJMemberImpressTagViewDelegate>

@property (nonatomic, strong) JGJMemberImpressTagView *tagView;

@end

@implementation JGJMemberImpressTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    JGJMemberImpressTagView *tagView = [[JGJMemberImpressTagView alloc] init];
    
    self.tagView = tagView;
    
    tagView.delegate = self;
    
    [self.contentView addSubview:self.tagView];
    
}

- (void)setTagModels:(NSMutableArray *)tagModels {
    
    _tagModels = tagModels;
    
    self.tagView.tagViewType = self.tagViewType;

    if (tagModels.count > 0) {
     
        self.tagView.tags = tagModels;
        
    }
}

- (void)tagView:(JGJMemberImpressTagView *)tagView sender:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(impressTagCell:tagView:sender:)]) {
        
        [self.delegate impressTagCell:self tagView:tagView sender:sender];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
