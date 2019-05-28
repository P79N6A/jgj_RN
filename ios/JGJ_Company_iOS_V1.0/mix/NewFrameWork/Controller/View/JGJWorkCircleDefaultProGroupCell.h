//
//  JGJWorkCircleDefaultProGroupCell.h
//  mix
//
//  Created by Tony on 2016/8/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGJWorkCircleDefaultProGroupCell;

typedef enum : NSUInteger {
    DefaultClickDefaultType = 0,
    DefaultClickCreateGroupType,
    DefaultClickScanQRCodeType,
    DefaultClickLoginType
} DefaultClickType;

@protocol WorkCircleDefaultDelegate <NSObject>

- (void)defaultGroupBtnClick:(JGJWorkCircleDefaultProGroupCell *)jgjWorkCircleDefaultProGroupCell clickType:(WorkCircleHeaderFooterViewButtonType)clickType;
@end

@interface JGJWorkCircleDefaultProGroupCell : UITableViewCell

@property (nonatomic , weak) id<WorkCircleDefaultDelegate> delegate;

+ (CGFloat)defaultProGroupCellHeight;

@end
