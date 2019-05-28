//
//  JGJVideoListModel.h
//  mix
//
//  Created by yj on 2018/3/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

// 播放器的几种状态
typedef NS_ENUM(NSInteger, JGJVideoPlayerState) {
    JGJPlayerStateDefault,     // 默认状态初始化播放
    JGJPlayerStateFailed,     // 播放失败
    JGJPlayerStateBuffering,  // 缓冲中
    JGJPlayerStatePlaying,    // 播放中
    JGJPlayerStateStopped,    // 停止播放
    JGJPlayerStatePause       // 暂停播放
};

@interface JGJVideoCommonModel : NSObject

@end

@interface JGJVideoListModel : NSObject

@property (nonatomic, copy) NSString *post_id;

@property (nonatomic, strong) NSArray *pic_src;

@property (nonatomic, copy) NSString *video_id;

@property (nonatomic, copy) NSString *video_url;

//点赞数量
@property (nonatomic, copy) NSString *like_num;

//自己收藏
@property (nonatomic, copy) NSString *is_liked;

@property (nonatomic, copy) NSString *comment_num;

@property (nonatomic, copy) NSString *cms_content;

@property (nonatomic, copy) NSString *collection_num;

//播放状态
@property (nonatomic, assign) JGJVideoPlayerState playerState;

@property (nonatomic, assign) NSInteger seekTime;//播放时间

@property (nonatomic, strong) JGJSynBillingModel *user_info;

@property (nonatomic, copy) NSString *title;

//播放时黑色
@property (nonatomic, assign) BOOL isCoverVideoBlack;

@property (nonatomic, assign) BOOL isCoverBottomBlack;

//是否自动播放第一个视频 默认自动播放
@property (nonatomic, assign) BOOL isUnAutoPlayFirstVideo;

@end
