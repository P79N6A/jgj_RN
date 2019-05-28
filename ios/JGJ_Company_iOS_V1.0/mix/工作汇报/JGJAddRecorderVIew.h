//
//  JGJAddRecorderVIew.h
//  JGJCompany
//
//  Created by Tony on 2017/5/23.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClickAddRecorderButtonDelegate <NSObject>
-(void)clickAddRecorderButton;
@end
@interface JGJAddRecorderVIew : UIView
@property (strong, nonatomic) IBOutlet UILabel *recordLable;
@property (strong, nonatomic) IBOutlet UIButton *sureAddButton;
@property (strong, nonatomic) id<ClickAddRecorderButtonDelegate>delegate;
@property (strong, nonatomic) UILabel *numlable;

-(void)setSelectPeopleNum:(NSString *)num;
@end
