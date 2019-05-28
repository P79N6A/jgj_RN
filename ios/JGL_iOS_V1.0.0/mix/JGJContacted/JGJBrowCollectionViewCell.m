//
//  JGJBrowCollectionViewCell.m
//  mix
//
//  Created by Tony on 2017/2/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJBrowCollectionViewCell.h"
#import "JGJTimesTableViewCell.h"
#import "JGJTextFileTimeTableViewCell.h"
#import "NSDate+Extend.h"
#import "UILabel+GNUtil.h"
#define offset 30


#define headerViewHeight 100

@interface JGJBrowCollectionViewCell()
<
UITableViewDelegate,
UITableViewDataSource,
textFileEditedelegate
>


@end
@implementation JGJBrowCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius=10;
    self.layer.shadowColor=AppFonte83c76eColor.CGColor;
    self.layer.shadowOffset=CGSizeMake(0, 0);
    self.layer.shadowOpacity=0.4;
    self.layer.shadowRadius = 10;
    self.clipsToBounds = NO;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 10;
    self.contentView.backgroundColor = [UIColor whiteColor];
    CGRect rect = self.contentView.frame;
    if (isiPhoneX) {
        rect.size = CGSizeMake(TYGetUIScreenWidth - 100, TYGetUIScreenHeight - 200 - 78);

    }else{
        
        rect.size = CGSizeMake(TYGetUIScreenWidth - 100, TYGetUIScreenHeight - 200 );

    }
    [self setFrame:rect];
    [self.contentView setFrame:rect];

    _BrowTableview  = [[UITableView alloc]initWithFrame:CGRectMake(0, headerViewHeight, CGRectGetWidth(self.frame) , CGRectGetHeight(self.contentView.frame)  - headerViewHeight - 42.5)];
    _BrowTableview.backgroundColor = AppFontfafafaColor;
    _BrowTableview.delegate = self;
    _BrowTableview.dataSource = self;
    _BrowTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _BrowTableview.backgroundColor = [UIColor whiteColor];
//    _BrowTableview.tableHeaderView = self.headerViewd;
    [self addSubview: self.headerViewd];
    [self.contentView addSubview:_BrowTableview];
//    if (TYGetUIScreenWidth <= 320) {
//    [self.contentView addSubview:self.refrashViewd];
//    }
    [self.contentView addSubview:self.SaveButtond];

    if (JLGisLeaderBool || _morePeople) {
        
    
    _titleArr    = @[@[@"选择工人",@"选择日期"],@[@"填写金额",@"所在项目",@"备注"]];
    _subTitleArr =@[@[@"请选择要记账的工人",@""],@[@"请输入金额",@"例如:万科魅力之城",@"可填写备注信息"]];
    }else{
        if (TYGetUIScreenWidth<=320) {
    _subTitleArr =@[@[@"选择记账对象",@""],@[@"请输入金额",@"例如:万科魅力之城",@"可填写备注信息"]];

        }else{
    _subTitleArr =@[@[@"选择要记账的班组长/工头",@""],@[@"请输入金额",@"例如:万科魅力之城",@"可填写备注信息"]];
        }
    _titleArr    = @[@[@"班组长/工头",@"选择日期"],@[@"填写金额",@"所在项目",@"备注"]];

    }
    _imageArr = @[@[@"msjyb_icon_person_selected",@"msjyb_icon_date_selected"],@[@"msjyb_icon_price_selected",@"msjyb_icon_project_selected",@"msjyb_icon_record_selected"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickColeection)];
    tap.cancelsTouchesInView = NO;
    [_BrowTableview addGestureRecognizer:tap];
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickColeections)];
    self.headerViewd.userInteractionEnabled = YES;
    [self.headerViewd addGestureRecognizer:taps];

}
-(void)clickColeection
{
    [self endEditing:YES];
}
-(void)clickColeections
{
    
    [self endEditing:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            
            break;
        case 1:
            return 3;
            break;
   
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1&&indexPath.row == 0) {
        JGJTextFileTimeTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJTextFileTimeTableViewCell" owner:nil options:nil]firstObject];
        cell.titleLable.text = _titleArr[indexPath.section][indexPath.row];
        cell.subTextFiled.placeholder = _subTitleArr[indexPath.section][indexPath.row];
        cell.delegate = self;
        cell.subTextFiled.tag = 10;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rightConstance.constant = 30;
        cell.uniteLable.hidden = NO;
        if (_yzgGetBillModel.browNum) {
        cell.subTextFiled.text = _yzgGetBillModel.browNum;
            cell.BigBool = YES;
            cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
            cell.subTextFiled.textColor = AppFonte83c76eColor;
        }
        
        
        return cell;
    }else{
    JGJTimesTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJTimesTableViewCell" owner:nil options:nil]firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLable.text = _titleArr[indexPath.section][indexPath.row];

        cell.subTitleLable.text = _subTitleArr[indexPath.section][indexPath.row];
        if (indexPath.section == 0 &&indexPath.row == 0) {
            if (_yzgGetBillModel.name) {
            cell.subTitleLable.text = _yzgGetBillModel.name;
            cell.BigBool = YES;
            cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
                cell.subTitleLable.textColor = AppFont333333Color;
            }else{
                cell.upDepartlable.backgroundColor = [UIColor clearColor];
                cell.subTitleLable.numberOfLines = 0;
                if (JLGisLeaderBool) {
                    cell.subTitleLable.text = [NSString stringWithFormat:@"%@",@"请选择要记账的工人"];
                    
                }else{
                    cell.subTitleLable.text = [NSString stringWithFormat:@"%@\n%@",@"请选择要记账的",@"班组长/工头"];
                }
                cell.BigBool = NO;
                cell.subTitleLable.textColor = AppFontbdbdc3Color;
            }
            if (_CreaterModel) {
                cell.subTitleLable.textColor = AppFont999999Color;
                cell.arrowImage.hidden = YES;
                cell.titleLable.text   = @"班组长/工头";

            }
            if (_morePeople) {
                cell.subTitleLable.textColor = AppFontccccccColor;
                cell.arrowImage.hidden = NO;
                cell.titleLable.text   = @"选择工人";
                
                if (![NSString isEmpty: _yzgGetBillModel.name ]) {
                    cell.subTitleLable.textColor = AppFont333333Color;
                    cell.arrowImage.hidden = NO;
                }else{
                    cell.subTitleLable.text = [NSString stringWithFormat:@"%@",@"请选择要记账的工人"];

                }
                

                
            }

        }else if (indexPath.section == 0 &&indexPath.row == 1){
            cell.subTitleLable.textColor = AppFontEB4E4EColor;
            if (_yzgGetBillModel.date) {
            cell.subTitleLable.text = _yzgGetBillModel.date;
            cell.BigBool = YES;
            cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
            }else{
                if (_selectDate) {
                cell.subTitleLable.text = [self getWeekDaysString:_selectDate];
                cell.BigBool = YES;
                cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
                }else{
                cell.subTitleLable.text = [self getWeekDaysString:[NSDate date]];
                cell.BigBool = YES;
                cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
                }
            }
        }else if (indexPath.section == 1 &&indexPath.row == 1&&_yzgGetBillModel.proname){
            if (_morePeople) {
//                cell.subTitleLable.text = _yzgGetBillModel.all_pro_name;
                cell.subTitleLable.text =_yzgGetBillModel.proname?: _yzgGetBillModel.all_pro_name;

                cell.BigBool = YES;
                cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
                cell.subTitleLable.textColor = AppFont999999Color;
                cell.userInteractionEnabled = NO;
            }else{
                if ([_yzgGetBillModel.proname length] && _yzgGetBillModel.pid) {
                    cell.subTitleLable.text = _yzgGetBillModel.proname;
                    cell.BigBool = YES;
                    cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
                    cell.subTitleLable.textColor = AppFont333333Color;
                }else{
                    cell.subTitleLable.text = @"例如:万科魅力之城";
                    cell.BigBool = NO;
                    cell.subTitleLable.textColor = AppFontccccccColor;
                    
                    if (_CreaterModel) {
                        cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
                        cell.subTitleLable.textColor = AppFont333333Color;
                        
                        cell.subTitleLable.text = _yzgGetBillModel.proname;
                        cell.BigBool = YES;
                    }

                }
           
            }
        }else if (indexPath.section == 1 &&indexPath.row == 2&&_yzgGetBillModel.notes_txt){
            if (_yzgGetBillModel.notes_txt.length <=0) {
                cell.subTitleLable.text = @"可填写备注信息";
                cell.subTitleLable.textColor = AppFont999999Color;
                cell.BigBool = NO;
                cell.subTitleLable.numberOfLines = 1;

            }else{
            cell.subTitleLable.text = _yzgGetBillModel.notes_txt;
                cell.subTitleLable.textColor = AppFont333333Color;
                cell.BigBool = YES;
                cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
                cell.subTitleLable.numberOfLines = 2;

            }
        
        }
        if (_yzgGetBillModel&& ((indexPath.section !=0&&indexPath.row != 1) ||(indexPath.section != 1 &&indexPath.row != 2))) {
//            cell.subTitleLable.textColor = AppFont333333Color;
        }
        
        if (indexPath.section == 0 &&indexPath.row == 0) {
            cell.upDepartlable.backgroundColor = [UIColor clearColor];
        }
        if (indexPath.section == 1 && indexPath.row == 2) {
            cell.bottomLable.backgroundColor = [UIColor clearColor];
            
        }
    return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame)+45, 10)];
    
    view.backgroundColor = [UIColor whiteColor];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(18.5, 0, 1, 10)];
    if (section != 0) {

    lable.backgroundColor = AppFonte8e8e8Color;
    }else{
    
        lable.backgroundColor = [UIColor clearColor];

    }
    [view addSubview:lable];
    return view;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didselectedbrowTableviewforIndexpath:withTableviewclass:)]) {
        [self.delegate didselectedbrowTableviewforIndexpath:indexPath withTableviewclass:NSStringFromClass([_BrowTableview class])];
    }
}
- (UIImageView *)headerViewd
{
    if (!_headerViewd) {

        _headerViewd = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) , headerViewHeight)];

        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headerViewd.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.headerViewd.bounds;
        maskLayer.path = maskPath.CGPath;
        self.headerViewd.layer.mask = maskLayer;
        _headerViewd.image = [UIImage imageNamed:@"msjyb_borrow_bg"];
        [_headerViewd addSubview:self.NumLabled];
//        [_headerViewd addSubview:self.imageviewd];
        [_headerViewd addSubview:self.deslabled];
    }
    
    return _headerViewd;
}
- (UILabel *)NumLabled
{
    if (!_NumLabled) {
//        _NumLabled = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 35)];
//        _NumLabled.text = @"0.00";
//        _NumLabled.textAlignment = NSTextAlignmentCenter;
//
//        _NumLabled.center = CGPointMake(CGRectGetMidX(self.contentView.frame), 30);
//
//        _NumLabled.font = [UIFont fontWithName:@"Impact" size:40];
//        _NumLabled.textColor = AppFontfafafaColor;
//        [self changeFontwithstr:_NumLabled.text withFont:[UIFont systemFontOfSize:20]];
        _NumLabled = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, CGRectGetWidth(self.frame) - 20, 35)];
        //        _NumLable.center = CGPointMake(CGRectGetMidX(self.frame) , 30);
        _NumLabled.text = @"0.00 借支工钱";
        
        _NumLabled.textAlignment = NSTextAlignmentCenter;
        _NumLabled.font = [UIFont boldSystemFontOfSize:20];
        
        _NumLabled.textColor = [UIColor whiteColor];
         [self changeFontwithstr:_NumLabled.text withFont:[UIFont systemFontOfSize:20]];
    }
    return _NumLabled;
}
- (UIButton *)SaveButtond
{
    if (!_SaveButtond) {

        _SaveButtond = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 42.5  , CGRectGetWidth(self.frame), 42.5)];
        [_SaveButtond setTitle:@"保存" forState:UIControlStateNormal];
        _SaveButtond.backgroundColor = AppFonte73bf5cColor;
        _SaveButtond.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
        [_SaveButtond setTitleColor:AppFontfafafaColor forState:UIControlStateNormal];
        [_SaveButtond  addTarget:self action:@selector(ClicksaveButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _SaveButtond;
}
- (UIImageView *)imageviewd
{
    if (!_imageviewd) {
        

        _imageviewd = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.headerViewd.frame) - 37 , CGRectGetMaxY(self.NumLabled.frame)+5, 20, 20)];

        _imageviewd.image = [UIImage imageNamed:@"gold_green"];
    }
    
    return _imageviewd;
}
- (UILabel *)deslabled
{
    if (!_deslabled) {
//        _deslabled = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageviewd.frame)+5, CGRectGetMinY(_imageviewd.frame), 100, 20)];
//        _deslabled.text = @"借支工钱";
//        _deslabled.textColor = AppFontfafafaColor;
//        _deslabled.font = [UIFont systemFontOfSize:13];
        _deslabled = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 250)/2, 15, 250, 25)];
        if (TYGetUIScreenWidth <= 320) {
            _deslabled = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 25)];
            _deslabled.font = [UIFont boldSystemFontOfSize:11];
 
        }else{
            _deslabled.font = [UIFont boldSystemFontOfSize:13];

        }
        _deslabled.layer.cornerRadius = 12.5;
        _deslabled.layer.borderColor = [UIColor whiteColor].CGColor;
        _deslabled.layer.borderWidth = 0.5;
        _deslabled.layer.masksToBounds = YES;
        _deslabled.text = @" 手机记工 数据不丢失 对账有依据 ";
        _deslabled.textAlignment = NSTextAlignmentCenter;
        _deslabled.textColor = [UIColor whiteColor];
        [_deslabled addSubview:self.leftimageview];
        [_deslabled addSubview:self.rightimageview];
    }
    return _deslabled;
}
- (UIView *)refrashViewd
{
    if (!_refrashViewd) {

        _refrashViewd = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetMinY(self.SaveButtond.frame)-30 , CGRectGetWidth(self.frame),30)];

        _refrashViewd.backgroundColor = AppFontfafafaColor;
        [_refrashViewd setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [_refrashViewd setImage:[UIImage imageNamed:@"箭头-拷贝-7"] forState:UIControlStateSelected];
        [_refrashViewd  addTarget:self action:@selector(ClickRefreshButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refrashViewd;
}
- (void)ClickRefreshButton:(UIButton *)sender
{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:2 inSection:1];
    
    [self.BrowTableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(void)ClicksaveButton:(UIButton *)sender
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSaveDatabrowButtonwithModel:)]) {
        [self.delegate clickSaveDatabrowButtonwithModel:_yzgGetBillModel];
    }

}
- (NSString *)getWeekDaysString:(NSDate *)date{
    if (!date) {
        return @"";
    }
//    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"", @"", @"", @"", @"", @"", @"", nil];

    NSString *dateString = [NSString stringWithFormat:@"%@ %@",[NSDate stringFromDate:date format:@"yyyy-MM-dd"],[weekdays objectAtIndex:[NSDate weekdayStringFromDate:date]]];
    //如果是今天要显示
    if ([date isToday]) {
        dateString = [dateString stringByAppendingString:@"(今天)"];
    }
    return dateString;
}

-(void)setYzgGetBillModel:(YZGGetBillModel *)yzgGetBillModel
{
   
    _yzgGetBillModel = [YZGGetBillModel new];
    _yzgGetBillModel = yzgGetBillModel;
    if (!yzgGetBillModel.date) {
        _yzgGetBillModel.date = [self getWeekDaysString:[NSDate date]];
    }

    if (_selectDate&& !_yzgGetBillModel.date) {
        _yzgGetBillModel.date = [self getWeekDaysString:_selectDate];
    }
    
    if (!_yzgGetBillModel.browNum ) {
        
    _NumLabled.text  = [NSString stringWithFormat:@"0.00 借支工钱"];
    [self changeFontwithstr:_NumLabled.text withFont:[UIFont systemFontOfSize:20]];
        
    }
    [_BrowTableview reloadData];
}
-(void)animationNum
{
    _NumLabled.text = [NSString stringWithFormat:@"%u",(arc4random() % 50) + 161 ];
}
-(void)didendtextfiledfortext:(NSString *)text withTexttag:(NSInteger)tag
{
    if (tag == 10) {
        _yzgGetBillModel.browNum = text;
        _NumLabled.text = text;
        _NumLabled.text  = [NSString stringWithFormat:@"%.2f 借支工钱",[text floatValue]];
        [self changeFontwithstr:_NumLabled.text withFont:[UIFont systemFontOfSize:20]];
    }
}
-(void)changeFontwithstr:(NSString *)str withFont:(UIFont *)font{
    if (str.length >= 4) {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSFontAttributeName
                value:[UIFont fontWithName:@"Impact" size:10]
                range:NSMakeRange(str.length-4, 4)];
    _NumLabled.attributedText = attrStr;
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}
-(void)setSelectDate:(NSDate *)selectDate
{
    _selectDate = selectDate;

}
-(UIImageView *)leftimageview
{
    if (!_leftimageview) {
        _leftimageview = [[UIImageView alloc]initWithFrame:CGRectMake( 9, 10, 5, 5)];
        _leftimageview.backgroundColor = [UIColor whiteColor];
        _leftimageview.layer.masksToBounds =  YES;
        _leftimageview.layer.cornerRadius = 2.5;
    }
    return _leftimageview;
}

-(UIImageView *)rightimageview
{
    if (!_rightimageview) {
        _rightimageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_deslabled.frame) - 14, 10, 5, 5)];
        _rightimageview.backgroundColor = [UIColor whiteColor];
        _rightimageview.layer.masksToBounds =  YES;
        _rightimageview.layer.cornerRadius = 2.5;
    }
    return _rightimageview;
    
}
@end
