//
//  RecordWorkHomeNoteView.h
//  mix
//
//  Created by Tony on 16/2/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGWorkDayModel.h"

/**
 *  记账的数据模型
 */
@interface RecordWorkHomeNoteModel : TYModel

@property (nonatomic , assign) BOOL         isRecordNote;//YES:已经记账了，NO，没有记账
@property (nonatomic , assign) CGFloat      recordNoteMoney;//入账的金额
@property (nonatomic , assign) NSInteger   accounts_type;
@property (nonatomic, strong) WorkDayDtn_desc *btn_dest;
@end

@protocol RecordWorkHomeNoteViewDelegate <NSObject>
- (void)RecordWorkHomeNoteViewRecordNoteBtnClick;//点击了那个记一笔
@end

@interface RecordWorkHomeNoteView : UIView
@property (nonatomic , weak) id<RecordWorkHomeNoteViewDelegate> delegate;

@property (nonatomic , strong) RecordWorkHomeNoteModel *recordWorkModel;

@end


