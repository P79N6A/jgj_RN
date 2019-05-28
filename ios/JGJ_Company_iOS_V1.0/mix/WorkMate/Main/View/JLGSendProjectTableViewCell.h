//
//  JLGSendProjectTableViewCell.h
//  mix
//
//  Created by jizhi on 15/11/20.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLGSendProjectTableViewCellDelegate <NSObject>
//点击按钮
-(void)sendProjectCellBtnClick;
@end

@interface JLGSendProjectTableViewCell : UITableViewCell

@property (assign,nonatomic)id<JLGSendProjectTableViewCellDelegate> delegate;
@property (strong,nonatomic) UIColor *backColor;
@property (strong,nonatomic) NSString *titleString;
- (void)setSendButtonTitle:(NSString *)title titleColor:(UIColor *)titleColor backGroudcolor:(UIColor *)backgroundColor;
@end
