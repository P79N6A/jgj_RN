//
//  JGJRecordStaListHeaderView.m
//  mix
//
//  Created by yj on 2018/1/4.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJRecordStaListHeaderView.h"

@interface JGJRecordStaListHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *staTypeLable;

@property (weak, nonatomic) IBOutlet UILabel *recordTypeLable;

@property (weak, nonatomic) IBOutlet UILabel *moneyLable;

@property (strong, nonatomic) IBOutlet UIView *containView;

@end

@implementation JGJRecordStaListHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSet];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonSet];
    }
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJRecordStaListHeaderView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    UIFont *font = [UIFont systemFontOfSize:AppFont26Size];
    
    UIColor *color  = AppFont666666Color;
    
    self.staTypeLable.font = font;
    
    self.recordTypeLable.font = font;
    
    self.moneyLable.font = font;
    
    self.staTypeLable.textColor = color;
    
    self.recordTypeLable.textColor = color;
    
    self.moneyLable.textColor = color;
    
//    self.staTypeLable.text = JLGisLeaderBool ? @"工人" : @"班组长";
    
    self.staTypeLable.text =  @"姓名";
    
    self.topLineView.hidden = YES;
    
}

- (void)setRecordWorkStaModel:(JGJRecordWorkStaModel *)recordWorkStaModel {
    
    _recordWorkStaModel = recordWorkStaModel;
    
//    NSString *title = JLGisLeaderBool ? @"工人" : @"班组长";
    
    NSString *title = @"姓名";
    
    if (self.staType == JGJRecordStaMonthType) {
        
        title = @"月份";
        
    }else {
        
        NSString *unit = @"人";
        
        if (self.staType == JGJRecordStaProjectType) {
            
            title = @"项目";
            
            unit = @"个";
        }
        
        if (recordWorkStaModel.list.count > 0) {
            
            title = [NSString stringWithFormat:@"%@(%@%@)", title,@(recordWorkStaModel.list.count),unit];
        }
    }
    
    self.staTypeLable.text = title;
}

@end
