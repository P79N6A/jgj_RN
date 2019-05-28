//
//  JGJPackCollectionViewCell.m
//  mix
//
//  Created by Tony on 2017/2/28.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPackCollectionViewCell.h"
#import "JGJTimesTableViewCell.h"
#import "JGJTextFileTimeTableViewCell.h"
#import "NSDate+Extend.h"

#define offset 30
#define headerViewHeight 100
@interface JGJPackCollectionViewCell()<
UITableViewDelegate,
UITableViewDataSource,
textFileEditedelegate
>
{
    int start;
    int end;
}
@property (nonatomic ,strong)NSTimer *timer;
@property (nonatomic ,strong)UIImageView *AnimationView;
@property (nonatomic ,strong)UIImageView *clearImageview;

@end
@implementation JGJPackCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    
//    self.layer.shadowColor = [UIColor redColor].CGColor;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius=10;
    self.layer.shadowColor=AppFontEB4E4EColor.CGColor;
    self.layer.shadowOffset=CGSizeMake(0, 2);
    self.layer.shadowOpacity=0.4;
    self.layer.shadowRadius = 10;
    self.clipsToBounds = NO;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 10;

    CGRect rect = self.contentView.frame;
    
    if (isiPhoneX) {
        rect.size = CGSizeMake(TYGetUIScreenWidth - 100, TYGetUIScreenHeight - 200 - 78);
        
    }else{
        
        rect.size = CGSizeMake(TYGetUIScreenWidth - 100, TYGetUIScreenHeight - 200 );
        
    }
    [self setFrame:rect];
    [self.contentView setFrame:rect];
    self.contentView.backgroundColor = [UIColor whiteColor];
    _packTableview  = [[UITableView alloc]initWithFrame:CGRectMake(0, headerViewHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.contentView.frame) -  headerViewHeight - 42.5)];
    _packTableview.backgroundColor = AppFontfafafaColor;
    _packTableview.delegate = self;
    _packTableview.dataSource = self;
    _packTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _packTableview.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_packTableview];
    [self.contentView addSubview:self.headerViews];
    [self.contentView addSubview:self.SaveButtons];
    [self addSubview:self.AnimationView];
    if (JLGisLeaderBool || _morePeople) {
    _titleArr    = @[@[@"选择工人",@"选择日期"],@[@"分项名称",@"填写单价",@"填写数量",@"所在项目"],@[@"备注"]];
        _subTitleArr =@[@[@"请选择要记账的工人",@""],@[@"例如:包柱子/挂窗帘",@"这里输入单价金额",@"这里输入数量",@"例如:万科魅力之城"],@[@"可填写备注信息"]];
    }else{
    _titleArr    = @[@[@"班组长/工头",@"选择日期"],@[@"分项名称",@"填写单价",@"填写数量",@"所在项目"],@[@"备注"]];
    if (TYGetUIScreenWidth <= 320) {
        _subTitleArr =@[@[@"选择记账对象",@""],@[@"例如:包柱子/挂窗帘",@"这里输入单价金额",@"这里输入数量",@"例如:万科魅力之城"],@[@"可填写备注信息"]];
 
        }else{
            _subTitleArr =@[@[@"选择要记账的班组长/工头",@""],@[@"例如:包柱子/挂窗帘",@"这里输入单价金额",@"这里输入数量",@"例如:万科魅力之城"],@[@"可填写备注信息"]];
        }
    
    }
    _imageArr = @[@[@"projects",@"The-date-of"],@[@"The-contact",@"number",@"number",@"project"],@[@"note"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickColeection)];
    tap.cancelsTouchesInView = NO;
    [_packTableview addGestureRecognizer:tap];
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickColeections)];
    self.headerViews.userInteractionEnabled = YES;
    [self.headerViews addGestureRecognizer:taps];

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
            return 4;
            break;
        case 2:
            return 1;
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
    
    return 3;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
if (indexPath.section == 1 && (indexPath.row == 0 ||indexPath.row ==1||indexPath.row ==2)) {
    JGJTextFileTimeTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJTextFileTimeTableViewCell" owner:nil options:nil]firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.delegate = self;
    
    cell.titleLable.text = _titleArr[indexPath.section][indexPath.row];
    
    cell.subTextFiled.placeholder = _subTitleArr[indexPath.section][indexPath.row];

    cell.subTextFiled.tag = indexPath.row;
    
    if (indexPath.row == 1) {
        cell.rightConstance.constant = 30;
        cell.uniteLable.hidden = NO;
        cell.uniteLable.textColor = AppFont333333Color;
    }else{
        cell.rightConstance.constant = 10;
        cell.uniteLable.hidden = YES;
    }
    
    if (indexPath.row == 0 && _yzgGetBillModel.sub_proname) {
        
        cell.subTextFiled.text = _yzgGetBillModel.sub_proname;
        
        cell.BigBool = YES;
        
        cell.subTextFiled.textColor = AppFont333333Color;

        cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
        
    }else if (indexPath.row == 1&&_yzgGetBillModel.unitprice){
        
        cell.subTextFiled.text = [NSString stringWithFormat:@"%.2f",_yzgGetBillModel.unitprice];
        
        cell.subTextFiled.textColor = AppFont333333Color;
        
        cell.BigBool = YES;
        
        cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];

    }else if (indexPath.row == 2&&_yzgGetBillModel.quantities)
    {
        cell.subTextFiled.text = [NSString stringWithFormat:@"%.2f %@",_yzgGetBillModel.quantities,_yzgGetBillModel.units];
        
        cell.BigBool = YES;
        
        cell.subTextFiled.textColor = AppFont333333Color;

        cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
    }
        return cell;
    }else{
    JGJTimesTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJTimesTableViewCell" owner:nil options:nil]firstObject];
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    cell.titleLable.text = _titleArr[indexPath.section][indexPath.row];
        
    cell.subTitleLable.text = _subTitleArr[indexPath.section][indexPath.row];
        
    if ( indexPath.section == 0 && indexPath.row == 0) {
        
            if (!_yzgGetBillModel.name) {
                
                cell.upDepartlable.backgroundColor = [UIColor clearColor];
                
                cell.subTitleLable.numberOfLines = 0;
                
                if (JLGisLeaderBool) {
                    
                    cell.subTitleLable.text = [NSString stringWithFormat:@"%@",@"请选择要记账的工人"];
                    
                }else{
                    
                    cell.subTitleLable.text = [NSString stringWithFormat:@"%@\n%@",@"请选择要记账的",@"班组长/工头"];
                    
                }

                cell.BigBool = NO;
                
                cell.subTitleLable.textColor = AppFontbdbdc3Color;
                
            }else{
                
            cell.subTitleLable.text = _yzgGetBillModel.name;
                
            cell.BigBool = YES;
                
            cell.subTitleLable.textColor = AppFont333333Color;
                
            cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
            }
            
            //聊天进入
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

        }else if (indexPath.section == 0 && indexPath.row == 1){
            cell.subTitleLable.textColor = AppFontEB4E4EColor;

            if (_yzgGetBillModel.date) {
            cell.subTitleLable.text = _yzgGetBillModel.date;
            cell.BigBool = YES;
            cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
            }else{
                
                cell.subTitleLable.text = [self getWeekDaysString:[NSDate date]];
                cell.BigBool = YES;
                cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
            }

        }else if (_yzgGetBillModel.proname && indexPath.section == 1 && indexPath.row == 3)
        {
            
            if (_morePeople) {
//                cell.subTitleLable.text = _yzgGetBillModel.all_pro_name;
                cell.subTitleLable.text = _yzgGetBillModel.proname?:_yzgGetBillModel.all_pro_name;

                cell.BigBool = YES;
                cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
                cell.subTitleLable.textColor = AppFont999999Color;
                cell.userInteractionEnabled = NO;
            }else{
                if ([_yzgGetBillModel.proname length] &&_yzgGetBillModel.pid) {
                    
               
            cell.subTitleLable.text = _yzgGetBillModel.proname;
            cell.BigBool = YES;
            cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
            cell.subTitleLable.textColor = AppFont333333Color;
                }else{
            cell.BigBool = NO;
                    cell.subTitleLable.text = @"例如:万科魅力之城";
            cell.subTitleLable.textColor = AppFontccccccColor;
                    
            if (_CreaterModel) {
                        cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
                        cell.subTitleLable.textColor = AppFont333333Color;
                        
                        cell.subTitleLable.text = _yzgGetBillModel.proname;
                        cell.BigBool = YES;
                    }

                }

            }
        }else if (_yzgGetBillModel.notes_txt && indexPath.section == 2 && indexPath.row == 0){
            if (_yzgGetBillModel.notes_txt.length >0) {
                cell.BigBool = YES;
                cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
                cell.subTitleLable.text = _yzgGetBillModel.notes_txt;
                cell.subTitleLable.textColor = AppFont333333Color;
                cell.subTitleLable.numberOfLines = 2;
            }else{
                
                cell.subTitleLable.text = @"可填写备注信息";
                cell.BigBool = NO;

                cell.subTitleLable.textColor = AppFontbdbdc3Color;
            }
         
        }
//        if (_yzgGetBillModel&& (indexPath.section !=0&&indexPath.row != 1)) {
//            cell.subTitleLable.textColor = AppFont333333Color;
//        }

        
        if (indexPath.section == 0 &&indexPath.row == 0) {
            cell.upDepartlable.backgroundColor = [UIColor clearColor];
        }
        if (indexPath.section == 2 && indexPath.row == 0) {
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(didselectedPackTableviewforIndexpath:withTableviewclass:)]) {
        [self.delegate didselectedPackTableviewforIndexpath:indexPath withTableviewclass:NSStringFromClass([_packTableview class])];
    }
    
    
}
- (UIView *)headerViews
{
    if (!_headerViews) {
        _headerViews = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), headerViewHeight)];

        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_headerViews.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _headerViews.bounds;
        maskLayer.path = maskPath.CGPath;
        _headerViews.layer.mask = maskLayer;

        _headerViews.image = [UIImage imageNamed:@"background"];
        [_headerViews addSubview:self.NumLables];
//        [_headerViews addSubview:self.imageviews];
        [_headerViews addSubview:self.deslables];
    }
    
    return _headerViews;
}
- (UILabel *)NumLables
{
    if (!_NumLables) {
        
//        _NumLables = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 35)];
//        _NumLables.center = CGPointMake(CGRectGetMidX(self.frame) , 30);
//        _NumLables.text = @"0.00";
//        _NumLables.textAlignment = NSTextAlignmentCenter;
//        _NumLables.font = [UIFont fontWithName:@"Impact" size:40];
//        _NumLables.textColor = AppFontfafafaColor;
//        [self changeFontwithstr:_NumLables.text withFont:[UIFont systemFontOfSize:30]];
        
        _NumLables = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, CGRectGetWidth(self.frame) - 20, 35)];
        //        _NumLable.center = CGPointMake(CGRectGetMidX(self.frame) , 30);
        _NumLables.text = @"0.00 包工工钱";
        
        _NumLables.textAlignment = NSTextAlignmentCenter;
        _NumLables.font = [UIFont boldSystemFontOfSize:20];
        
        _NumLables.textColor = [UIColor whiteColor];

    }
    return _NumLables;
}
- (UIButton *)SaveButtons
{
    if (!_SaveButtons) {
        _SaveButtons = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 42.5 , CGRectGetWidth(self.frame), 42.5)];

        [_SaveButtons setTitle:@"保存" forState:UIControlStateNormal];
        _SaveButtons.backgroundColor = AppFontEB4E4EColor;
        _SaveButtons.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
        [_SaveButtons setTitleColor:AppFontfafafaColor forState:UIControlStateNormal];
        [_SaveButtons addTarget:self action:@selector(clickSaveButtons:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _SaveButtons;
}
- (UIImageView *)imageviews
{
    if (!_imageviews) {

        _imageviews= [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.headerViews.frame) - 40, CGRectGetMaxY(self.NumLables.frame), 20, 20)];

        _imageviews.image = [UIImage imageNamed:@"moneny"];
    }
    return _imageviews;
}
- (UILabel *)deslables
{
    if (!_deslables) {
        _deslables = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 250)/2, 15, 250, 25)];
        if (TYGetUIScreenWidth <= 320) {
            _deslables = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 25)];
            _deslables.font = [UIFont boldSystemFontOfSize:11];

        }else{
            _deslables.font = [UIFont boldSystemFontOfSize:13];

        }
        _deslables.layer.cornerRadius = 12.5;
        _deslables.layer.borderColor = [UIColor whiteColor].CGColor;
        _deslables.layer.borderWidth = 0.5;
        _deslables.layer.masksToBounds = YES;
        _deslables.text = @" 手机记工 数据不丢失 对账有依据 ";
        _deslables.textAlignment = NSTextAlignmentCenter;
        _deslables.textColor = [UIColor whiteColor];
        [_deslables addSubview:self.leftimageview];
        [_deslables addSubview:self.rightimageview];
    }
    return _deslables;
}
- (UIButton *)refrashViews
{
    if (!_refrashViews) {

        _refrashViews = [[UIButton alloc]initWithFrame:CGRectMake(-23,CGRectGetMinY(self.SaveButtons.frame)-30 , CGRectGetWidth(self.SaveButtons.frame),30)];
        _refrashViews.backgroundColor = [UIColor whiteColor];
        [_refrashViews setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [_refrashViews setImage:[UIImage imageNamed:@"箭头-拷贝-7"] forState:UIControlStateSelected];
        [_refrashViews  addTarget:self action:@selector(ClickRefreshButton:) forControlEvents:UIControlEventTouchUpInside];
      
        [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(animation) userInfo:nil repeats:YES];

    }
    return _refrashViews;
}
- (void)ClickRefreshButton:(UIButton *)sender
{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:2];
    
    [self.packTableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  
    
}
- (void)clickSaveButtons:(UIButton *)sender
{

    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSaveDataPackButtonwithModel:)]) {
        [self.delegate clickSaveDataPackButtonwithModel:_yzgGetBillModel];
    }


}
-(UIImageView *)AnimationView
{
    if (!_AnimationView) {
        _AnimationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 15, 12)];
        _AnimationView.center = CGPointMake(TYGetUIScreenWidth/2 -47, CGRectGetMinY(_SaveButtons.frame)-30);

        _AnimationView.image = [UIImage imageNamed:@"arrow"];
        [NSTimer scheduledTimerWithTimeInterval:1.6 target:self selector:@selector(startAniamtionimageWithPack) userInfo:nil repeats:YES];

    }
    return _AnimationView;
}
-(void)startAniamtionimageWithPack
{
    
    [UIView animateWithDuration:0.8 animations:^{
        _AnimationView.transform = CGAffineTransformMakeTranslation(0, 15);
        _AnimationView.alpha = .4;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.8 animations:^{
            _AnimationView.transform = CGAffineTransformMakeTranslation(0, 0);
            _AnimationView.alpha = 1;
        }];
    }];
    
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
    if (_yzgGetBillModel.salary &&_yzgGetBillModel.units) {
      //此处为添加金额整除=====>
        if (_yzgGetBillModel.salary > JGJHundredMillion || _yzgGetBillModel.salary < -JGJHundredMillion) {
        _NumLables.text = [NSString stringWithFormat:@"%.2f亿 包工工钱",_yzgGetBillModel.salary/JGJHundredMillion];
        }else{
           //<=====下面是之前的
        _NumLables.text = [NSString stringWithFormat:@"%.2f 包工工钱",_yzgGetBillModel.salary ];
        }
        [self changeFontwithstr:_NumLables.text withFont:[UIFont systemFontOfSize:20]];

        
    }
    
    if (!_yzgGetBillModel.unitprice || !_yzgGetBillModel.quantities) {
        _NumLables.text  = [NSString stringWithFormat:@"0.00 包工工钱"];
        [self changeFontwithstr:_NumLables.text withFont:[UIFont systemFontOfSize:20]];

    }

    [_packTableview reloadData];
    
   



}
-(void)animationNum
{
    _NumLables.text = [NSString stringWithFormat:@"%u",(arc4random() % 70) + 61 ];
    
    
}


-(void)didendtextfiledfortext:(NSString *)text withTexttag:(NSInteger)tag
{
    
    
    
    if (tag == 0) {
    //分项名称
    _yzgGetBillModel.sub_proname = text;
        
    }else if (tag == 1){
    //单价
    _yzgGetBillModel.unitprice = [text floatValue];
    _NumLables.text  = text;
    _NumLables.text  = [NSString stringWithFormat:@"%.2f 包工工钱",_yzgGetBillModel.quantities *[text intValue]];
    [self changeFontwithstr:_NumLables.text withFont:[UIFont systemFontOfSize:20]];
        
    }else if (tag == 2){
    //数量
    _yzgGetBillModel.quantities = [text floatValue];
    _NumLables.text  = [NSString stringWithFormat:@"%.2f 包工工钱",_yzgGetBillModel.unitprice *[text intValue]];
    [self changeFontwithstr:_NumLables.text withFont:[UIFont systemFontOfSize:20]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(PacketselectUnite)]) {
            [self.delegate PacketselectUnite];
        }
     }
}


-(void)changeFontwithstr:(NSString *)str withFont:(UIFont *)font{
    if (str.length >=4) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Impact" size:10]
                        range:NSMakeRange(str.length-4, 4)];
        _NumLables.attributedText = attrStr;
    }
    //此处显示亿
    if ([str containsString:@"亿"] && str.length >=4) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Impact" size:10]
                        range:NSMakeRange(str.length-4, 4)];
        _NumLables.attributedText = attrStr;
 
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}
-(void)animation
{
    [UIView animateWithDuration:.6 animations:^{
        _refrashViews.imageView.transform = CGAffineTransformMakeTranslation(0, 10);
        dispatch_async(dispatch_get_main_queue(), ^{
            _refrashViews.imageView.alpha = .45;
            
        });
    } completion:^(BOOL finished) {
        _refrashViews.imageView.transform = CGAffineTransformMakeTranslation(0, 0);
        _refrashViews.imageView.alpha = 1;
        
        
        
        
    }];
}

-(UIImageView *)clearImageview
{
    if (!_clearImageview) {
        _clearImageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"touming2"]];
        if (TYGetUIScreenWidth<=320) {
            [_clearImageview setFrame:CGRectMake(0, CGRectGetMaxY(_SaveButtons.frame) - 72, CGRectGetWidth(self.frame)+45, 30)];
            
        }else if (TYGetUIScreenWidth == 375){
            
            [_clearImageview setFrame:CGRectMake(0, CGRectGetMaxY(_SaveButtons.frame) - 72, CGRectGetWidth(self.frame)-32, 30)];
            
        }else{
            [_clearImageview setFrame:CGRectMake(0, CGRectGetMaxY(_SaveButtons.frame) - 72, CGRectGetWidth(self.frame)+45, 30)];
        }
    }
    return _clearImageview;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 10) {
        _AnimationView.hidden = YES;
    }else if(scrollView.contentOffset.y <= 0){
        _AnimationView.hidden = NO;
        
    }
    
    
}
-(UIImageView *)leftimageview
{
    if (!_leftimageview) {
        _leftimageview = [[UIImageView alloc]initWithFrame:CGRectMake(9, 10, 5, 5)];
        _leftimageview.backgroundColor = [UIColor whiteColor];
        _leftimageview.layer.masksToBounds =  YES;
        _leftimageview.layer.cornerRadius = 2.5;
    }
    return _leftimageview;
}

-(UIImageView *)rightimageview
{
    if (!_rightimageview) {
        _rightimageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_deslables.frame) - 14, 10, 5, 5)];
        _rightimageview.backgroundColor = [UIColor whiteColor];
        _rightimageview.layer.masksToBounds =  YES;
        _rightimageview.layer.cornerRadius = 2.5;
    }
    return _rightimageview;
    
}
@end
