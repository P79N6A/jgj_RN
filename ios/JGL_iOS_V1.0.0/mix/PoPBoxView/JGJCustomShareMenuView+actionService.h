//
//  JGJCustomShareMenuView+actionService.h
//  mix
//
//  Created by yj on 2019/3/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJCustomShareMenuView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JGJCustomShareMenuView (actionService)

//分享到动态评论

- (void)handleShareDynamicComment;

//上传图片成功回执

- (void)uploadImageSuccess:(void (^)(NSString *imgUrl))success;

@end

NS_ASSUME_NONNULL_END
