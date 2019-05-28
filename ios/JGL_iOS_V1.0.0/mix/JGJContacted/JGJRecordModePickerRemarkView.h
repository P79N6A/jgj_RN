//
//  JGJRecordModePickerRemarkView.h
//  mix
//
//  Created by Tony on 2018/5/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGJRecordModePickerRemarkViewDelegate <NSObject>

@optional
- (void)didSelectedRecordRemark;

@end

@interface JGJRecordModePickerRemarkView : UIView

@property (nonatomic, weak) id<JGJRecordModePickerRemarkViewDelegate> remarkViewDelegate;
@property (nonatomic, strong) NSString *remarkedTxt;// 已记的备注文字
@property (nonatomic, strong) UILabel *remarkBottomLine;
@end
