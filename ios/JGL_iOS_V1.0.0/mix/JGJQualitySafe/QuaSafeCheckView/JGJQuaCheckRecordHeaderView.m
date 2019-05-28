//
//  JGJQuaCheckRecordHeaderView.m
//  JGJCompany
//
//  Created by yj on 2017/7/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuaCheckRecordHeaderView.h"

#import "NSString+Extend.h"

#import "CustomView.h"

@interface JGJQuaCheckRecordHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLable;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet LineView *lineView;

@end

@implementation JGJQuaCheckRecordHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJQuaCheckRecordHeaderView" owner:self options:nil] lastObject];
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];
    
    self.headerTitleLable.textColor = AppFont333333Color;
    
    self.headerTitleLable.font = [UIFont systemFontOfSize:AppFont32Size];
    
    self.headerTitleLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 35;
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.lineView.backgroundColor = AppFontf1f1f1Color;

}

- (void)setRecordModel:(JGJQuaSafeCheckRecordModel *)recordModel {

    _recordModel = recordModel;
    
    self.headerTitleLable.text = _recordModel.inspect_name;

}

- (CGFloat)quaCheckRecordHeaderViewHeight {

    CGFloat height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 35 content:_recordModel.inspect_name font:AppFont32Size];
    
    return height + 43;

}

@end
