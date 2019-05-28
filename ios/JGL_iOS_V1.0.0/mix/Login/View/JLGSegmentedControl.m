//
//  JLGSegmentedControl.m
//  mix
//
//  Created by Tony on 16/1/5.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGSegmentedControl.h"
#import "CALayer+SetLayer.h"

#define JLGSegmentedDuration 0.1

@interface JLGSegmentedControlBackView : UIView

@property (nonatomic,strong) UIView *contentView;
@end

@implementation JLGSegmentedControlBackView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
}

//绘画
- (void)drawRect:(CGRect)rect{
    self.contentView.frame = self.bounds;
    [self.layer setLayerBorderWithColor:[UIColor whiteColor] width:0.5 radius:JLGSegmentedRadius];
    self.clipsToBounds = YES;
}
@end

@interface JLGSegmentedControl ()
{
    CGFloat _buttonW;
}
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) NSMutableArray *buttonsArray;
@end

@implementation JLGSegmentedControl
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    self.backgroundColor = JLGBlueColor;
}

//绘画
- (void)drawRect:(CGRect)rect{
    self.contentView.frame = self.bounds;
    [self.layer setLayerBorderWithColor:[UIColor whiteColor] width:0.5 radius:JLGSegmentedRadius];
    self.clipsToBounds = YES;
}

- (void)titlesBy:(NSArray *)titlesArray forSegmentAtIndex:(NSInteger )index{
    self.segmentAtIndex = index;
    self.titlesArray = [titlesArray mutableCopy];
}

- (void)setTitlesArray:(NSArray *)titlesArray{
    _titlesArray = titlesArray;
    [self.buttonsArray removeAllObjects];
    
    CGFloat buttonY = 0;
    CGFloat buttonH = TYGetViewH(self);
    _buttonW = TYGetViewW(self)/titlesArray.count;
    for (NSInteger idx = 0; idx < titlesArray.count; idx++) {
        CGFloat buttonX = _buttonW*idx;
        CGRect subFrame = TYSetRect(buttonX, buttonY, _buttonW, buttonH);
        //设置frame
        UIButton *subButton = [[UIButton alloc] initWithFrame:TYSetRect(buttonX, buttonY, _buttonW, buttonH)];
        
        //添加背景
        if (idx == self.segmentAtIndex) {
            JLGSegmentedControlBackView *backView = [[JLGSegmentedControlBackView alloc] initWithFrame:subFrame];
            backView.tag = JLGSegmentedBaseTag + titlesArray.count;
            [self.contentView addSubview:backView];
            subButton.selected = YES;
            [self.contentView sendSubviewToBack:backView];
        }
        
        //设置tag和color
        subButton.tag = JLGSegmentedBaseTag + idx;
        subButton.backgroundColor = [UIColor clearColor];
//        TYLog(@"subButton.tag = %@",@(subButton.tag));
        
        //设置内容
        [subButton setTitle:titlesArray[idx] forState:UIControlStateNormal];
        [subButton setTitle:titlesArray[idx] forState:UIControlStateSelected];
        
        //设置字体颜色
        [subButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [subButton setTitleColor:JLGBlueColor forState:UIControlStateSelected];
        
        //设置字体大小
        subButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        [subButton addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsArray addObject:subButton];
        [self.contentView addSubview:subButton];
    }
}

- (void)selectedButton:(UIButton *)button{
    
    NSInteger tag = button.tag - JLGSegmentedBaseTag;
    [self changeSelectButtonByIndex:tag byButton:button];
    
    TYLog(@"切换的按钮  segmentAtIndex = %@",@(self.segmentAtIndex));
    if (self.delegate && [self.delegate respondsToSelector:@selector(SegmentedControlSelectedIndex:)]) {
        [self.delegate SegmentedControlSelectedIndex:self.segmentAtIndex];
    }
}

- (void)changeSelectButtonByIndex:(NSInteger )index byButton:(UIButton *)button{
    NSInteger tag = index;
    __block JLGSegmentedControlBackView *backView = [self.contentView viewWithTag:JLGSegmentedBaseTag + self.titlesArray.count];

    if (TYGetRectX(backView.frame) == _buttonW*tag) {//如果X一样，则不用移动
#if 0//项目特殊的索引,主要是因为按钮太小，只要一点击就能够切换
        return ;
#else
        tag = tag == 0?1:0;
#endif
    }

    //设置selected状态
    for (NSInteger idx = 0; idx < self.titlesArray.count; idx++) {
        UIButton *button = [self.contentView viewWithTag:JLGSegmentedBaseTag + idx];
        button.selected = idx == tag;
    }
    
    //重置选中的index
    self.segmentAtIndex = tag;

    //动画
    CGRect backViewFrame = TYSetRect(TYGetViewW(button)*tag, 0, _buttonW, TYGetViewH(backView));
    [UIView animateWithDuration:JLGSegmentedDuration animations:^{
        backView.frame = backViewFrame;
    }];
}

- (void)changeSelectButtonByIndex:(NSInteger )index{
    UIButton *subButton = [self.contentView viewWithTag:index + JLGSegmentedBaseTag];
    
    [self changeSelectButtonByIndex:index byButton:subButton];
}

- (void)dealloc{
    [self.contentView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop){
        [obj removeFromSuperview];
    }];
    
    [self.contentView removeFromSuperview];
}

- (NSMutableArray *)buttonsArray
{
    if (!_buttonsArray) {
        _buttonsArray = [[NSMutableArray alloc] init];
    }
    return _buttonsArray;
}

@end
