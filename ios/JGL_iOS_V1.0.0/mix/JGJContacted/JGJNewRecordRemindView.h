//
//  JGJNewRecordRemindView.h
//  mix
//
//  Created by Tony on 2018/11/23.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShowWorkDay)(void);
@interface JGJNewRecordRemindView : UIView

@property (nonatomic, assign) BOOL isHiddenShowDayWork;
@property (nonatomic, copy) ShowWorkDay showWorkDay;
@end
