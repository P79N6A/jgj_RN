//
//  JGJSelSynTypeView.h
//  mix
//
//  Created by yj on 2018/4/16.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJSelSynTypeView;

typedef enum : NSUInteger {
    
    JGJSelSynRecordWorkAccountButtonType, //记工记账
    
    JGJSelSynRecordWorkButtonType //记工

} JGJSelSynButtonType;

@protocol JGJSelSynTypeViewDelegate <NSObject>

- (void)selSynTypeView:(JGJSelSynTypeView *)typeView syncType:(JGJSyncType)syncType;

@end

@interface JGJSelSynTypeView : UIView

@property (weak, nonatomic) id <JGJSelSynTypeViewDelegate> delegate;

@end
