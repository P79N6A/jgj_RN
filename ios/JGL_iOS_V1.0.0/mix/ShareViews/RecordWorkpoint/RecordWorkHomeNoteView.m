//
//  RecordWorkHomeNoteView.m
//  mix
//
//  Created by Tony on 16/2/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//  该xib设用的都是button主要是想以后该需求方便修改

#import "RecordWorkHomeNoteView.h"
#import "CALayer+SetLayer.h"

@implementation RecordWorkHomeNoteModel
- (void)setBtn_dest:(WorkDayDtn_desc *)btn_dest{
    _btn_dest = btn_dest;
    self.recordNoteMoney = btn_dest.amount;
    self.accounts_type  = btn_dest.accounts_type;
}

@end

static const NSString *recordNoteMoneyString = @"今日已记一笔，";
static const NSString *recordOtherNoteMoneyString = @"对你记了一笔账，";//别人对你记账

@interface RecordWorkHomeNoteView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *noRecordView;
@property (weak, nonatomic) IBOutlet UIView *alreadyRecordView;
@property (weak, nonatomic) IBOutlet UIButton *alreadyRecordButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordWorkHomeImageH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todayRecordLayoutL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todayRecordLayoutR;

@end

@implementation RecordWorkHomeNoteView
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
    //设置contentView
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    [self.layer setLayerCornerRadius:6.0];
    
    [self setShowView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIButton *todayButton = [self.contentView viewWithTag:100];
    UIButton *nowRecordButton = [self.contentView viewWithTag:101];
    
    if (JLGisMateBool) {
        todayButton.hidden = NO;
        self.recordWorkHomeImageH.constant = 35;
        nowRecordButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        todayButton.hidden = YES;
        self.recordWorkHomeImageH.constant = 0;
        nowRecordButton.titleEdgeInsets = UIEdgeInsetsZero;
    }
    
    self.todayRecordLayoutL.constant = 10*TYGetUIScreenWidthRatio;
    self.todayRecordLayoutR.constant = 10*TYGetUIScreenWidthRatio;
}

- (void)setShowView{
    //设置显示的view
    self.noRecordView.hidden = self.recordWorkModel.isRecordNote;
    self.alreadyRecordView.hidden = !self.recordWorkModel.isRecordNote;

    NSString *accountTypeStr = self.recordWorkModel.accounts_type == 3?@"借支":@"收入";
    if (self.recordWorkModel.accounts_type > 3) {
        accountTypeStr = @"结算";
    }
    //设置记账金额
    if (self.recordWorkModel.isRecordNote && JLGisMateBool) {//如果是工人并且已经记账了
        
        if (self.recordWorkModel.btn_dest.self_lable == YES) {//自己记账
            
            NSString *amountStr = [NSString stringWithFormat:@"%.2f",self.recordWorkModel.recordNoteMoney];
//            [self.alreadyRecordButton setTitle:[NSString stringWithFormat:@"%@%@%@元",recordNoteMoneyString,accountTypeStr,@(self.recordWorkModel.recordNoteMoney)] forState:UIControlStateNormal];
            
            [self.alreadyRecordButton setTitle:[NSString stringWithFormat:@"%@%@%@元",recordNoteMoneyString,accountTypeStr,[@"" stringByAppendingString:JGJMoneyNumStr(amountStr)]] forState:UIControlStateNormal];

        }else{//别人记账
            
//            [self.alreadyRecordButton setTitle:[NSString stringWithFormat:@"%@%@%@%@元",self.recordWorkModel.btn_dest.name,recordOtherNoteMoneyString,accountTypeStr,@(self.recordWorkModel.recordNoteMoney)] forState:UIControlStateNormal];
            NSString *amountStr = [NSString stringWithFormat:@"%.2f",self.recordWorkModel.recordNoteMoney];

            [self.alreadyRecordButton setTitle:[NSString stringWithFormat:@"%@%@%@%@元",self.recordWorkModel.btn_dest.name,recordOtherNoteMoneyString,accountTypeStr,[@"" stringByAppendingString:JGJMoneyNumStr(amountStr)]] forState:UIControlStateNormal];

        }
    }
}

- (IBAction)recordNoteBtnClick:(UIButton *)sender {
    //delgate
    if (self.delegate && [self.delegate respondsToSelector:@selector(RecordWorkHomeNoteViewRecordNoteBtnClick)]) {
        [self.delegate RecordWorkHomeNoteViewRecordNoteBtnClick];
    }
}

- (void)setRecordWorkModel:(RecordWorkHomeNoteModel *)recordWorkModel{
    recordWorkModel.isRecordNote = recordWorkModel.recordNoteMoney > 0;
    _recordWorkModel = recordWorkModel;
    [self setShowView];
}
@end
