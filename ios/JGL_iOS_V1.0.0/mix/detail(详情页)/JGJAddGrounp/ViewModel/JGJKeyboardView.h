//
//  JGJKeyboardView.h
//  mix
//
//  Created by Tony on 2016/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClickKerBoradButtondelegate<NSObject>
-(void)ClickKeyBoardnumberButtonToString:(NSString *)numberStr;
@end
@interface JGJKeyboardView : UIView

@property(nonatomic,strong)UIButton *numbutton;
@property(nonatomic,weak)id <ClickKerBoradButtondelegate> numdelegate;
@property(nonatomic,assign)int  tagNum;

@end
