//
//  JLGLoadWebViewFailure.h
//  mix
//
//  Created by Tony on 16/1/15.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLGLoadWebViewFailureDelegate <NSObject>
- (void)LoadWebViewFailureRefresh;
@end

@interface JLGLoadWebViewFailure : UIView
@property (nonatomic , weak) id<JLGLoadWebViewFailureDelegate> delegate;

@end
