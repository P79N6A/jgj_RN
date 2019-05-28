//
//  JGJNewWorkHomeNoteBtnView.h
//  mix
//
//  Created by Tony on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGJNewWorkHomeNoteBtnViewDelegate <NSObject>

- (void)JGJNewWorkHomeNoteButtonClickSingleMarkBillBtn;// 点击马上记一笔
- (void)JGJNewWorkHomeNoteButtonClickBorrowOrCloseMarkBillBtn;// 点击借支或者结算

@end
@interface JGJNewWorkHomeNoteBtnView : UIView

@property (strong, nonatomic) id <JGJNewWorkHomeNoteBtnViewDelegate> delegate;
@end
