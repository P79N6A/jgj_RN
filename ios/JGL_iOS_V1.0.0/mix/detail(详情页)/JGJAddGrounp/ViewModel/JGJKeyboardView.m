//
//  JGJKeyboardView.m
//  mix
//
//  Created by Tony on 2016/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJKeyboardView.h"
#import "JGJGetViewFrame.h"
#define RGB_COLOR(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1]
#define ScreenWidth  [UIScreen mainScreen].bounds.size
@implementation JGJKeyboardView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
                _tagNum = 0;
        for (int i = 0; i<3; i++) {
            _tagNum=i+1;
            for (int j =0; j<4; j++) {
                
                _numbutton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth.width/3*i, 60*j, (ScreenWidth.width-2)/3, 236/4)];
                [_numbutton addTarget:self action:@selector(ClickNumberButton:) forControlEvents:UIControlEventTouchUpInside];
                [_numbutton setBackgroundColor:AppFont090b0aColor];
//                [_numbutton setBackgroundImage:[UIImage imageNamed:@"paizhao"] forState:UIControlStateSelected];

                if (j==2) {
                    _tagNum = 7+i;
                }else if (j==3){
                    if (i==0) {
                        _tagNum = 10;
                    }else if (i ==1){
                        _tagNum = 0;
                    
                    }else{
                    
                        _tagNum = 12;

                    }
                    
                }else{
           
                    _tagNum =_tagNum+j*3;
                }
                [_numbutton setTag:_tagNum];
                [_numbutton setTitle:[NSString stringWithFormat:@"%d",_tagNum] forState:UIControlStateNormal];
                if (_tagNum == 12) {
                    [_numbutton setTitle:@"删除" forState:UIControlStateNormal];

                }
                if (_tagNum == 10) {
                    [_numbutton setTitle:@"" forState:UIControlStateNormal];

                }
                if (_tagNum == 11) {
                    _tagNum = 0;
                    [_numbutton setTitle:@"0" forState:UIControlStateNormal];

                }
                _numbutton.titleLabel.font = [UIFont systemFontOfSize:25];
                [_numbutton setTitleColor:AppFontffffffColor forState:UIControlStateNormal];

                [_numbutton setBackgroundImage:[self imageWithColor:AppFont181818Color] forState:UIControlStateHighlighted];
                [self addSubview:_numbutton];

            }
        }

        
    }
    return self;

}
-(void)ClickNumberButton:(UIButton *)sender
{

    if ([_numdelegate respondsToSelector:@selector(ClickKeyBoardnumberButtonToString:)]) {
        [_numdelegate ClickKeyBoardnumberButtonToString:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    }
    if (sender.selected) {
        sender.selected = NO;
    }else{
    
        sender.selected = YES;
    }


}


- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
