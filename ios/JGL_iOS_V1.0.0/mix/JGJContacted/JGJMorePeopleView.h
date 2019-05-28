//
//  JGJMorePeopleView.h
//  mix
//
//  Created by Tony on 2017/10/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJMorePeopleViewDelegate <NSObject>

- (void)ClickChioceBtn;

@end
@interface JGJMorePeopleView : UIView


@property (strong, nonatomic)  UILabel *titleLable;

@property (strong, nonatomic)  UIButton *chioceBtn;

@property (strong, nonatomic) id <JGJMorePeopleViewDelegate>delegate;

-(void)setproTitle:(NSString *)title;
@end
