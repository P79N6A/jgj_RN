//
//  YZGAudioAndPicTableViewCell.h
//  mix
//
//  Created by Tony on 16/3/2.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYModel.h"
#import "NSString+File.h"
#import "YZGGetBillModel.h"
#import "AudioRecordingServices.h"
#import "CustomView.h"
#import "JGJAddSignModel.h"
#import "TYTextView.h"
typedef NS_ENUM(NSUInteger, AudioCellType) {
    AudioCellTypeDefualt,
    AudioCellTypeSign
};
@class YZGAudioAndPicTableViewCell,AudioAndPicDataModel,TYTextView;
@protocol YZGAudioAndPicTableViewCellDelegate <NSObject>

@optional
- (void)AudioAndPicAddPicBtnClick:(YZGAudioAndPicTableViewCell *)cell;
- (void)AudioAndPicAddAudio:(YZGAudioAndPicTableViewCell *)cell audioInfo:(NSDictionary *)audioInfo;
- (void)AudioAndPicCellDelete:(YZGAudioAndPicTableViewCell *)cell Index:(NSInteger )index;
- (void)AudioAndPicCellphoneDidSelected:(YZGAudioAndPicTableViewCell *)cell Index:(NSInteger )index;
- (void)AudioAndPicCellTextFiledBeginEditing:(YZGAudioAndPicTableViewCell *)cell textView:(UITextView *)textView;
- (void)AudioAndPicCellTextFiledEndEditing:(YZGAudioAndPicTableViewCell *)cell textStr:(NSString *)textStr;
- (void)AudioAndPicCellTextViewDidChange:(UITextView *)textView textViewHeight:(CGFloat )textViewHeight;
@end

@interface YZGAudioAndPicTableViewCell : UITableViewCell
@property (nonatomic , weak) id<YZGAudioAndPicTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet TYTextView *detailTV;
@property (weak, nonatomic) IBOutlet UIView *audioView;
@property (weak, nonatomic) IBOutlet UILabel *NoteLabel;
@property (weak, nonatomic) IBOutlet LineView *lineView;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollection;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary *audioInfo;//保存语音的信息
@property (nonatomic,copy)   NSDictionary *audioFileInfo;//文件的url地址 @"url":url地址,@"fileTime":音频时间

@property (nonatomic,strong) NSMutableArray *imagesArray;//保存image的url
@property (strong, nonatomic) IBOutlet LineView *departLable;

@property (nonatomic,assign) BOOL readOnly;//是否只能查看

@property (nonatomic,assign) AudioCellType audioCellType;

#pragma mark - 停止播放多媒体语音
- (void)mediaCellStopAudio;
/**
 *  获取备注的内容
 *
 *  @return 备注的内容
 */
- (AudioAndPicDataModel *)getNotesInfo;


- (CGFloat )getiAudioHeight:(NSString *)notes_txt textViewHeight:(CGFloat )textViewHeight isreadOnly:(BOOL)isread;
- (CGFloat )getiAudioHeight:(NSString *)notes_txt textViewHeight:(CGFloat )textViewHeight;

- (CGFloat )getMediaHeightWithAddSignModel:(JGJAddSignModel *)addSignModel textViewHeight:(CGFloat )textViewHeight isReadOnly:(BOOL)isRead;
/**
 *  配置音频的数据
 *
 *  @param yzgGetBillModel model
 *  @param parametersDic   参数
 *  @param deleteImgsArray 删除的照片数组
 *  @param imagesArray     显示的照片数组
 */
- (void)configAudioData:(YZGGetBillModel *)yzgGetBillModel parametersDic:(NSMutableDictionary *)parametersDic deleteImgsArray:(NSMutableArray *)deleteImgsArray imagesArray:(NSMutableArray *)imagesArray;

/**
 *  配置cell
 *
 *  @param dataDic         传入的字典
 *  @param showVc          显示的viewcontroller
 *
 */
- (void )configureAudioAndPicCell:(NSDictionary *)dataDic showVc:(UIViewController <YZGAudioAndPicTableViewCellDelegate,UICollectionViewDelegate>*)showVc imagesArray:(NSMutableArray *)imagesArray;
@end

@interface AudioAndPicDataModel : TYModel

@property (nonatomic,copy) NSString *detailTFText;
@property (nonatomic,copy) NSDictionary *audioInfo;
@property (nonatomic,copy) NSArray *imagesArray;

@end
