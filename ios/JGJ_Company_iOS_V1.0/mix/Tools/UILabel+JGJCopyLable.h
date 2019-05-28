//
//  UILabel+JGJCopyLable.h
//  JGJCompany
//
//  Created by Tony on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJCopyLableActionBlock)();

@interface UILabel (JGJCopyLable)

@property (nonatomic, copy) JGJCopyLableActionBlock copyLableActionBlock;

-(void)canCopyWithlable:(UILabel *)lable;
-(void)SetLinDepart:(NSInteger)distance;
- (void)creatInternetHyperlinks;

@end
