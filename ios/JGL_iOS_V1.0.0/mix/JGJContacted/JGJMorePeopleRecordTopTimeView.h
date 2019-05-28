//
//  JGJMorePeopleRecordTopTimeView.h
//  mix
//
//  Created by Tony on 2018/11/27.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGJMorePeopleRecordTopTimeViewDelegate <NSObject>

- (void)recordTopTimeDidSelected;
@end

@interface JGJMorePeopleRecordTopTimeView : UIView

@property (nonatomic, weak) id<JGJMorePeopleRecordTopTimeViewDelegate> topTimeViewDelegate;

@property (nonatomic, strong) NSString *topShowTime;
@end
