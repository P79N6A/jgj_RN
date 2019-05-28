//
//  JLGTagView.m
//  mix
//
//  Created by jizhi on 15/11/27.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGTagView.h"
#import "JLGWelfareLabel.h"

#define marginValue 10

@interface JLGTagView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@end

@implementation JLGTagView

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
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.contentView];
}

//绘画
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.contentView.frame = self.bounds;
}

- (void)setDatasArray:(NSArray *)datasArray{
    _datasArray = datasArray;
    
    self.viewW = self.viewW?:TYGetViewW(self);
    if (datasArray != nil) {
        //去掉之前的
        [self.contentView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[JLGWelfareLabel class]]) {
                [obj removeFromSuperview];
            }
        }];
        
        //增加
        [self addSubLabel];
    }
}

- (void)addSubLabel{
    self.viewH = 0;
    CGFloat labelx = 0;
    CGFloat labely = 0;
    NSUInteger lineNum = 0;
    for (NSInteger idx = 0 ; idx < self.datasArray.count; idx++) {
        NSString *labelStr = self.datasArray[idx];
        
        //计算宽高
        JLGWelfareLabel *jlgWelfareLabel = [[JLGWelfareLabel alloc] init];
        jlgWelfareLabel.text = labelStr;
        
        //设置颜色
        if (self.viewColor != nil) {
            jlgWelfareLabel.textColor = self.viewColor;
        }

        //设置字体大小
        if (self.labelFont >= 6) {
            jlgWelfareLabel.font = [UIFont systemFontOfSize:self.labelFont];
        }
        

        CGSize labelSize = [jlgWelfareLabel sizeForLabel];
        
        //超过就换行
        if (((labelx + labelSize.width + marginValue) >= self.viewW)) {
            lineNum++;
            labelx = 0;
            labely += marginValue + labelSize.height;
        }
        
        
        jlgWelfareLabel.frame = CGRectMake(labelx, labely, labelSize.width,labelSize.height);
        
        [self.contentView addSubview:jlgWelfareLabel];
        
        if ((labelx + labelSize.width + marginValue) < self.viewW){
            labelx += marginValue + labelSize.width;
        }
    }
    
    self.viewH = (lineNum + 1)*(JLGWelfareLabelH + marginValue);
}

- (void)dealloc{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
@end
