//
//  JLGFindJobDetailWelfareTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/18.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGFindJobDetailWelfareTableViewCell.h"

@interface JLGFindJobDetailWelfareTableViewCell()

@property (strong, nonatomic) IBOutlet JLGTagView *tagView;
@end

@implementation JLGFindJobDetailWelfareTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpInit];
    }
    return self;
}

- (void)setUpInit{
    self.tagView = [[JLGTagView alloc] init];
}

- (void)setWelfaresArray:(NSArray *)welfaresArray{
    _welfaresArray = welfaresArray;
    self.tagView.viewW = TYGetUIScreenWidth;
    self.tagView.datasArray = [self.welfaresArray copy];
}

- (CGFloat )getWelfareViewH{
    return 45.0 + self.tagView.viewH;
}

- (void)dealloc{
    self.tagView = nil;
}

@end
