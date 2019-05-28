//
//  JGJCusButtonSheetView.h
//  mix
//
//  Created by yj on 2018/4/27.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJCusButtonSheetViewDefaultType,

} JGJCusButtonSheetViewType;

@interface JGJCusButtonSheetView : UIView

- (instancetype)initWithSheetViewType:(JGJCusButtonSheetViewType)sheetViewType chageColors:(NSArray *)chageColors buttons:(NSArray <NSString *>*)buttons buttonClick:(void(^)(JGJCusButtonSheetView *sheetView, NSInteger buttonIndex, NSString *title))block;

@property (nonatomic, copy) void (^sheetViewBlock)(JGJCusButtonSheetView *sheetView, NSInteger buttonIndex, NSString *title);

@end
