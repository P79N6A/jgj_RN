//
//  JGJContractorTypeChoiceHeaderView.h
//  mix
//
//  Created by Tony on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJNoHighlightedBtn.h"

typedef enum : NSUInteger {
    
    JGJRecordSelLeftBtnType, //左边按钮
    
    JGJRecordSelRightBtnType, //右边按钮

} JGJRecordSelBtnType;

@protocol JGJContractorTypeChoiceHeaderViewDelegate <NSObject>

@optional
- (void)contractorHeaderSelectedWithType:(NSInteger)tag;

@end

typedef void(^ContractorTypeChoiceHeaderBlock)(NSInteger index);
@interface JGJContractorTypeChoiceHeaderView : UIView

@property (nonatomic, weak) id<JGJContractorTypeChoiceHeaderViewDelegate> delegate;

@property (nonatomic, copy) ContractorTypeChoiceHeaderBlock contractorHeaderBlcok;
@property (nonatomic, copy) NSArray *btTileArr;

//切圆角
@property (nonatomic, assign) CGFloat cornerRad;

@property (nonatomic, strong, readonly) JGJNoHighlightedBtn *attendanceType;

@property (nonatomic, strong, readonly) JGJNoHighlightedBtn *accountType;

//选中的按钮类型yj-3.3.7
@property (nonatomic, assign) JGJRecordSelBtnType selType;

- (void)changeleftBtnWithNormalImage:(NSString *)leftNormalStr leftSelectedImage:(NSString *)leftSelectedImage rightNormalImage:(NSString *)rightNormalImage rightSelectedImage:(NSString *)rightSelectedImage;
@end
