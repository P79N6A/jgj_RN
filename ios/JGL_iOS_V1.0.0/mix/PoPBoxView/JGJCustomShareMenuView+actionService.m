//
//  JGJCustomShareMenuView+actionService.m
//  mix
//
//  Created by yj on 2019/3/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJCustomShareMenuView+actionService.h"

#import "JGJWebAllSubViewController.h"

@implementation JGJCustomShareMenuView (actionService)

//分享到动态评论
- (void)handleShareDynamicComment {
    
    TYWeakSelf(self);
    
    //存在图片就上传
    if ([self.shareMenuModel.shareImage isKindOfClass:[UIImage class]]) {
        
        TYStrongSelf(self);
        [self uploadImageSuccess:^(NSString *imgUrl) {
            
            [strongself callHandleH5WithImgUrl:imgUrl];
            
        }];
        
    }else {
        
        [self callHandleH5WithImgUrl:nil];
    }
    
}

- (void)uploadImageSuccess:(void (^)(NSString *imgUrl))success {
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN newUploadImagesWithApi:@"file/upload" parameters:nil imagearray:@[self.shareMenuModel.shareImage] otherDataArray:nil dataNameArray:nil success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        NSArray *urls = (NSArray *)responseObject;
        
        NSString *imgUrl = @"";
        
        if (urls.count > 0) {
            
            imgUrl = urls.firstObject;
            
        }
        
        if (success) {
            
            success(imgUrl);
        }
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (void)callHandleH5WithImgUrl:(NSString *)imgUrl {

    if ([NSString isEmpty:imgUrl]) {
        
        if (![NSString isEmpty:self.shareMenuModel.imgUrl]) {
            
            imgUrl = self.shareMenuModel.imgUrl;
        }
    }
    
    NSString *url = self.shareMenuModel.url;
    
    if (![NSString isEmpty:url]) {
        
        url = [url URLEncode];
    }
    
    if (![NSString isEmpty:imgUrl]) {
        
        imgUrl = [imgUrl URLEncode];
    }
    
    NSString *webUrl = [NSString stringWithFormat:@"%@dynamic/comment?imgUrl=%@&url=%@&title=%@", JGJWebDiscoverURL,imgUrl?:@"",url?:@"",self.shareMenuModel.title?:@""];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
    
    [self.Vc.navigationController pushViewController:webVc animated:YES];
    
}

@end
