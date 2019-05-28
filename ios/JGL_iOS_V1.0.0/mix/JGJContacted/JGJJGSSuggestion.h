//
//  JGJJGSSuggestion.h
//  mix
//
//  Created by Tony on 2017/1/5.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol jumpScoreWorkdelegate<NSObject>
-(void)jumpScoreWorkViewControllerthing;
@end

@interface JGJJGSSuggestion : UIView
@property(nonatomic ,retain)id <jumpScoreWorkdelegate> jumpDelegate ;
@property(nonatomic ,strong)UILabel *TitleLable;
@property(nonatomic ,strong)UIButton *QuitButton;

@end
