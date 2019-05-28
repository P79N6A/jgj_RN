//
//  JLGManageProjMainTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGManageProjMainTableViewCell.h"

@interface JLGManageProjButton : UIButton
//content内容
@property (copy,nonatomic)   NSString *totalStr;
@property (strong,nonatomic) NSMutableArray *stringArray;
@end

@implementation JLGManageProjButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setButtonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setButtonInit];
    }
    return self;
}

- (void)setButtonInit{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setTitleColor:TYColorHex(0x46a6ff) forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor]forState:UIControlStateSelected];
    [self.layer setLayerBorderWithColor:TYColorHex(0x46a6ff) width:1.0 radius:12.0];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self setBackgroundColor:TYColorHex(0x46a6ff)];
    }else{
        [self setBackgroundColor:[UIColor whiteColor]];
    }
}
@end

@interface JLGManageProjMainTableViewCell ()
@property (weak, nonatomic) IBOutlet JGJLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *proname;
@property (weak, nonatomic) IBOutlet UIView *fullView;
@property (weak, nonatomic) IBOutlet UIView *poitView;
@property (weak, nonatomic) IBOutlet UIView *notFullView;
@property (weak, nonatomic) IBOutlet UILabel *lableLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *protitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *prodescripLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isFullImage;


//ConsTraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLayoutH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointViewLayoutL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBackLayoutH;
@end
@implementation JLGManageProjMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.poitView.layer setLayerCornerRadius:TYGetViewW(self.poitView)/2];
    [self setButtonWithTag:11 byNum:3];
    [self setButtonWithTag:21 byNum:1];
    self.excludeContentH = 90;
    self.protitleLabel.tintColor = TYColorHex(0x333333);
    self.protitleLabel.font = [UIFont boldSystemFontOfSize:self.protitleLabel.font.pointSize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setJlgMPModel:(JLGMPModel *)jlgMPModel{
    _jlgMPModel = jlgMPModel;
    
    [self setCellSubViews:jlgMPModel];
}

- (void)setCellSubViews:(JLGMPModel *)jlgMPModel{
    self.contentLayoutH.constant = jlgMPModel.strViewH;
    
    //设置富文本
    self.contentLabel.attributedText = jlgMPModel.attributedStr;
    
    //设置左上角的圆角
    [self setPoitViewLayoutL:jlgMPModel.is_call];
    
    //是否需要垫资
    self.protitleLabel.text = jlgMPModel.protitle;

    //开工耗时的字符串
    NSString *timelimit = (![jlgMPModel.timelimit isEqualToString:@""] && jlgMPModel.timelimit)?jlgMPModel.timelimit:@"数周";
    NSString *total_area = jlgMPModel.total_area && ![jlgMPModel.total_area isEqualToString:@"0"]?[NSString stringWithFormat:@"总面积:%@m²",jlgMPModel.total_area]:@"总面积:较大";
    self.totalInfoLabel.text = [NSString stringWithFormat:@"工期:%@  %@",timelimit,total_area];
    
    //显示是否已招满
    self.isFullImage.hidden = !(jlgMPModel.is_full == 0);
    self.fullView.hidden = !(jlgMPModel.is_full == 0);
    self.notFullView.hidden = (jlgMPModel.is_full == 0);

    self.regionLabel.text = jlgMPModel.regionname;
    self.prodescripLabel.text = jlgMPModel.prodescrip;
    self.lableLabel.text = jlgMPModel.find_role == 1?@"找工人":@"找班组长/工头";
    
    [self setDealApplyButton:jlgMPModel];
}

- (void)setDealApplyButton:(JLGMPModel *)jlgMPModel{
    UIButton *dealApplyButton = [self.contentView viewWithTag:14];
    NSString *dealApplayString = [NSString stringWithFormat:@"处理报名(%@)",@(jlgMPModel.enroll_num)];
    [dealApplyButton setTitle:dealApplayString forState:UIControlStateNormal];
    dealApplyButton = [self.contentView viewWithTag:22];
    [dealApplyButton setTitle:dealApplayString forState:UIControlStateNormal];
}

//tag，第一个tag值，num一共有多少个button
- (void)setButtonWithTag:(NSUInteger )tag byNum:(NSUInteger )num{
    for (NSInteger i = 0; i < num; i++) {
        UIButton *button = [ self.contentView viewWithTag:i + tag];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:JGJMainColor forState:UIControlStateNormal];
        [button.layer setLayerBorderWithColor:JGJMainColor width:0.5 radius:2.5];
        button.layer.masksToBounds = YES;
    }
}


- (IBAction)selectBtnClick:(UIButton *)sender {
    NSInteger tag = sender.tag;
    
    selectedType selectedType = selectedTypeNoFullIsFull;
    switch (tag) {
        case 11:
            selectedType = selectedTypeNoFullIsFull;
            break;
        case 12:
            selectedType = selectedTypeNoFullRefresh;
            break;
        case 13:
            selectedType = selectedTypeNoFullModify;
            break;
        case 14:
            selectedType = selectedTypeNoFullDealApply;
            break;
        case 21:
            selectedType = selectedTypeFullSendAgain;
            break;
        case 22:
            selectedType = selectedTypeFullDealApply;
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(MPMainCellBtnClick:indexPath:)]) {
        [self.delegate MPMainCellBtnClick:selectedType indexPath:self.tag];
    }
}

//设置poitViewLayoutL
- (void)setPoitViewLayoutL:(BOOL )isCall{
    if (isCall == YES) {
        self.poitView.hidden = YES;
        self.pointViewLayoutL.constant = 0;
    }else{
        self.poitView.hidden = NO;
        self.pointViewLayoutL.constant = 10;
    }
}

- (void)setTag:(NSInteger)tag{
    [super setTag:tag];
    self.topBackLayoutH.constant = (tag == 0)?0:10;
}
@end
