//
//  JGJPersonLastWageListView.h
//  mix
//
//  Created by Tony on 2016/7/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJPersonLastWageListView;
@protocol JGJPersonLastWageListViewDelegate <NSObject>

- (void)PersonLastWageListLeftBtnClick:(JGJPersonLastWageListView *)lastWageListView;
- (void)PersonLastWageListRightBtnClick:(JGJPersonLastWageListView *)lastWageListView;

@end


@interface JGJPersonLastWageListView : UIView

@property (nonatomic , weak) id<JGJPersonLastWageListViewDelegate> delegate;

@property (nonatomic,strong) NSMutableDictionary *dataDic;

@end
