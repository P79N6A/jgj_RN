//
//  JGJCustomListLable.m
//  mix
//
//  Created by celion on 16/4/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCustomListView.h"
#define Padding 10
#define Margin 7.5
#define LableHeight 17
@interface JGJCustomListView ()

@property (nonatomic, strong) UIColor *layerColor;
@property (nonatomic, strong) UIColor *lablebackGroundColor;
@property (nonatomic, strong) UIColor *lableTextColor;
@property (nonatomic, assign) CGFloat layerWidth;
@property (nonatomic, assign) CGFloat fontSize;
@end

@implementation JGJCustomListView

- (instancetype)initWithFrame:(CGRect)frame {

    if ([super initWithFrame:frame]) {
//        [self setLableLayerColor:nil width:0 textBackGroundColor:nil textColor:nil];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setLableLayerColor:nil width:0 textBackGroundColor:nil textColor:nil];
    }
    return self;
}

- (void)setCustomListViewDataSource:(NSArray *)dataSource lineMaxWidth:(CGFloat)lineMaxWidth {
//    先清除子视图再添加
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    NSMutableArray *workTypes = dataSource.mutableCopy;
    CGFloat w = 0;//保存前一个lable的宽以及前一个lable距离屏幕边缘的距离
    CGFloat h = 0;//用来控制lable距离父视图的高
    for (int i = 0; i < workTypes.count; i++) {
        UILabel *worktypeLable = [[UILabel alloc] init];
        worktypeLable.backgroundColor = self.lablebackGroundColor;
        worktypeLable.textColor = self.lableTextColor;
        worktypeLable.font = [UIFont systemFontOfSize:(self.contentFontSize == 0) ? AppFont24Size: self.contentFontSize];
        worktypeLable.textAlignment = NSTextAlignmentCenter;
        [worktypeLable.layer setLayerBorderWithColor:self.layerColor width:self.layerWidth radius:2];
        worktypeLable.layer.masksToBounds = YES;
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:AppFont24Size]};
        if ([workTypes[i] isKindOfClass:[NSString class]]) {
            CGFloat width = [workTypes[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width - 3;
            worktypeLable.text = workTypes[i];
            //设置lable的frame
            worktypeLable.frame = CGRectMake(0 + w, h, width + Margin , LableHeight);
            //当lable的位置超出lineMaxWidth换行
            if( w + width + Margin > lineMaxWidth){
                w = 0; //换行时将w置为0
                h = h + TYGetViewH(worktypeLable) + Padding;//距离父视图也变化
                worktypeLable.frame = CGRectMake(0 + w, h, width + Margin, LableHeight);//重设lable的frame
            }
            w = TYGetViewW(worktypeLable) + worktypeLable.frame.origin.x + Margin;
            [self addSubview:worktypeLable];;
        } else {
            [workTypes removeObjectAtIndex:i];
        }
    }
    self.totalHeight = h + Padding + LableHeight;
}

- (void)setLableLayerColor:(UIColor *)layerColor width:(CGFloat)width textBackGroundColor:(UIColor *)backGroundColor textColor:(UIColor *)textColor {
    
    if (!layerColor) {
        self.layerColor = AppFontccccccColor;
    } else {
        self.layerColor = layerColor;
    }
    
    if (width == 0) {
        self.layerWidth = 0;
    }else {
        self.layerWidth = width;
    }
    
    if (!backGroundColor) {
        self.lablebackGroundColor = AppFonteeeeeeColor;
    } else {
        self.lablebackGroundColor = backGroundColor;
    }
    
    if (!textColor) {
        self.lableTextColor = AppFont666666Color;
    } else {
        self.lableTextColor = textColor;
    }
}
@end
