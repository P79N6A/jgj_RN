//
//  JGJHomeProCell.m
//  mix
//
//  Created by yj on 2018/6/12.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJHomeProCell.h"

#import "UIView+GNUtil.h"

#import "UILabel+GNUtil.h"

@interface JGJHomeProCell ()

@property (weak, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewH;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet UILabel *typeName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tyNameW;

@property (weak, nonatomic) IBOutlet UILabel *pro_title;

@property (weak, nonatomic) IBOutlet UILabel *pro_type;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pro_typeW;

@property (weak, nonatomic) IBOutlet UILabel *unitTitle;

@property (weak, nonatomic) IBOutlet UILabel *unit;

@property (weak, nonatomic) IBOutlet UILabel *scaleTitle;

@property (weak, nonatomic) IBOutlet UILabel *scale;

@property (weak, nonatomic) IBOutlet UILabel *des;

@property (weak, nonatomic) IBOutlet UILabel *welfareTitle;

@property (weak, nonatomic) IBOutlet JGJWelfareTagView *welfareView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *welfareViewH;

@property (weak, nonatomic) IBOutlet UILabel *sharefriendnum;

@property (weak, nonatomic) IBOutlet UILabel *create_time_txt;

@property (weak, nonatomic) IBOutlet UIImageView *authoFlag;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewBottom;


@end

@implementation JGJHomeProCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.containView.frame = CGRectMake(0, 0, TYGetUIScreenWidth, 195);
//
    [self.containView.layer setLayerCornerRadius:5];
//
//    self.containView.layer.masksToBounds = YES;
//
//    [UIView maskLayerTarget:self.containView roundCorners:UIRectCornerAllCorners cornerRad:CGSizeMake(JGJCornerRadius,  JGJCornerRadius)];
    
    self.bottomLineView.backgroundColor = AppFontf1f1f1Color;
    
    //点工、包工、总包 标题
    self.typeName.textColor = [UIColor whiteColor];
    
    self.typeName.backgroundColor = AppFontEBEBEBColor;
    
    [self.typeName.layer setLayerCornerRadius:2.5];
    
    self.pro_title.font = [UIFont boldSystemFontOfSize:AppFont32Size];
    
    self.pro_title.textColor = AppFont333333Color;
    
    
    self.pro_type.textColor = AppFont666666Color;
    
    self.pro_type.backgroundColor = AppFonteeeeeeColor;
    
    [self.pro_type.layer setLayerCornerRadius:2.5];
    
    //单价
    
    self.unitTitle.textColor = AppFont333333Color;
    
    self.unit.textColor = AppFont999999Color;
    
    self.des.textColor = AppFont999999Color;
    
    self.welfareTitle.textColor = AppFont333333Color;
    
    self.sharefriendnum.textColor = AppFont999999Color;
    
    self.create_time_txt.textColor = AppFont999999Color;
    
    self.scale.textColor = AppFont999999Color;
    
    self.des.preferredMaxLayoutWidth = TYGetUIScreenWidth - 20;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProInfo:)];
    
    tap.numberOfTapsRequired = 1;
    
    [self.containView addGestureRecognizer:tap];
}

- (void)setListModel:(JGJEmployListModel *)listModel {
    
    _listModel = listModel;
    
    self.containViewH.constant = listModel.cellHeight - self.bottomLineView.height;
    
    if (listModel.welfare.count > 0) {
        
        self.welfareView.tags = listModel.welfare;
        
        self.welfareViewH.constant = listModel.tagView.height;
        
        self.welfareTitle.hidden = NO;
        
        self.welfareView.hidden = NO;
        
        self.tagViewBottom.constant = 15;
        
    }else {
        
        self.welfareViewH.constant = 0;
        
        self.welfareTitle.hidden = YES;
        
        self.welfareView.hidden = YES;
        
        self.tagViewBottom.constant = 0;
        
    }
    
    JGJEmployClassesModel *classModel = nil;
    
    if (listModel.classes > 0) {
        
        classModel = listModel.classes.firstObject;
    }
    
    self.pro_type.text = classModel.pro_type.type_name;
    
    self.des.text = listModel.pro_description;
    
    self.sharefriendnum.hidden = [listModel.sharefriendnum isEqualToString:@"0"];
    
    self.sharefriendnum.text = [NSString stringWithFormat:@"你有 %@ 个朋友认识工头", listModel.sharefriendnum];
    
    if (![NSString isEmpty:listModel.sharefriendnum]) {
        
        [self.sharefriendnum markText:listModel.sharefriendnum withColor:AppFontEB4E4EColor];
    }
    
    NSString *distance = [NSString stringWithFormat:@"/%@", listModel.distance];
    
    if ([NSString isEmpty:listModel.distance]) {
        
        distance = @"";
    }
    
    self.create_time_txt.text = [NSString stringWithFormat:@"%@%@", listModel.create_time_txt,distance];
    
    self.pro_title.text = listModel.pro_title;
    
    self.authoFlag.hidden = ![listModel.is_company_auth isEqualToString:@"2"];
    
    JGJEmployTypeModel *cooperate_type = classModel.cooperate_type;
    
    self.tyNameW.constant = cooperate_type.type_nameW;
    
    NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:AppFont24Size]};
    
    CGRect frame_W = [classModel.pro_type.type_name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
      
    self.pro_typeW.constant = frame_W.size.width + 10;

    NSString *unitStr = [NSString stringWithFormat:@" 元/%@", classModel.balance_way];
    
    NSString *money = classModel.money;
    
    CGFloat converMoney = [NSString stringWithFormat:@"%@", money].doubleValue;
    
    if (converMoney >= 1000) {
        
        money = [self unitConverWithMoney:money];
    }
    
    NSString *unitMoney = [NSString stringWithFormat:@"%@", classModel.unitMoney];
    
    CGFloat converUnitMoney = [NSString stringWithFormat:@"%@", unitMoney].doubleValue;
    
    if (converUnitMoney >= 10000) {
        
        unitMoney = [self unitConverWithMoney:unitMoney];
    }
    
    NSString *total_scale = [NSString stringWithFormat:@"%@", classModel.total_scale];
    
    CGFloat conver_total_scale = [NSString stringWithFormat:@"%@", total_scale].doubleValue;
    
    if (conver_total_scale >= 1000) {
        
        total_scale = [self unitConverWithMoney:total_scale];
    }
    
    //单价 人数 总价
    NSString *unitTitle = @"";
    
//    //人  *元/米  元
//    NSString *unit = @"";
    
    //规模 工资 规模
    NSString *scaleTitle = @"";
    
//    //人 米 元
//    NSString *scale = @"";
    
    //点工 包工 总包
    self.typeName.text = cooperate_type.type_name;
    
    UIColor *typeBackColor = AppFontEB4E4EColor;
    
    if (cooperate_type.type_id == 1) { //点工
        
        unitTitle = @"人数";
        
        scaleTitle = @"工资";
        
        self.scale.text = [NSString stringWithFormat:@"%@%@", money,unitStr];
        
        if ([money isEqualToString:@"0"]) {
            
            unitStr = @"面议";
            
            self.scale.text = unitStr;
        
            [self.scale markText:unitStr withColor:AppFontEB4E4EColor];
            
        }else {
            
            self.scale.text = [NSString stringWithFormat:@"%@%@", money,unitStr];
            
            [self.scale markText:money withColor:AppFontEB4E4EColor];
        }
        
        typeBackColor = TYColorHex(0xEB7A4E);
        
        self.unit.text = [NSString stringWithFormat:@"%@ 人", classModel.person_count];
        
        if (![NSString isEmpty:classModel.person_count]) {
            
            [self.unit markText:classModel.person_count withColor:AppFontEB4E4EColor];
        }
        
        self.scaleTitle.text = scaleTitle;
        
    }else if (cooperate_type.type_id == 2 ) { //2包工，3总包
        
        unitTitle = @"单价"; //用unitMoney
        
        scaleTitle = @"规模"; //total_scale
        
        if ([unitMoney isEqualToString:@"0"]) {
            
            unitStr = @"面议";
            
            self.unit.text = unitStr;
            
            [self.unit markText:unitStr withColor:AppFontEB4E4EColor];
            
        }else {
            
            self.unit.text = [NSString stringWithFormat:@"%@%@", unitMoney, unitStr];
            
            [self.unit markText:unitMoney withColor:AppFontEB4E4EColor];
            
        }
        
        if (![total_scale isEqualToString:@"0"]) {
            
            self.scale.text = [NSString stringWithFormat:@"%@ %@", total_scale, classModel.balance_way];
            
            [self.scale markText:total_scale withColor:AppFontEB4E4EColor];
            
            
        }else {
            
            unitStr = @"面议";
            
            self.scale.text = unitStr;
            
            [self.scale markText:unitStr withColor:AppFontEB4E4EColor];
            
        }
        
        typeBackColor = AppFontEB4E4EColor;
        
    }else if (cooperate_type.type_id == 3) {//总包
        
        unitTitle = @"总价";
        
        scaleTitle = @"规模";
        
        typeBackColor = AppFontF9A00FColor;
        
        if ([money isEqualToString:@"0"]) {
            
            unitStr = @"面议";
            
            self.unit.text = unitStr;
            
            [self.unit markText:unitStr withColor:AppFontEB4E4EColor];
            
        }else {
            
            self.unit.text = [NSString stringWithFormat:@"%@ 元", money];
            
            [self.unit markText:money withColor:AppFontEB4E4EColor];
            
        }
        
        if (![total_scale isEqualToString:@"0"]) {
            
            self.scale.text = [NSString stringWithFormat:@"%@ %@", total_scale, classModel.balance_way];
            
            [self.scale markText:total_scale withColor:AppFontEB4E4EColor];
            
            
        }else {
            
            unitStr = @"面议";
            
            self.scale.text = unitStr;
            
            [self.scale markText:unitStr withColor:AppFontEB4E4EColor];
            
        }
        
    }
    
    self.typeName.backgroundColor = typeBackColor;
    
    self.scaleTitle.text = scaleTitle;
    
    self.unitTitle.text = unitTitle;
}

- (NSString *)unitConverWithMoney:(NSString *)money {
    
    double moneyF = [NSString stringWithFormat:@"%@", money].doubleValue;
    
    double m = (moneyF / 1000.0);
    
    double converMoney = [NSString stringWithFormat:@"%.2lf",m / 10.0].doubleValue;
    
    NSString *moneyceil = [NSString stringWithFormat:@"%.2lf", converMoney];
    
    moneyceil = [moneyceil stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
    if (![NSString isEmpty:moneyceil] && moneyceil.length > 2 && [moneyceil containsString:@"."]) {
        
        NSString *lastZero = [moneyceil substringFromIndex:moneyceil.length - 1];
        
        if ([lastZero isEqualToString:@"0"]) {
            
            moneyceil = [moneyceil substringToIndex:moneyceil.length - 1];
        }
        
    }
    
    moneyceil = (moneyF >= 1000) ? [NSString stringWithFormat:@"%@万", moneyceil] : money;
    
    return moneyceil;
}

- (void)tapProInfo:(UITapGestureRecognizer *)tap {
    
    //这里没用系统的颜色是因为用了 delaysContentTouches
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if (self.homeProCellBlock) {

            self.homeProCellBlock(self.listModel);
        }

        self.contentView.backgroundColor = [UIColor whiteColor];

    });
    
    self.contentView.backgroundColor = AppFontE4E4E4Color;
    
    TYLog(@"=================------");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
