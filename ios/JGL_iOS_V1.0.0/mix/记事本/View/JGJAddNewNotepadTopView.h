//
//  JGJAddNewNotepadTopView.h
//  mix
//
//  Created by Tony on 2018/4/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CloseTheAddNewNotepad)(void);
typedef void(^ChoiceTheSaveTime)();
typedef void(^SaveTheNewNotepad)(void);
@interface JGJAddNewNotepadTopView : UIView


@property (nonatomic, copy) CloseTheAddNewNotepad close;
@property (nonatomic, copy) ChoiceTheSaveTime choiceTheSaveTime;
@property (nonatomic, copy) SaveTheNewNotepad saveNotepad;

- (void)setTheTitleWithTimeArray:(NSArray *)timeArray weekIndex:(NSInteger)weekIndex;

@end
