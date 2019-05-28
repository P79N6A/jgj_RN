//
//  JGJConRecomSectionHeaderView.m
//  mix
//
//  Created by yj on 2018/12/14.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJConRecomSectionHeaderView.h"

@interface JGJConRecomSectionHeaderView()


@property (strong, nonatomic) IBOutlet UIView *containView;

@end

@implementation JGJConRecomSectionHeaderView

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
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJConRecomSectionHeaderView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    self.containView.backgroundColor = AppFontEBEBEBColor;
}


- (IBAction)exchangeBtnPressed:(UIButton *)sender {
    
    if (self.headerViewBlock) {
        
        self.headerViewBlock();
    }
}

@end
