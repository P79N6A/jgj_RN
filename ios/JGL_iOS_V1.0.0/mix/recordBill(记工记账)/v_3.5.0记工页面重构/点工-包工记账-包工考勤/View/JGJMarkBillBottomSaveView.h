//
//  JGJMarkBillBottomSaveView.h
//  mix
//
//  Created by Tony on 2019/1/4.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickSaveToServer)(void);
@interface JGJMarkBillBottomSaveView : UIView

@property (nonatomic, copy) ClickSaveToServer saveToServer;
@end
