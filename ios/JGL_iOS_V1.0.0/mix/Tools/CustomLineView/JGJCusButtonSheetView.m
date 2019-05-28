//
//  JGJCusButtonSheetView.m
//  mix
//
//  Created by yj on 2018/4/27.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCusButtonSheetView.h"

#define Padding 10

#define Margin 10

#define OffsetY 35

#define OffsetBottom 60

#define ButtonH 45

@implementation JGJCusButtonSheetView

- (instancetype)initWithSheetViewType:(JGJCusButtonSheetViewType)sheetViewType chageColors:(NSArray *)chageColors buttons:(NSArray <NSString *>*)buttons buttonClick:(void(^)(JGJCusButtonSheetView *sheetView, NSInteger buttonIndex, NSString *title))block {
    
    if (self = [super init]) {

        CGFloat buttonY = OffsetY;
        
        UIButton *button = nil;
        
        for (NSInteger index = 0; index < buttons.count; index++) {
            
            button = [[UIButton alloc] initWithFrame:CGRectMake(Margin, buttonY, TYGetUIScreenWidth - Margin * 2, ButtonH)];
            
            buttonY = TYGetMaxY(button) + Padding;
            
            button.tag = 101 + index;
            
            [self addSubview:button];
            
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [button setTitle:buttons[index] forState:UIControlStateNormal];
            
            [button setTitleColor:AppFont333333Color forState:UIControlStateNormal];
            
            [button.layer setLayerCornerRadius:JGJCornerRadius];
            
            button.titleLabel.font = [UIFont systemFontOfSize:AppFont28Size];
            
            button.backgroundColor = [UIColor whiteColor];
            
        }
        
        self.frame = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetMaxY(button) + OffsetBottom);
        
        self.sheetViewBlock = block;
    }
    
    return self;
    
}

-(void)buttonPressed:(UIButton *)sender {
    
    if (self.sheetViewBlock) {
        
        self.sheetViewBlock(self, sender.tag - 101, sender.titleLabel.text);
    }
    
}

@end
