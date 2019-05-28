//
//  YZGNoWorkitemsView.h
//  mix
//
//  Created by Tony on 16/3/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZGNoWorkitemsView;
@protocol YZGNoWorkitemsViewDelegate <NSObject>
@optional
- (void)YZGNoWorkitemsViewBtnClick:(YZGNoWorkitemsView *)YZGNoWorkitemsView;
@end

@interface YZGNoWorkitemsView : UIView
@property (strong, nonatomic) IBOutlet UILabel *departLable;
@property (nonatomic , weak) id<YZGNoWorkitemsViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *noRecordButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
- (void)showNoWorkitemsView;

- (void)hiddenNoWorkitemsView;

/**
 *  设置label的text
 *
 *  @param titleString 需要设置的text
 */
- (void)setTitleString:(id)titleString;

/**
 *  设置label的text
 *
 *  @param titleString 需要设置的text
 *  @param subString   第二行的text
 */
- (void)setTitleString:(id)titleString subString:(id)subString;
/**
 *  button是否显示
 *
 *  @param isShow YES:显示,NO,不显示
 */
- (void)setButtonShow:(BOOL )isShow;

/**
 *  设置button的title，如果设置了，则代表不依你苍
 *
 *  @param buttonTitle 设置的title
 */
- (void)setButtonString:(NSString *)buttonTitle;
/**
 *  设置单纯的文本显示
 *
 *
 */
- (void)setContentStr:(NSString *)content;

@end
