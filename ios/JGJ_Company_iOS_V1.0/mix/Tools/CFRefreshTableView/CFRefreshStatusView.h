//
//  CFRefreshStatusView.h
//  RepairHelper
//
//  Created by coreyfu on 15/6/4.
//
//

#import <UIKit/UIKit.h>
#import "CFRefreshTableViewDefines.h"
#import "JGJComDefaultView.h"
@class CFRefreshStatusView;
@protocol CFRefreshStatusViewDelegate <NSObject>
@optional
- (void)cfreRreshStatusViewButtonPressedWithcfreRreshStatusView:(CFRefreshStatusView *)statusView;
- (void)handleAlertButtonAction:(CFRefreshStatusView *)statusView;
@end
@interface CFRefreshStatusView : UIView
@property(nonatomic, strong) UIColor *textColor;
- (CFRefreshStatusView *)initWithImage:(UIImage *)img withTips:(NSString *)tips;
+ (CFRefreshStatusView *)defaultViewWithStatus:(ERefreshTableViewStatus)status;
- (void)botttomButtonTilte:(NSString *)buttonTilte buttomImage:(NSString *)imageStr;
@property (nonatomic, weak) id <CFRefreshStatusViewDelegate> delegate;
@property (nonatomic, copy) NSString *buttonTitle;
@property (nonatomic, strong)UILabel *tipsLabel;
@end
