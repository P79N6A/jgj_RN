//
//  RecordWorkHomeMoneyView.h
//  mix
//
//  Created by Tony on 16/2/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordWorkHomeMoneyView : UIView

/**
 *  设置年收入和月收入
 *
 *  @param yearMoney  年收入
 *  @param monthMoney 月收入
 */
- (void)setMoneyWithMonth:(NSString *)monthMoney WithYear:(NSString *)yearMoney;
@end
