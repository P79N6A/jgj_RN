//
//  YZGMateBillRecordWorkpointsView.m
//  mix
//
//  Created by Tony on 16/2/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGMateBillRecordWorkpointsView.h"
#import "CALayer+SetLayer.h"
#import "UIView+GNUtil.h"
static const CGFloat redPointWith = 1;//只显示红点的时候的宽度

@interface YZGMateBillRecordWorkpointsView ()

//第一组
@property (weak, nonatomic) IBOutlet UILabel *firstTagLabel;//红点
@property (weak, nonatomic) IBOutlet UILabel *firstTitleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *firstDetailLabel;//详细内容
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLabelLayoutW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLabelLayoutH;


@property (weak, nonatomic) IBOutlet UILabel *secondTagLabel;//红点
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *secondDetailLabel;//详细内容
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLabelLayoutW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLabelLayoutH;


@end

@implementation YZGMateBillRecordWorkpointsView

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
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    //添加手势
    UITapGestureRecognizer *firstSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *secondSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    [self.firstView addGestureRecognizer:firstSingleTap];
    [self.secondView addGestureRecognizer:secondSingleTap];
}

- (void)handleSingleTap:(id)sender
{
    UITapGestureRecognizer * singleTap = (UITapGestureRecognizer *)sender;
    if (self.delegate &&[self.delegate respondsToSelector:@selector(YZGMateBillRecordWorkBtnClick:index:)]) {
        [self.delegate YZGMateBillRecordWorkBtnClick:self index:[singleTap view].tag - 11];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setLabels];
}

- (void )setLabels{
    [self setFirstView];
    [self setSecondView];
}

- (void)setFirstView{
    //设置红点
    if (self.firstRecordWorkModel.redPointType == YZGRecordWorkRedPointDefault) {//不需要显示
        self.firstTagLabel.hidden = YES;
    }else {
        self.firstTagLabel.hidden = NO;
        if (self.firstRecordWorkModel.redPointType == YZGRecordWorkRedPointRedPoint) {//如果只显示红点
            
            self.firstTagLabel.text = @" ";
//            self.firstLabelLayoutH.constant = redPointWith  * 0.5;
//            self.firstLabelLayoutW.constant = redPointWith * 0.5;
            self.firstTagLabel.height = 6;
            self.firstTagLabel.width = 6;
        }else{//显示有数字的时候
            if ([self.firstRecordWorkModel.labelNum isEqualToString:@"0"]) {
                self.firstTagLabel.hidden = YES;
            }else{
                self.firstLabelLayoutH.constant = redPointWith ;
                self.firstLabelLayoutW.constant = redPointWith;
                self.firstTagLabel.text = self.firstRecordWorkModel.labelNum;
            }
        }
    }
    
    //设置标题
    self.firstTitleLabel.text = self.firstRecordWorkModel.titleString;

    if ([self.firstRecordWorkModel.detailString isKindOfClass:[NSString class]]) {
        self.firstDetailLabel.text = self.firstRecordWorkModel.detailString;
    }else{
        self.firstDetailLabel.attributedText = self.firstRecordWorkModel.detailString;
    }
    
    //设置显示的颜色
//    self.firstTagLabel.backgroundColor = self.firstRecordWorkModel.backgroundColor;
    self.firstTagLabel.backgroundColor = TYColorHex(0Xf9a00f);
    //设置成圆角
    [self.firstTagLabel.layer setLayerCornerRadius:TYGetViewW(self.firstTagLabel)/2];
}

- (void)setSecondView{
    //设置红点
    if (self.secondRecordWorkModel.redPointType == YZGRecordWorkRedPointDefault) {//不需要显示
        self.secondTagLabel.hidden = YES;
    }else {
        self.secondTagLabel.hidden = NO;
        if (self.secondRecordWorkModel.redPointType == YZGRecordWorkRedPointRedPoint) {//如果只显示红点
            self.secondTagLabel.text = @"";
            self.secondLabelLayoutH.constant = redPointWith;
            self.secondLabelLayoutW.constant = redPointWith;
        }else{//显示有数字的时候
            if ([self.secondRecordWorkModel.labelNum isEqualToString:@"0"]) {
                self.secondTagLabel.hidden = YES;
            }else{
                self.secondTagLabel.text = self.secondRecordWorkModel.labelNum;
            }
        }
    }
    
    //设置标题
    self.secondTitleLabel.text = self.secondRecordWorkModel.titleString;

    if ([self.secondRecordWorkModel.detailString isKindOfClass:[NSString class]]) {
        self.secondDetailLabel.text = self.secondRecordWorkModel.detailString;
    }else{
        self.secondDetailLabel.attributedText = self.secondRecordWorkModel.detailString;
    }

    //设置显示的颜色
    self.secondTagLabel.backgroundColor = self.secondRecordWorkModel.backgroundColor;
    //设置成圆角
    [self.secondTagLabel.layer setLayerCornerRadius:TYGetViewW(self.secondTagLabel)/2];
    
}

- (void)setFirstRecordWorkModel:(YZGRecordWorkModel *)firstRecordWorkModel{
    _firstRecordWorkModel = firstRecordWorkModel;
    [self setFirstView];
}

- (void)setSecondRecordWorkModel:(YZGRecordWorkModel *)secondRecordWorkModel{
    _secondRecordWorkModel = secondRecordWorkModel;
    [self setSecondView];
}

@end
