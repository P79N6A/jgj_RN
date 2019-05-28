//
//  JGJSyncProjectInfoBottomView.h
//  mix
//
//  Created by Tony on 2018/12/12.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SyncProjectBottomBlock)(NSInteger index);
@interface JGJSyncProjectInfoBottomView : UIView

@property (nonatomic, copy) SyncProjectBottomBlock bottomBlock;
@end
