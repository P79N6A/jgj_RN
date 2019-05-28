//
//  JGJAdvertisementShowView.h
//  JGJCompany
//
//  Created by Tony on 2017/6/9.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSInteger, JGJadverTisenmentType){
    JGJadverTisenmentType_URL,//根据url来获取图片
    JGJadverTisenmentType_IMAGE,//本地给图片
    JGJadverTisenmentType_video,//播放视频
    JGJadverTisenmentType_NONE//不显示
};
typedef void(^didslectActionBlock)(NSString *selectString);


@interface JGJAdvertisementShowView : UIView
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonheight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonwidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageheight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imagewidth;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (copy, nonatomic) didslectActionBlock selectActionBlock;

+(void)showadverTiseMentWithImageUrl:(NSString *)url withImage:(UIImage *)image forType:(JGJadverTisenmentType)type andtapImageBlock:(didslectActionBlock)tapYes;

@end
