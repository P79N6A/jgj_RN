//
//  JGJRecordWorkpointsSettingController.h
//  mix
//
//  Created by Tony on 2019/2/16.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGJRecordWorkpointsSettingControllerDelegate <NSObject>

- (void)recordWorkpointsSettingOpenOrClose:(BOOL)isOpen;


@end
@interface JGJRecordWorkpointsSettingController : UIViewController

@property (nonatomic, weak) id<JGJRecordWorkpointsSettingControllerDelegate> delegate;


@end
