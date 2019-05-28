//
//  JGJHadRecordAlerView.m
//  mix
//
//  Created by Tony on 2017/5/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJHadRecordAlerView.h"

@implementation JGJHadRecordAlerView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadView];
    }
    return self;
}
-(void)loadView{
    
    [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.frame;
    [self addSubview:self.contentView];
    
    
}

+(void)showAlerInwindown
{
    [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];


    

}

@end
