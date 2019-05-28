//
//  JGJServicePeopleNumTableViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/7/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJServicePeopleNumTableViewCell.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"
#import "UILabel+JGJCopyLable.h"
@implementation JGJServicePeopleNumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _baseView.layer.masksToBounds = YES;
    _baseView.layer.cornerRadius = 2;
    _baseView.layer.borderColor = AppFontdbdbdbColor.CGColor;
    _baseView.layer.borderWidth = .7;
    if (self.tag == 10) {
    _textFiled.text = @"10";
    }else{
    _textFiled.text = @"1";
    }
    _textFiled.delegate = self;
    [_textFiled addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (_goodsType == VIPType) {//选择人数
        if ([_textFiled.text intValue] <= _alreadyHaveeople || [_textFiled.text intValue]  >= 500) {
            if ([_textFiled.text intValue] <= _alreadyHaveeople ) {
                _subButton.userInteractionEnabled = NO;
                [_subButton setImage:[UIImage imageNamed:@"payUnEnable"] forState:UIControlStateNormal];
  
            }else if ([_textFiled.text intValue]  >= 500)
            {
                _addButton.userInteractionEnabled = NO;
                [_addButton setImage:[UIImage imageNamed:@"logtypeAdd"] forState:UIControlStateNormal];

            
            }
            if ([_textFiled.text intValue] <= _alreadyHaveeople) {
                _textFiled.text = [NSString stringWithFormat:@"%ld",_alreadyHaveeople];
                
            }else if ([_textFiled.text intValue]  >= 500)
            {
                
                _textFiled.text = @"500";
                
            }
            //        return;
        }else{
            _subButton.userInteractionEnabled = YES;
            [_subButton setImage:[UIImage imageNamed:@"payEnable"] forState:UIControlStateNormal];
            _addButton.userInteractionEnabled = YES;
            [_addButton setImage:[UIImage imageNamed:@"矩形-23-拷贝-3"] forState:UIControlStateNormal];
            
        }
    }else if(_goodsType == CloudType){//选择云盘空间
        if ( [_textFiled.text intValue]  <= _alreadyHaveCloud || [_textFiled.text intValue] >= 1000 ) {
            if ([_textFiled.text intValue]  <= _alreadyHaveCloud) {
                _subButton.userInteractionEnabled = NO;
                [_subButton setImage:[UIImage imageNamed:@"payUnEnable"] forState:UIControlStateNormal];
   
            }else if ([_textFiled.text intValue] >= 1000){
                _addButton.userInteractionEnabled = NO;
                [_addButton setImage:[UIImage imageNamed:@"logtypeAdd"] forState:UIControlStateNormal];
            }
        }else{
            _subButton.userInteractionEnabled = YES;
            [_subButton setImage:[UIImage imageNamed:@"payEnable"] forState:UIControlStateNormal];
            _addButton.userInteractionEnabled = YES;
            [_addButton setImage:[UIImage imageNamed:@"矩形-23-拷贝-3"] forState:UIControlStateNormal];
            
            
        }
    }
    if ([_textFiled.text intValue] > 500 && _goodsType == VIPType) {
        _textFiled.text = @"500";
        _desLable.text = [NSString stringWithFormat:@"赠送云盘空间: %d G", [_textFiled.text intValue]*2];
    }
    
#pragma mark -输入计算机金额
    [self.delegate selectGoodNum:_textFiled.text andtype:self.tag == 10 ?CloudType:VIPType];

    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_goodsType == CloudType) {
        _textFiled.userInteractionEnabled = NO;
        return NO;
    }else{
        textField.userInteractionEnabled = YES;
    }
    return YES;
}
-(void)setPeopleNum:(NSInteger)peopleNum
{
    _textFiled.text = [NSString stringWithFormat:@"%ld",(long)_peopleNum]?:@"0";

}
-(void)textDidChange:(UITextField *)textfiled
{

    if (_goodsType == VIPType) {
        if ([_textFiled.text intValue] > _alreadyHaveeople) {
            _subButton.userInteractionEnabled = YES;
            [_subButton setImage:[UIImage imageNamed:@"payEnable"] forState:UIControlStateNormal];

        }
        if ([_textFiled.text intValue] < 500) {
            _addButton.userInteractionEnabled = YES;
            [_addButton setImage:[UIImage imageNamed:@"矩形-23-拷贝-3"] forState:UIControlStateNormal];
        }
        _desLable.text = [NSString stringWithFormat:@"赠送云盘空间: %d G", [_textFiled.text intValue]*2];
    }
    
    if ([_textFiled.text intValue] > 500 && _goodsType == VIPType) {
    _textFiled.text = @"500";
    _desLable.text = [NSString stringWithFormat:@"赠送云盘空间: %d G", [_textFiled.text intValue]*2];
    }
    
    if ([_textFiled.text intValue] > 1000 && _goodsType == CloudType) {
        _textFiled.text = [NSString stringWithFormat:@"%d",1000 ];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if (textField.text.length >2 && ![NSString isEmpty:string] && _goodsType == VIPType) {
        return NO;
    }
    if (textField.text.length >3 && ![NSString isEmpty:string] && _goodsType == CloudType) {
        return NO;
    }
    return YES;
}
-(void)setButtonState
{
    if (_goodsType == VIPType) {
        if ([_textFiled.text intValue] <= _alreadyHaveeople) {
            _subButton.userInteractionEnabled = NO;
            [_subButton setImage:[UIImage imageNamed:@"payUnEnable"] forState:UIControlStateNormal];
            return;
        }else{
            _subButton.userInteractionEnabled = YES;
            [_subButton setImage:[UIImage imageNamed:@"payEnable"] forState:UIControlStateNormal];
            
        }
        
        if ([_textFiled.text intValue] >=  500) {
            _addButton.userInteractionEnabled = NO;
            [_addButton setImage:[UIImage imageNamed:@"logtypeAdd"] forState:UIControlStateNormal];
        }else{
            _addButton.userInteractionEnabled = YES;
            [_addButton setImage:[UIImage imageNamed:@"矩形-23-拷贝-3"] forState:UIControlStateNormal];
        }
        
        
    }else if(_goodsType == CloudType){
        if ( [_textFiled.text intValue]  <= _alreadyHaveCloud) {
            _subButton.userInteractionEnabled = NO;
            [_subButton setImage:[UIImage imageNamed:@"payUnEnable"] forState:UIControlStateNormal];
            return;
        }else{
            _subButton.userInteractionEnabled = YES;
            [_subButton setImage:[UIImage imageNamed:@"payEnable"] forState:UIControlStateNormal];
            
        }
    }

}
- (IBAction)selectNum:(id)sender {
    UIButton *button = (UIButton *)sender;
    if ([_textFiled.text intValue] +button.tag < 0 ) {
        [_subButton setImage:[UIImage imageNamed:@"payUnEnable"] forState:UIControlStateNormal];
        return;
    }
    if (_goodsType == VIPType) {//选择人数
        if ([_textFiled.text intValue] + button.tag <= _alreadyHaveeople || [_textFiled.text intValue] + button.tag >= 500) {
        if ([_textFiled.text intValue] + button.tag <= _alreadyHaveeople  && button.tag < 0) {
            _subButton.userInteractionEnabled = NO;
            [_subButton setImage:[UIImage imageNamed:@"payUnEnable"] forState:UIControlStateNormal];
        }
            
            if ([_textFiled.text intValue] + button.tag >= 500 && button.tag > 0)
        {
            _addButton.userInteractionEnabled = NO;
            [_addButton setImage:[UIImage imageNamed:@"logtypeAdd"] forState:UIControlStateNormal];
        }
//        return;
        }else{
        _subButton.userInteractionEnabled = YES;
        [_subButton setImage:[UIImage imageNamed:@"payEnable"] forState:UIControlStateNormal];
        _addButton.userInteractionEnabled = YES;
        [_addButton setImage:[UIImage imageNamed:@"矩形-23-拷贝-3"] forState:UIControlStateNormal];
        }
#pragma mark - 高级服务版点一次要记算一次云盘的默认值和最小值
        [self calculateCloudMaxAndMin];
        
        
    }else if(_goodsType == CloudType){//选择云盘空间

        if ( [_textFiled.text intValue] + button.tag <= _alreadyHaveCloud || [_textFiled.text intValue] + button.tag >= 1000 ) {
            
            if ( [_textFiled.text intValue] + button.tag <= _alreadyHaveCloud  && button.tag < 0) {
                _subButton.userInteractionEnabled = NO;
                [_subButton setImage:[UIImage imageNamed:@"payUnEnable"] forState:UIControlStateNormal];
                
            }
            if ([_textFiled.text intValue] + button.tag >= 1000  && button.tag >0)
            {
                _addButton.userInteractionEnabled = NO;
                [_addButton setImage:[UIImage imageNamed:@"logtypeAdd"] forState:UIControlStateNormal];
            }
        }else{
            _subButton.userInteractionEnabled = YES;
            [_subButton setImage:[UIImage imageNamed:@"payEnable"] forState:UIControlStateNormal];
            _addButton.userInteractionEnabled = YES;
            [_addButton setImage:[UIImage imageNamed:@"矩形-23-拷贝-3"] forState:UIControlStateNormal];
        }
    }
       //小余10的云盘数量
//    if ([_textFiled.text intValue]  > 10 && [_textFiled.text intValue] + button.tag < 20 && button.tag == -10) {

    if (([_textFiled.text intValue] + button.tag < _alreadyHaveCloud || [_textFiled.text intValue] + button.tag <10 )&& button.tag == -10) {
        _textFiled.text = [NSString stringWithFormat:@"%ld", _alreadyHaveCloud ];
        _subButton.userInteractionEnabled = NO;
        [_subButton setImage:[UIImage imageNamed:@"payUnEnable"] forState:UIControlStateNormal];
    }else{
    _textFiled.text = [NSString stringWithFormat:@"%ld",[_textFiled.text intValue] + button.tag];
    }
    if (_goodsType == VIPType) {
        _desLable.text = [NSString stringWithFormat:@"赠送云盘空间: %d G", [_textFiled.text intValue]*2];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectGoodNum:andtype:)]) {
        if ([NSString isEmpty:_textFiled.text]) {
            [self.delegate selectGoodNum:[NSString stringWithFormat:@"%ld",(long)_peopleNum]?:@"0" andtype:self.tag == 10 ?CloudType:VIPType];
        }else{
        [self.delegate selectGoodNum:_textFiled.text andtype:self.tag == 10 ?CloudType:VIPType];
        }
    }
}
-(void)setGoodsType:(JGJGoodsType)goodsType
{
    if (self.tag == 10) {
        _textFiled.text = @"0";
    }
    _goodsType = goodsType;
    if (goodsType == CloudType) {
        _addButton.tag = 10;
        _subButton.tag = -10;
        _peopleNumLable.text = @"云盘空间(不包括赠送空间)";
        _topconstance.constant = 24;
        _unitesConstace.constant =  30;
        _titlelableTopconstance.constant = 12;
        NSString *detailDesStr;
        NSMutableAttributedString *attrStr;
        NSString *priceStr = @"(￥25.00/10G*3个月)   ";
        
        NSString *desStr = @"(不包括赠送空间)   ";
        UIFont *font;
        UIFont *priceFont;

        if (TYGetUIScreenWidth <= 320) {
            font = [UIFont systemFontOfSize:13];
            priceFont = [UIFont systemFontOfSize:13];

        }else{
            font = [UIFont systemFontOfSize:15];
            priceFont = [UIFont systemFontOfSize:16];
        }
        _peopleNumLable.text = detailDesStr;
        
        if (!_BuyCloud) {
            detailDesStr = @"云盘空间\n(￥25.00/10G*3个月)\n(不包括赠送空间)";
            attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"云盘空间\n%@\n%@",priceStr,desStr]];
            [attrStr addAttribute:NSFontAttributeName
                            value:priceFont
                            range:NSMakeRange(4, [priceStr length]+1)];
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:AppFontEB4E4EColor
                            range:NSMakeRange(4, [priceStr length]+1)];
            [attrStr addAttribute:NSFontAttributeName
                            value:font
                            range:NSMakeRange(5 + priceStr.length, desStr.length+1)];
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:AppFont999999Color
                            range:NSMakeRange(5 + priceStr.length, desStr.length+1)];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:3];
            [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(4, [priceStr length]+1)];
            
            NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyles setLineSpacing:3];
            [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyles range:NSMakeRange(0, 4)];
            
        }else{
            detailDesStr = @"云盘空间\n(不包括赠送空间) ";
            attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"云盘空间\n%@",desStr]];
            
            [attrStr addAttribute:NSFontAttributeName
                            value:font
                            range:NSMakeRange(4 , desStr.length+1)];
            [attrStr addAttribute:NSForegroundColorAttributeName
                            value:AppFont999999Color
                            range:NSMakeRange(4 , desStr.length+1)];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:3];
            [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, 4)];
            
            _titlelableTopconstance.constant = 22;

            
        }
        
        


        _peopleNumLable.attributedText = attrStr;

        _desLable.hidden = YES;
        _numLable.text = @"G";
    }else{
        
    }
}

/*高级服务版
 
 服务人数
 BP：代表项目已购人数
 UP：代表项目已有人数
 注  服务人数为选择的人数
 % 最小值 = 项目已有人数；如果 服务人数 = 最小值，则 减号按钮为禁用状态
 % 最大值 = 500；如果 服务人数 = 最大值，则 加号按钮为禁用状态
 
 % 默认值：
 如果 项目已购人数 = 0，则 默认值 = 项目已有人数；
 如果 项目已购人数 ！= 0 ，则 默认值 = 项目已购人数；
 
 高级版购买云盘
 % 最小值：
 如果 项目已用云盘空间 - 服务人数 * 2 < 0，则 最小值 = 0
 如果 项目已用云盘空间 - 服务人数 * 2 >= 0 ，则最小值 = （项目已用云盘空间 - 服务人数 * 2）向上取能被10整除的值
 如果 云盘空间 = 最小值，则减号按钮为禁用状态
 
 % 最大值 = 默认值 + 1000G
 如果 云盘空间 = 最大值，则加号按钮为禁用状态
 
 % 默认值：
 如果 已购云盘空间 < 最小值，则 默认值 = 最小值
 如果 已购云盘空间 > 最小值，则 默认值 = BS
 */

/*只购买云盘
 % 默认值
 
 % 最小值：
 如果 已用云盘空间 - 已购服务人数 * 2 < 0，则 最小值 = 0
 如果 已用云盘空间 - 已购服务人数 * 2 >= 0 ，则最小值 = （已用云盘空间 - 服务人数 * 2）向上取能被10整除的值
 如果 云盘空间 = 最小值，则减号按钮为禁用状态
 
 % [2017-08-28 修改需求] 最大值 = 1000G
 如果 云盘空间 = 最大值，则加号按钮为禁用状态
 
 % 默认值：
 如果 已购云盘空间 < 最小值，则 默认值 = 最小值
 如果 已购云盘空间 > 最小值，则 默认值 = 已购云盘空间 */
-(void)setOrderListModel:(JGJOrderListModel *)orderListModel
{
    _orderListModel = orderListModel;
    //最小值
    _alreadyHaveeople =  [_orderListModel.members_num intValue];
    
//测试
    if (_BuyCloud) {//只购云盘
    if ([_orderListModel.used_space longLongValue]/1024/1024/1024 - [_orderListModel.buyer_person?:@"0" intValue] * 2 < 0 ) {
        _alreadyHaveCloud = 0;
    }else if ([_orderListModel.used_space longLongValue]/1024/1024/1024 - [_orderListModel.buyer_person intValue] *2 >=0){
        _alreadyHaveCloud = ((int)(([_orderListModel.used_space doubleValue]/1024/1024/1024 -[_orderListModel.buyer_person?:@"0" intValue]*2)/10) +1 ) *10;
    }else{
        _alreadyHaveCloud = 0;
    }
        if ([_orderListModel.cloud_space?:@"0" longLongValue] < _alreadyHaveCloud) {
            _VIPCloundDefult = _alreadyHaveCloud;
        }else if ([_orderListModel.cloud_space?:@"0" longLongValue] >= _alreadyHaveCloud)
        {
            _VIPCloundDefult = [_orderListModel.cloud_space longLongValue];
        }
    }else{
    //高级版计算默认值等
    if ([_orderListModel.used_space longLongValue]/1024/1024/1024 - [_orderListModel.add_people?:@"0" intValue]*2 < 0 ) {
        _alreadyHaveCloud = 0;
    }else if ([_orderListModel.used_space longLongValue]/1024/1024/1024 - [_orderListModel.add_people intValue] *2 >=0){
        _alreadyHaveCloud = ((int)(([_orderListModel.used_space doubleValue]/1024/1024/1024 -[_orderListModel.add_people?:@"0" intValue]*2)/10) +1 ) *10;
    }else{
        _alreadyHaveCloud = 0;

    }
        if ([_orderListModel.cloud_space?:@"0" longLongValue] < _alreadyHaveCloud) {
            _VIPCloundDefult = _alreadyHaveCloud;
        }else if ([_orderListModel.cloud_space?:@"0" longLongValue] >= _alreadyHaveCloud)
        {
            _VIPCloundDefult = [_orderListModel.cloud_space longLongValue];
        }
        
    }
    
     if (_goodsType == CloudType) {
        //云盘空间

         if (_VIPCloundDefult >= 1000) {
             _VIPCloundDefult = 1000;
             _addButton.userInteractionEnabled = NO;
             [_addButton setImage:[UIImage imageNamed:@"logtypeAdd"] forState:UIControlStateNormal];

         }else{
             _addButton.userInteractionEnabled = YES;
             [_addButton setImage:[UIImage imageNamed:@"矩形-23-拷贝-3"] forState:UIControlStateNormal];
         }
          _textFiled.text = [NSString stringWithFormat:@"%ld",_VIPCloundDefult];
    }else{
        if ([NSString isEmpty:orderListModel.buyer_person]) {
        _textFiled.text = orderListModel.members_num;
        }else{
            if ([orderListModel.buyer_person isEqualToString:@"0"]) {
        _textFiled.text = orderListModel.members_num;
    
            }else{
        _textFiled.text = orderListModel.buyer_person;
            }
        }
    }
    [self setButtonState];
    
#pragma mark - 设置所选的默认值
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectGoodNum:andtype:)]) {
        if ([NSString isEmpty:_textFiled.text]) {
            [self.delegate selectGoodNum:[NSString stringWithFormat:@"%ld",(long)_peopleNum]?:@"0" andtype:self.tag == 10 ?CloudType:VIPType];
        }else{
            [self.delegate selectGoodNum:_textFiled.text andtype:self.tag == 10 ?CloudType:VIPType];
        }
    }
    if (_goodsType == VIPType) {
        _desLable.text = [NSString stringWithFormat:@"赠送云盘空间: %d G", [_textFiled.text intValue]*2];
   
    }


}



-(void)setProDetail:(JGJMyRelationshipProModel *)proDetail
{
 if (_goodsType == CloudType) {
     //暂时还没有添加字段 此处应该默为已购空间
     _textFiled.text = proDetail.members_num;
 }else{
     //暂时还没有添加字段

     _textFiled.text = proDetail.members_num;

 }

}


#pragma mark - 重置最小值和默认值
-(void)calculateCloudMaxAndMin
{
    if ([_orderListModel.used_space longLongValue]/1024/1024/1024 - [_orderListModel.add_people?:@"0" intValue]*2 < 0 ) {
        _alreadyHaveCloud = 0;
    }else if ([_orderListModel.used_space longLongValue]/1024/1024/1024 - [_orderListModel.add_people intValue] *2 >=0){
        _alreadyHaveCloud = ((int)(([_orderListModel.used_space doubleValue]/1024/1024/1024 -[_orderListModel.add_people?:@"0" intValue]*2)/10) +1 ) *10;
    }else{
        _alreadyHaveCloud = 0;
        
    }
    if ([_orderListModel.cloud_space?:@"0" longLongValue] < _alreadyHaveCloud) {
        _VIPCloundDefult = _alreadyHaveCloud;
    }else if ([_orderListModel.cloud_space?:@"0" longLongValue] >= _alreadyHaveCloud)
    {
        _VIPCloundDefult = [_orderListModel.cloud_space longLongValue];
    }
    

}

@end
