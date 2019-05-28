//
//  JGJMorePullDownView.m
//  mix
//
//  Created by jizhi on 16/5/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJMorePullDownView.h"

@interface JGJMorePullDownView ()
@property (strong, nonatomic) IBOutlet UIView *contentView;

// 完成后回调
@property (copy, nonatomic) MorePullDownEditBlock editBlock;
// 完成后回调
@property (copy, nonatomic) MorePullDownDeleteBlock deleteBlock;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MorePullDownLayoutT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MorePullDownLayoutR;
@end

@implementation JGJMorePullDownView

- (void)MorePullDownEditBlock:(MorePullDownEditBlock )editBlock{
    self.editBlock = [editBlock copy];
}

- (void)MorePullDownDeleteBlock:(MorePullDownDeleteBlock )deleteBlock{
    self.deleteBlock = [deleteBlock copy];
}

- (IBAction)editBtnClick:(id)sender {
    if (self.editBlock) {
        self.editBlock();
    }
}

- (IBAction)deleteBtnClick:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithSubViewT:(NSInteger )top right:(NSInteger )right
{
    self = [self initWithFrame:TYGetUIScreenRect];
    self.MorePullDownLayoutT.constant = top;
    self.MorePullDownLayoutR.constant = right;
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

- (void)showMorePullDownView{
    self.frame = TYGetUIScreenRect;
    if (![[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self.contentView layoutIfNeeded];
    }
}

- (void)hiddenMorePullDownView{
    if ([[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self removeFromSuperview];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hiddenMorePullDownView];
}
@end
