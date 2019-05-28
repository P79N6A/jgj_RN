//
//  JGJLeaderRecordButtonView.h
//  mix
//
//  Created by Tony on 2017/9/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJLeaderRecordButtonViewDelegate <NSObject>
- (void)JGJLeaderRecordButtonClickMoreButton;
- (void)JGJLeaderRecordButtonClicksingerButton;

@end
@interface JGJLeaderRecordButtonView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *recordMoreButton;
@property (strong, nonatomic) IBOutlet UIButton *recordSingerButton;
@property (strong, nonatomic) id <JGJLeaderRecordButtonViewDelegate>delegate;
@end
