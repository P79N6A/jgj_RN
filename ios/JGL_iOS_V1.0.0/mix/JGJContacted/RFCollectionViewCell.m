//
//  RFCollectionViewCell.m
//  RFCircleCollectionView
//
//  Created by Arvin on 15/11/25.
//  Copyright © 2015年 mobi.refine. All rights reserved.
//

#import "RFCollectionViewCell.h"
#import "JGJTimesTableViewCell.h"
#import "NSDate+Extend.h"
#import "UILabel+GNUtil.h"
static int offsetwidth = 0;
static int offsetheight = 0;
#define offset 72
#define headerViewHeight 100

@interface RFCollectionViewCell ()<
UITableViewDelegate,
UITableViewDataSource
>
{
    UIImageView *imageView;
}

@property (nonatomic ,strong)UIImageView *AnimationView;
@property (nonatomic ,strong)UIImageView *clearImageview;
@end
@implementation RFCollectionViewCell
- (void)awakeFromNib
{
//记点工
    [super awakeFromNib];

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
        
    }    [self setFrame:rect];
    [self.contentView setFrame:rect];


    _TimeTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.headerView.frame),CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)- CGRectGetHeight(self.headerView.frame)-45)];
    
    _TimeTableview.backgroundColor = AppFontfafafaColor;
    _TimeTableview.delegate = self;
    _TimeTableview.dataSource = self;
    _TimeTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _TimeTableview.backgroundColor = [UIColor whiteColor];

    [self addSubview:_TimeTableview];
    [self addSubview:self.headerView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headerView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.headerView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.headerView.layer.mask = maskLayer;
    
    [self addSubview:self.SaveButton];
    
    
    UIBezierPath *maskPaths = [UIBezierPath bezierPathWithRoundedRect:self.SaveButton.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayers = [[CAShapeLayer alloc] init];
    maskLayers.frame = self.SaveButton.bounds;
    maskLayers.path = maskPaths.CGPath;
    self.SaveButton.layer.mask = maskLayers;
    [self addSubview:self.AnimationView];
//    [self addSubview:self.clearImageview];
//    [self addSubview:self.topFreshView];
    if (JLGisLeaderBool &&!_CreaterModel) {
    _titleArr = @[@[@"选择工人",@"选择日期"],@[@"工资标准",@"上班时长",@"加班时长"],@[@"所在项目",@"备注"]];
        if (TYGetUIScreenWidth <= 325) {
            _subTitleArr =@[@[@"请选择记账对象",@""],@[@"设置工资/上班时长/加班时长",@"",@""],@[@"例如:万科魅力之城",@"可填写备注信息"]];
        }else{
       
            _subTitleArr =@[@[@"请选择要记账的工人",@""],@[@"设置工资/上班时长/加班时长",@"",@""],@[@"例如:万科魅力之城",@"可填写备注信息"]];
        }
    }else{
        if (TYGetUIScreenWidth <= 325) {
    _titleArr   = @[@[@"班组长/工头",@"选择日期"],@[@"工资标准",@"上班时长",@"加班时长"],@[@"所在项目",@"备注"]];
            _subTitleArr =@[@[@"选择记账对象",@""],@[@"设置工资/上班时长/加班时长",@"",@""],@[@"例如:万科魅力之城",@"可填写备注信息"]];
        }else{
    _titleArr   = @[@[@"班组长/工头",@"选择日期"],@[@"工资标准",@"上班时长",@"加班时长"],@[@"所在项目",@"备注"]];
            _subTitleArr =@[@[@"选择要记账的班组长/工头",@""],@[@"设置工资/上班时长/加班时长",@"",@""],@[@"例如:万科魅力之城",@"可填写备注信息"]];
        }
    }
    _imageArr = @[@[@"wage",@"The-date-of"],@[@"The-contact",@"time",@"time"],@[@"projects",@"note"]];
    
    //点击取消键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickColeection)];
    tap.cancelsTouchesInView = NO;
    [_TimeTableview addGestureRecognizer:tap];
        UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickColeections)];
    self.headerView.userInteractionEnabled = YES;
    [self.headerView addGestureRecognizer:taps];
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
        case 2:
            return 2;
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

    JGJTimesTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJTimesTableViewCell" owner:nil options:nil]firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLable.text = _titleArr[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        if (![NSString isEmpty: _yzgGetBillModel.name ]) {
            cell.upDepartlable.backgroundColor = [UIColor clearColor];
            cell.subTitleLable.text = _yzgGetBillModel.name;
            cell.BigBool = YES;
            cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
            cell.subTitleLable.textColor = AppFont333333Color;
        }else if(TYGetUIScreenWidth >=320){
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
        //判断是不是从聊天记账进入
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
    }
   else if (indexPath.section == 1 &&indexPath.row == 0) {
       cell.subTitleLable.numberOfLines = 0;
    if (_yzgGetBillModel.set_tpl) {
       cell.subTitleLable.textColor = AppFont333333Color;
        if (_yzgGetBillModel.set_tpl.s_tpl <=0) {
        if (_yzgGetBillModel.set_tpl.o_h_tpl<=0&&_yzgGetBillModel.set_tpl.o_h_tpl<=0) {
        cell.subTitleLable.textColor = AppFontbdbdc3Color;
        cell.subTitleLable.text = [NSString stringWithFormat:@"%@\n%@",@"这里设置",@"工资/上班时长/加班时长"];
        }else{
            
        cell.subTitleLable.text = [NSString stringWithFormat:@"%.0f小时(上班)/%.0f小时(加班)", _yzgGetBillModel.set_tpl.w_h_tpl,_yzgGetBillModel.set_tpl.o_h_tpl];
        cell.BigBool = YES;
        cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];

            }
        }else{
        cell.subTitleLable.text = [NSString stringWithFormat:@"%.2f元\n%.0f小时(上班)/%.0f小时(加班)",_yzgGetBillModel.set_tpl.s_tpl, _yzgGetBillModel.set_tpl.w_h_tpl,_yzgGetBillModel.set_tpl.o_h_tpl];
        cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
        cell.BigBool = YES;
        }
       }else{
        cell.subTitleLable.text = [NSString stringWithFormat:@"%@\n%@",@"这里设置",@"工资/上班时长/加班时长"];
           cell.BigBool = NO;

       }
    }else if (indexPath.section == 0 &&indexPath.row == 1 ){
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
   }else if (indexPath.section == 1 &&indexPath.row == 1 && _yzgGetBillModel.manhour >=0){
       
       if (_yzgGetBillModel.manhour == 0 && _yzgGetBillModel.set_tpl) {
           //上班是长为0
           if (_yzgGetBillModel.set_tpl.w_h_tpl > 0 && _yzgGetBillModel.manhour == 0) {
           cell.subTitleLable.text = @"休息";
           cell.BigBool = YES;
           cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
           cell.subTitleLable.textColor = AppFontEB4E4EColor;
           }else{
               cell.subTitleLable.text = @"";
           }
       }else{
    if (_yzgGetBillModel.manhour >0) {
        if (_yzgGetBillModel.manhour != (int)_yzgGetBillModel.manhour) {
            cell.subTitleLable.text = [NSString stringWithFormat:@"%.1f小时",_yzgGetBillModel.manhour];
        }else{
            cell.subTitleLable.text = [NSString stringWithFormat:@"%.0f小时",_yzgGetBillModel.manhour];
            }
               cell.BigBool = YES;
               cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
               cell.subTitleLable.textColor = AppFontEB4E4EColor;
        //设置一个工半个工
        if (_yzgGetBillModel.manhour *2 == _yzgGetBillModel.set_tpl.w_h_tpl) {
            if (_yzgGetBillModel.manhour == (int)_yzgGetBillModel.manhour) {
            cell.subTitleLable.text = [NSString stringWithFormat:@"%.0f小时(0.5个工)",_yzgGetBillModel.manhour];
            }else{
            cell.subTitleLable.text = [NSString stringWithFormat:@"%.1f小时(0.5个工)",_yzgGetBillModel.manhour];
            }
        }
        
    if (_yzgGetBillModel.manhour  == _yzgGetBillModel.set_tpl.w_h_tpl) {
        if (_yzgGetBillModel.manhour == (int)_yzgGetBillModel.manhour) {

            cell.subTitleLable.text = [NSString stringWithFormat:@"%.0f小时(1个工)",_yzgGetBillModel.manhour];
        }else{
            cell.subTitleLable.text = [NSString stringWithFormat:@"%.1f小时(1个工)",_yzgGetBillModel.manhour];

        }
    }
        }else{
        cell.BigBool = NO;
        cell.subTitleLable.text = @"";
        cell.subTitleLable.textColor = AppFont999999Color;
           }
       }
   }else if (indexPath.section == 1 &&indexPath.row == 2 ){
       if (_yzgGetBillModel.overtime >0) {
       cell.BigBool = YES;
       cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
       cell.subTitleLable.textColor = AppFontEB4E4EColor;
           if (_yzgGetBillModel.overtime == (int)_yzgGetBillModel.overtime) {
    cell.subTitleLable.text = [NSString stringWithFormat:@"%.0f小时",_yzgGetBillModel.overtime];

           }else{
               
        cell.subTitleLable.text = [NSString stringWithFormat:@"%.1f小时",_yzgGetBillModel.overtime];
               
        }
           
           
           if (_yzgGetBillModel.overtime *2 == _yzgGetBillModel.set_tpl.o_h_tpl) {
               if (_yzgGetBillModel.overtime == (int)_yzgGetBillModel.overtime) {
                cell.subTitleLable.text = [NSString stringWithFormat:@"%.0f小时(0.5个工)",_yzgGetBillModel.overtime];

               }else{
               cell.subTitleLable.text = [NSString stringWithFormat:@"%.1f小时(0.5个工)",_yzgGetBillModel.overtime];
               }
           }
           
           if (_yzgGetBillModel.overtime  == _yzgGetBillModel.set_tpl.o_h_tpl) {
               if (_yzgGetBillModel.overtime == (int)_yzgGetBillModel.overtime) {

               cell.subTitleLable.text = [NSString stringWithFormat:@"%.0f小时(1个工)",_yzgGetBillModel.overtime];
               }else{
                cell.subTitleLable.text = [NSString stringWithFormat:@"%.1f小时(1个工)",_yzgGetBillModel.overtime];

               }
           }

           
       }else{
           if (_yzgGetBillModel.set_tpl &&_yzgGetBillModel.overtime == 0) {
               if (_yzgGetBillModel.set_tpl.w_h_tpl > 0) {
                   cell.BigBool = YES;
                   cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];                   cell.subTitleLable.textColor = AppFontEB4E4EColor;
                   cell.subTitleLable.text = @"无加班";

               }else{
                   cell.subTitleLable.text = @"";

               }
                 }else{
        cell.subTitleLable.text = @"";
           }
       }
   }else if (indexPath.section == 2 &&indexPath.row == 0 &&_yzgGetBillModel.proname){
       
       if (_morePeople) {
           
        cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
        cell.subTitleLable.textColor = AppFont999999Color;
           cell.subTitleLable.text =_yzgGetBillModel.proname?:_yzgGetBillModel.all_pro_name;
        cell.BigBool = YES;
        cell.userInteractionEnabled = NO;

       }else{
           if ([_yzgGetBillModel.proname length] &&_yzgGetBillModel.pid) {
               cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
               cell.subTitleLable.textColor = AppFont333333Color;
               
               cell.subTitleLable.text = _yzgGetBillModel.proname;
               cell.BigBool = YES;

           }else{
            
               cell.subTitleLable.textColor = AppFontccccccColor;
               cell.subTitleLable.text = @"例如:万科魅力之城";
               cell.BigBool = NO;
               if (_CreaterModel) {
                   cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
                   cell.subTitleLable.textColor = AppFont333333Color;
                   
                   cell.subTitleLable.text = _yzgGetBillModel.proname;
                   cell.BigBool = YES;
               }
           }
             }
   }else if (indexPath.section == 2 &&indexPath.row == 1 &&_yzgGetBillModel.notes_txt){
       if (_yzgGetBillModel.notes_txt.length > 0) {
           cell.leftLogo.image = [UIImage imageNamed:_imageArr[indexPath.section][indexPath.row]];
           cell.subTitleLable.textColor = AppFont333333Color;
           
           cell.subTitleLable.text = _yzgGetBillModel.notes_txt;
           cell.BigBool = YES;
           cell.subTitleLable.numberOfLines = 2;

       }else{
        cell.subTitleLable.text = @"可填写备注信息";
        cell.BigBool = NO;
        cell.subTitleLable.textColor = AppFontbdbdc3Color;
       }
   }
    else{
    cell.subTitleLable.text = _subTitleArr[indexPath.section][indexPath.row];
    }

//    if (_yzgGetBillModel.set_tpl && (indexPath.section !=1&&indexPath.row != 0)) {
//        cell.subTitleLable.textColor = AppFont333333Color;
//        cell.subTitleLable.numberOfLines = 1;
//    }
    if (indexPath.section == 0 &&indexPath.row == 0) {
        cell.upDepartlable.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.bottomLable.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame)+offsetwidth, 10)];
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
    return 0;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.delegate &&[self.delegate respondsToSelector:@selector(didselectedTableviewforIndexpath:withTableviewclass:)]) {
        [self.delegate didselectedTableviewforIndexpath:indexPath withTableviewclass:NSStringFromClass([_TimeTableview class])];
    }

}
- (UIImageView *)headerView
{
    if (!_headerView) {

        _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), headerViewHeight)];

        _headerView.image = [UIImage imageNamed:@"background"];
        [_headerView addSubview:self.NumLable];
//        [_headerView addSubview:self.imageview];
        [_headerView addSubview:self.deslable];

    }
    
    return _headerView;
}

- (UILabel *)NumLable
{
    if (!_NumLable) {
        
        _NumLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, CGRectGetWidth(self.frame) - 20, 35)];
//        _NumLable.center = CGPointMake(CGRectGetMidX(self.frame) , 30);
        _NumLable.text = @"0.00 点工工钱";
        
        _NumLable.textAlignment = NSTextAlignmentCenter;
        _NumLable.font = [UIFont boldSystemFontOfSize:20];

        _NumLable.textColor = [UIColor whiteColor];

//        _NumLable.textColor = AppFontfafafaColor;
//        [self changeFontwithstr:_NumLable.text withFont:[UIFont systemFontOfSize:30]];
    }
    return _NumLable;
}
- (UIButton *)SaveButton
{
    if (!_SaveButton) {
        _SaveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-42.5 , CGRectGetWidth(self.frame), 42.5)];
        [_SaveButton setTitle:@"保存" forState:UIControlStateNormal];
        _SaveButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
        _SaveButton.backgroundColor = AppFontEB4E4EColor;
        [_SaveButton setTitleColor:AppFontfafafaColor forState:UIControlStateNormal];
        [_SaveButton addTarget:self action:@selector(clickSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _SaveButton;
}
- (UIImageView *)imageview
{
    if (!_imageview) {

        _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.headerView.frame) - 38 , CGRectGetMaxY(self.NumLable.frame)+5, 20, 20)];

        _imageview.image = [UIImage imageNamed:@"moneny"];
    }

    return _imageview;
}
- (UILabel *)deslable
{
    if (!_deslable) {
        

        _deslable = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - 250)/2, 15, 250, 25)];
        if (TYGetUIScreenWidth <= 320) {
        _deslable = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 25)];
        _deslable.font = [UIFont boldSystemFontOfSize:11];
        }else{
        _deslable.font = [UIFont boldSystemFontOfSize:13];

        }
        _deslable.layer.cornerRadius = 12.5;
        _deslable.layer.borderColor = [UIColor whiteColor].CGColor;
        _deslable.layer.borderWidth = 0.5;
        _deslable.layer.masksToBounds = YES;
        _deslable.text = @" 手机记工 数据不丢失 对账有依据 ";
        _deslable.textAlignment = NSTextAlignmentCenter;
        _deslable.textColor = [UIColor whiteColor];
        [_deslable addSubview:self.leftimageview];
        [_deslable addSubview:self.rightimageview];
    }
    return _deslable;
}
- (UIView *)refrashView
{
    if (!_refrashView) {

        _refrashView = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-30 , CGRectGetWidth(self.frame),30)];

        _refrashView.backgroundColor = [UIColor whiteColor];
        [_refrashView setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [_refrashView setImage:[UIImage imageNamed:@"箭头-拷贝-7"] forState:UIControlStateSelected];

        [_refrashView  addTarget:self action:@selector(ClickRefreshButton:) forControlEvents:UIControlEventTouchUpInside];
        [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(animation) userInfo:nil repeats:YES];
      
    }

    return _refrashView;
}
-(UIView *)topFreshView
{
    if (!_topFreshView) {
        _topFreshView = [UIView new];
        [_topFreshView setFrame:CGRectMake(0, CGRectGetMinY(_SaveButton.frame) - 30, CGRectGetWidth(_TimeTableview.frame), 30)];
       imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 10)];
        imageView.image = [UIImage imageNamed:@"arrow"];
        _topFreshView.backgroundColor = [UIColor whiteColor];
     
        [NSTimer scheduledTimerWithTimeInterval:1.6 target:self selector:@selector(startAniamtionimage) userInfo:nil repeats:YES];
        imageView.center = CGPointMake(CGRectGetMidX(_topFreshView.frame), 15);
        [_topFreshView addSubview:imageView];
        
    }
    return _topFreshView;
}
-(void)startAniamtionimage
{

    [UIView animateWithDuration:.8 animations:^{
    imageView.transform = CGAffineTransformMakeTranslation(0, 15);
        imageView.alpha = .4;

    } completion:^(BOOL finished) {
    [UIView animateWithDuration:.8 animations:^{
    imageView.transform = CGAffineTransformMakeTranslation(0, 0);
        imageView.alpha = 1;
        }];
    }];
}

- (void)ClickRefreshButton:(UIButton *)sender
{
 NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:2];
    
[self.TimeTableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void)clickSaveButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSaveDataTimeButtonwithModel:)]) {
        [self.delegate clickSaveDataTimeButtonwithModel:_yzgGetBillModel];
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
    if (yzgGetBillModel.salary<=0) {
        if (yzgGetBillModel.set_tpl) {
        if (yzgGetBillModel.set_tpl.s_tpl <= 0) {
           self.NumLable.text   = [NSString stringWithFormat:@"%.2f 点工工钱",0.00];
            [self changeFontwithstr:_NumLable.text withFont:[UIFont systemFontOfSize:20]];
        }
        }else{
            _NumLable.text   = [NSString stringWithFormat:@"%.2f 点工工钱",0.00];
            [self changeFontwithstr:_NumLable.text withFont:[UIFont systemFontOfSize:20]];
        }
    }
    if (!yzgGetBillModel.date) {
    yzgGetBillModel.date = [self getWeekDaysString:[NSDate date]];
    }
    _yzgGetBillModel = [YZGGetBillModel new];
    _yzgGetBillModel = yzgGetBillModel;
    [_TimeTableview reloadData];
    [self changeFontwithstr:_NumLable.text withFont:[UIFont systemFontOfSize:20]];

    if (yzgGetBillModel.salary >0 ) {
//  NSTimer *time =  [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(animationNum) userInfo:nil repeats:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [time invalidate];
        _NumLable.text   = [NSString stringWithFormat:@"%.2f 点工工钱",yzgGetBillModel.salary];
        [self changeFontwithstr:_NumLable.text withFont:[UIFont systemFontOfSize:20]];
//    });
    }else if (yzgGetBillModel.salary <=0 &&yzgGetBillModel.set_tpl){
        if (yzgGetBillModel.set_tpl.s_tpl >0) {
//        NSTimer *time =  [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(animationNum) userInfo:nil repeats:YES];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [time invalidate];
            _NumLable.text   = [NSString stringWithFormat:@"%.2f 点工工钱",0.00];
            [self changeFontwithstr:_NumLable.text withFont:[UIFont systemFontOfSize:20]];
//        });
        }
    }
    
}
-(void)animationNum
{
_NumLable.text = [NSString stringWithFormat:@"%u",(arc4random() % 70) + 61 ];


}
-(void)changeFontwithstr:(NSString *)str withFont:(UIFont *)font{

    if (str.length >= 4) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Impact" size:10]
                        range:NSMakeRange(str.length-4, 4)];
        _NumLable.attributedText = attrStr;
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 10) {
        _AnimationView.hidden = YES;
    }else if(scrollView.contentOffset.y <= 0){
        _AnimationView.hidden = NO;

    }

    
}
-(UIImageView *)AnimationView
{
    if (!_AnimationView) {
        _AnimationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 15, 12)];
        if (TYGetUIScreenWidth<=320) {
        _AnimationView.center = CGPointMake(TYGetUIScreenWidth/2-40, CGRectGetMinY(_SaveButton.frame)-23);
        }else if (TYGetUIScreenWidth == 375){
            
        _AnimationView.center = CGPointMake(TYGetUIScreenWidth/2-42, CGRectGetMinY(_SaveButton.frame)-30);
        }else{
        _AnimationView.center = CGPointMake(TYGetUIScreenWidth/2-50, CGRectGetMinY(_SaveButton.frame)-30);
        }
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
-(UIImageView *)clearImageview
{
    if (!_clearImageview) {
        _clearImageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"touming2"]];
        if (TYGetUIScreenWidth<=320) {
            [_clearImageview setFrame:CGRectMake(0, CGRectGetMaxY(_SaveButton.frame) - 72, CGRectGetWidth(self.frame)+45, 30)];

        }else if (TYGetUIScreenWidth == 375){
        
            [_clearImageview setFrame:CGRectMake(0, CGRectGetMaxY(_SaveButton.frame) - 72, CGRectGetWidth(self.frame)+32, 30)];

        }else{
            [_clearImageview setFrame:CGRectMake(0, CGRectGetMaxY(_SaveButton.frame) - 72, CGRectGetWidth(self.frame)+45, 30)];

        }
    
//        _clearImageview.backgroundColor = [UIColor grayColor];
    }
    return _clearImageview;
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
        _rightimageview = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_deslable.frame) - 14, 10, 5, 5)];
        _rightimageview.backgroundColor = [UIColor whiteColor];
        _rightimageview.layer.masksToBounds =  YES;
        _rightimageview.layer.cornerRadius = 2.5;
    }
    return _rightimageview;

}
@end
