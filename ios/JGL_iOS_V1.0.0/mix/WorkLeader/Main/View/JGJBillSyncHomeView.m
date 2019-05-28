//
//  JGJBillSyncHomeView.m
//  mix
//
//  Created by jizhi on 16/5/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJBillSyncHomeView.h"
#import "UIView+GNUtil.h"

@interface JGJBillSyncHomeView()
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UILabel *thirdTagLabel;//红点
@property (weak, nonatomic) IBOutlet UILabel *thirdTitleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *thirdDetailLabel;//详细内容

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdLabelLayoutW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdLabelLayoutH;
@end
@implementation JGJBillSyncHomeView
-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    //添加手势
    UITapGestureRecognizer *firstSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *secondSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.firstView.userInteractionEnabled = YES;
    [self.firstView addGestureRecognizer:firstSingleTap];
    [self.secondView addGestureRecognizer:secondSingleTap];
    self.secondView.userInteractionEnabled = YES;

    //添加手势
    UITapGestureRecognizer *thirdSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.thirdView.userInteractionEnabled = YES;

    [self.thirdView addGestureRecognizer:thirdSingleTap];
}

- (void )setLabels{
    [super setLabels];
//    [self setThirdView];
}

- (void)setThirdRecordWorkModel:(YZGRecordWorkModel *)thirdRecordWorkModel{
    _thirdRecordWorkModel = thirdRecordWorkModel;
    [self setThirdView];
}


- (void)setThirdView{
    //设置红点
    if (self.thirdRecordWorkModel.redPointType == YZGRecordWorkRedPointDefault) {//不需要显示
        self.thirdTagLabel.hidden = YES;
    }else {
        self.thirdTagLabel.hidden = NO;
        if (self.thirdRecordWorkModel.redPointType == YZGRecordWorkRedPointRedPoint) {//如果只显示红点
            self.thirdTagLabel.text = @"";
            self.thirdLabelLayoutH.constant = 6;
            self.thirdLabelLayoutW.constant = 6;
        }else{//显示有数字的时候
            if ([self.thirdRecordWorkModel.labelNum isEqualToString:@"0"]) {
                self.thirdTagLabel.hidden = YES;
            }else{
                self.thirdTagLabel.text = self.thirdRecordWorkModel.labelNum;
            }
        }
    }
    
    //设置标题
    self.thirdTitleLabel.text = self.thirdRecordWorkModel.titleString;
    
    if ([self.thirdRecordWorkModel.detailString isKindOfClass:[NSString class]]) {
        self.thirdDetailLabel.text = self.thirdRecordWorkModel.detailString;
    }else{
        self.thirdDetailLabel.attributedText = self.thirdRecordWorkModel.detailString;
    }
    
    //设置显示的颜色
    self.thirdTagLabel.backgroundColor = self.thirdRecordWorkModel.backgroundColor;
    //设置成圆角
    [self.thirdTagLabel.layer setLayerCornerRadius:TYGetViewW(self.thirdTagLabel)/2];
    
}

@end
