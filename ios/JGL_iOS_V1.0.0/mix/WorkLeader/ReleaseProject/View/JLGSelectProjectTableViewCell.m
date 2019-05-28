//
//  JLGSelectProjectTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGSelectProjectTableViewCell.h"

@interface JLGSelectProjectTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *relatedWithMeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelH;
@end

@implementation JLGSelectProjectTableViewCell

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    CGFloat originalButtonY = [self setoriginalButtonY];
    CGFloat buttonH = defaultH;
    CGFloat buttonW = (TYGetUIScreenWidth - 3*marginValue)/2;
    
    for (int i = 0; i < dataArray.count; i++) {
        //frame
        CGFloat buttonX = ((i%2) == 0)?marginValue:2*marginValue + buttonW;
        CGFloat buttonY = originalButtonY + (i/2)*(marginValue + buttonH);
        UIButton *projectButton = [[UIButton alloc] initWithFrame:TYSetRect(buttonX, buttonY, buttonW, buttonH)];
        projectButton.tag = 1+i;
        
        //title
        NSString *buttonTitle;
        id subElement = self.dataArray[i];
        if ([subElement isKindOfClass:[NSDictionary class]]) {
            buttonTitle = [NSString stringWithFormat:@"%@\n%@",self.dataArray[i][@"proname"],self.dataArray[i][@"regionname"]];
        }else{
            buttonTitle = self.dataArray[i];
        }
        
        
        [self addSubButton:projectButton title:buttonTitle];
    }

    UIButton *makeMyButton;
    if (!self.notCreateMybutton) {
        makeMyButton = [self addMyProjectButton:dataArray Y:originalButtonY H:buttonH];
    }
    
    [self setFirstButton:makeMyButton];
}

- (void)setIsHiddenTopTileLabel:(BOOL)isHiddenTopTileLabel{
    _isHiddenTopTileLabel = isHiddenTopTileLabel;
    self.titleLabelH.constant = isHiddenTopTileLabel?0:18;
    self.topTitleLabel.text = isHiddenTopTileLabel?@"":@"1.选择项目";
}

- (CGFloat )setoriginalButtonY{
    return TYGetMaxY(self.relatedWithMeLabel) + marginValue;
}

- (UIButton *)addMyProjectButton:(NSArray *)dataArray Y:(CGFloat )originalButtonY H:(CGFloat )buttonH{
    //frame
    CGFloat myButtonX = marginValue;
    CGFloat myButtonY = originalButtonY + ((dataArray.count+1)/2)*(marginValue + buttonH);
    CGFloat myButtonW = TYGetUIScreenWidth - 2*marginValue;
    UIButton *makeMyButton = [[UIButton alloc] initWithFrame:TYSetRect(myButtonX, myButtonY, myButtonW, buttonH)];
    makeMyButton.tag = 1+dataArray.count;
    
    //title
    NSString *myButtonTitle = @"我要新建项目";
    [self addSubButton:makeMyButton title:myButtonTitle];
    return makeMyButton;
}

- (void )setFirstButton:(UIButton *)firstButton{
    [self selectProjectBtnClick:firstButton];
}

//设置button
- (void)addSubButton:(UIButton *)subButton title:(NSString *)title{
    [self initButtonLayer:subButton];
    
    [subButton setTitle:title forState:UIControlStateNormal];
    [subButton setTitle:title forState:UIControlStateSelected];
    subButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    subButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    subButton.contentHorizontalAlignment= UIControlContentHorizontalAlignmentCenter;
    
    //target subview
    [subButton addTarget:self action:@selector(selectProjectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:subButton];
}

- (void)initButtonLayer:(UIButton *)button{
    [button setTitleColor:TYColorHex(0x8b8b8b) forState:UIControlStateNormal];
    [button setTitleColor:JGJMainColor forState:UIControlStateSelected];
    [button.layer setLayerBorderWithColor:TYColorHex(0x8b8b8b) width:1.0 radius:12.0];
}


- (void )selectProjectBtnClick:(UIButton *)sender {
    for (NSInteger idx = 1; idx <= self.dataArray.count + 1; idx++) {
        if (sender.tag == idx) {
            sender.selected = YES;
            [sender.layer setLayerBorderWithColor:JGJMainColor width:1.0 radius:12.0];
            self.selectButton = idx;
        }else{
            UIButton *button = [self viewWithTag:idx];
            button.selected = NO;
            [button.layer setLayerBorderWithColor:TYColorHex(0x8b8b8b) width:1.0 radius:12.0];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedProButton:)]) {
        [self.delegate selectedProButton:sender.tag];
    }
}

- (void)setProjectNum:(NSInteger)projectNum{
    _projectNum = projectNum;
    
    NSInteger createMyNum = self.notCreateMybutton?0:1;

    self.cellHeight = 50 + (marginValue + defaultH)*((projectNum + 1)/2 + createMyNum);
}

- (void)dealloc{
    [self.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
}
@end
