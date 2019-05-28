//
//  JGJCheckAccountModulesView.m
//  mix
//
//  Created by yj on 2018/8/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJCheckAccountModulesView.h"

#import "UILabel+GNUtil.h"

@interface JGJCheckAccountModulesView()

@property (weak, nonatomic) IBOutlet UILabel *thisMonthDes;

@property (weak, nonatomic) IBOutlet UILabel *thisMonthOverTime;

@property (weak, nonatomic) IBOutlet UILabel *todayDes;

@property (weak, nonatomic) IBOutlet UILabel *todayOverTime;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *checkAccountInfoContentView;

@property (weak, nonatomic) IBOutlet UIButton *unOpenWageBtn;


@end

@implementation JGJCheckAccountModulesView

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

-(void)setupView{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.contentView.frame = self.bounds;

    [self addSubview:self.contentView];

    [self.checkAccountInfoContentView.layer setLayerBorderWithColor:AppFontdbdbdbColor width:1 radius:JGJCornerRadius];
    
    self.contentView.backgroundColor = AppFontffffffColor;
    
    NSString *thisMonthOverWork = [NSString stringWithFormat:@"加班 %@ 小时", @"0"];
    
    self.thisMonthDes.text = [NSString stringWithFormat:@"上班 %@ 小时\n%@", @"0", thisMonthOverWork];
    
    [self.thisMonthDes markLineText:thisMonthOverWork withLineFont:[UIFont boldSystemFontOfSize:AppFont28Size] withColor:AppFont000000Color lineSpace:7];
    
    NSString *todayOverWork = [NSString stringWithFormat:@"加班 %@ 小时", @"0"];
    
    self.todayDes.text = [NSString stringWithFormat:@"上班 %@ 小时\n%@", @"0", todayOverWork];
    
    [self.todayDes markLineText:todayOverWork withLineFont:[UIFont boldSystemFontOfSize:AppFont28Size] withColor:AppFont000000Color lineSpace:7];
    
    NSString *title = JLGisLeaderBool ? @"未结工资" : @"未结工资";
    
    [self.unOpenWageBtn setTitle:title forState:UIControlStateNormal];
    
}

- (void)setRecordTotalModel:(JGJHomeWorkRecordTotalModel *)recordTotalModel {
    
    _recordTotalModel = recordTotalModel;
    
     JGJAccountShowTypeModel *selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    NSInteger type = selTypeModel.type;
    
    NSString *unit = @"小时";
    
    if (type == 0 || type == 1) {
        
        unit = @"个工";
    }
    
    NSString *over_work_unit = @"小时";
    
    if (type == 1) {
        
        over_work_unit = @"个工";
    }
    
    NSString *overtime = (type != 1 ? recordTotalModel.month.overtime?:@"0" : recordTotalModel.month.overtime_hours?:@"0");
    
    
    NSString *worktime = ( type == 2 ? recordTotalModel.month.manhour?:@"0" : recordTotalModel.month.working_hours?:@"0");
    
    NSString *thisMonthOverWork = [NSString stringWithFormat:@"加班 %@ %@",overtime, over_work_unit];
    
    self.thisMonthDes.text = [NSString stringWithFormat:@"上班 %@ %@", worktime, unit];
    
    self.thisMonthOverTime.text = thisMonthOverWork;
    
    NSString *todayovertime = (type != 1 ? recordTotalModel.today.overtime?:@"0" : recordTotalModel.today.overtime_hours?:@"0");
    
    
    NSString *todaytime = ( type == 2 ? recordTotalModel.today.manhour?:@"0" : recordTotalModel.today.working_hours?:@"0");
        
    NSString *todayOverWork = [NSString stringWithFormat:@"加班 %@ %@",todayovertime, over_work_unit];
    
    self.todayDes.text = [NSString stringWithFormat:@"上班 %@ %@", todaytime, unit];
    
    self.todayOverTime.text = todayOverWork;
    
    [self.todayOverTime markText:todayovertime withFont:[UIFont boldSystemFontOfSize:AppFont28Size] color:AppFont000000Color];
    
    [self.todayDes markText:todaytime withFont:[UIFont boldSystemFontOfSize:AppFont28Size] color:AppFont000000Color];
    
    [self.thisMonthDes markText:worktime withFont:[UIFont boldSystemFontOfSize:AppFont28Size] color:AppFont000000Color];
    
    [self.thisMonthOverTime markText:overtime withFont:[UIFont boldSystemFontOfSize:AppFont28Size] color:AppFont000000Color];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    
    JGJCheckAccountModulesButtontype buttontype = (JGJCheckAccountModulesButtontype)sender.tag - 100;
    
    if ([self.delegate respondsToSelector:@selector(checkAccountModulesView:buttontype:)]) {
        
        [self.delegate checkAccountModulesView:self buttontype:buttontype];
    }
    
}

@end
