//
//  YZGMateShowpoor.h
//  mix
//
//  Created by Tony on 16/2/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MateWorkitemsItems,YZGMateShowpoor;
@protocol YZGMateShowpoorDelegate <NSObject>
@optional
- (void)MateShowpoorModifyBtnClick:(YZGMateShowpoor *)yzgMateShowpoor;
- (void)MateShowpoorCopyBillBtnClick:(YZGMateShowpoor *)yzgMateShowpoor;
@end

@interface YZGMateShowpoor : UIView

@property (nonatomic, strong) MateWorkitemsItems *mateWorkitemsItem;

@property (nonatomic , weak) id<YZGMateShowpoorDelegate> delegate;

- (void)showpoorView;
@end
