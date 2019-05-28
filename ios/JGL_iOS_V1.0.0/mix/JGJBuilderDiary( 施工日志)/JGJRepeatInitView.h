//
//  JGJRepeatInitView.h
//  JGJCompany
//
//  Created by Tony on 2017/8/17.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol clickRepeatButtondelegate <NSObject>
-(void)clickRepeatButton;
@end
@interface JGJRepeatInitView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *numlable;
@property (strong, nonatomic) IBOutlet UIButton *clickButton;
@property (strong, nonatomic) id <clickRepeatButtondelegate> delegate;

@end
