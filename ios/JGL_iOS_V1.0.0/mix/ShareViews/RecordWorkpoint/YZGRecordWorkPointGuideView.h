//
//  YZGRecordWorkPointGuideView.h
//  mix
//
//  Created by Tony on 16/3/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZGRecordWorkPointGuideModel,YZGRecordWorkPointGuideView;
@protocol YZGRecordWorkPointGuideViewDelegate <NSObject>
@optional
- (void)RecordWorkPointGuideNext:(YZGRecordWorkPointGuideView *)recordWorkPointGuideView;
- (void)RecordWorkPointHidden:(YZGRecordWorkPointGuideView *)recordWorkPointGuideView;
@end

@interface YZGRecordWorkPointGuideView : UIView
@property (nonatomic , weak) id<YZGRecordWorkPointGuideViewDelegate> delegate;
@property (nonatomic, strong) YZGRecordWorkPointGuideModel *RecordWorkPointGuideModel;

@property (nonatomic,assign) BOOL isMateBool;
@property (nonatomic, copy) NSArray *workIndexPathArr;//indexPath的数组
@property (nonatomic, strong) NSMutableArray *workFramePathArr;//frame的数组
@property (nonatomic, strong) NSMutableArray *workCellArr;//cell的数组

/**
 *  聊天界面传入的model当前是班组长/工头对工人记工显示选工人，非创建者显示对班组长/工头记工
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

- (void)hiddenRecordWorkPointGuideView;
- (void)showGuideViewSegment:(YZGRecordWorkPointGuideModel *)RecordWorkPointGuideModel;
- (void)showRecordWorkPointGuideView:(YZGRecordWorkPointGuideModel *)RecordWorkPointGuideModel;
- (void)changeContent:(YZGRecordWorkPointGuideModel *)RecordWorkPointGuideModel;

@end

@interface YZGRecordWorkPointGuideModel : NSObject
@property (nonatomic,assign) CGRect    showFrame;
@property (nonatomic,assign) NSInteger guideIndex;//图片的索引，即选择第几张图片
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger accountTypeCode;
@property (nonatomic,assign) NSInteger maxIndex;//最大的索引数
@end
