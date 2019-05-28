//
//  YZGAddFmNoContactsView.h
//  mix
//
//  Created by Tony on 16/3/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZGAddFmNoContactsView;
@protocol YZGAddFmNoContactsViewDelegate <NSObject>
- (void)YZGAddFmNoViewBtnClick:(YZGAddFmNoContactsView *)addFmNoContactsView;
@end

@interface YZGAddFmNoContactsView : UIView
@property (nonatomic , weak) id<YZGAddFmNoContactsViewDelegate> delegate;


- (void)showAddFmNoContactsView;

- (void)hiddenAddFmNocontactsView;
@end
