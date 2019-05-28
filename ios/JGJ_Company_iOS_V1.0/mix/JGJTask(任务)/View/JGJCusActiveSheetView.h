//
//  JGJCusActiveSheetView.h
//  mix
//
//  Created by yj on 2017/5/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JGJCusActiveSheetViewDefaultType, //默认类型
    
    JGJCusActiveSheetViewBoldPaddingType //第一个分割线加高，颜色为红色

} JGJCusActiveSheetViewType;

@interface JGJCusActiveSheetView : UIView

@property (nonatomic, copy) void(^buttonClickBlock)(JGJCusActiveSheetView *sheetView,NSInteger buttonIndex, NSString *title);

- (id)initWithTitle:(NSString *)title sheetViewType:(JGJCusActiveSheetViewType)sheetViewType chageColors:(NSArray *)chageColors buttons:(NSArray <NSString *>*)buttons buttonClick:(void(^)(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title))block;

- (void)showView;

- (void)dismissView;
@end
