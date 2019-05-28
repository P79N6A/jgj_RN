//
//  JGJWelfareTagView.m
//  mix
//
//  Created by yj on 2018/6/12.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJWelfareTagView.h"

#import "JGJCusButton.h"

#define margin 10

#define offsetY 0

@implementation JGJWelfareTagView

- (instancetype)initWithTagList:(NSArray *)tagList {
    
    if (self = [super init]) {
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        
    }
    
    return self;
}

- (void)setTags:(NSArray *)tags {
    
    _tags = tags;
    
    [self showTagViewTypeWithTags:tags];
    
}

-(void)showTagViewTypeWithTags:(NSArray *)tags {
    
    CGFloat btnX = 0;
    
    CGFloat btnY = offsetY;
    
    JGJCusButton *btn = [[JGJCusButton alloc] init];
    
    for(int i = 0; i < tags.count; i++){
        
        NSString *tag_name = tags[i];
        
        //宽度自适应
        NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:AppFont22Size]};
        
        CGRect frame_W = [tag_name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
        
        if ([NSString isEmpty:tag_name]) {
            
            frame_W = CGRectZero;
        }
        
        if (btnX + frame_W.size.width + margin * 2 > TYGetUIScreenWidth - margin * 2) {
            
            btnX = 0;
            
            btnY = TYGetMaxY(btn) + margin;
        }
        
        btn = [[JGJCusButton alloc]initWithFrame:CGRectMake(btnX, btnY, frame_W.size.width + margin * 2, TagH)];
        
        [btn setTitle:tag_name forState:UIControlStateNormal];
        
        [btn setTitleColor:AppFont999999Color forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
        
        btn.backgroundColor = AppFontEBEBEBColor;
        
        [btn.layer setLayerCornerRadius:2.5];
        
        [self addSubview:btn];
        
        btnX = CGRectGetMaxX(btn.frame) + margin;
        
    }
    
    self.frame = CGRectMake(0, 0, TYGetUIScreenWidth, CGRectGetMaxY(btn.frame) + offsetY);
}

@end
