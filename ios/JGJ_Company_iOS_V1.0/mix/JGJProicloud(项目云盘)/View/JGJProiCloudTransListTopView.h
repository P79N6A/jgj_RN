//
//  JGJProiCloudTransListTopView.h
//  JGJCompany
//
//  Created by yj on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJProiCloudTransListTopView;

typedef enum : NSUInteger {
    
    ProiCloudTransListTopViewDownloadButtonType = 0,
    
    ProiCloudTransListTopViewUploadButtonType
    
} ProiCloudTransListTopViewButtonType;

typedef void(^ProiCloudTransListTopViewBlock)(ProiCloudTransListTopViewButtonType);

@interface JGJProiCloudTransListTopView : UIView

@property (nonatomic, copy) ProiCloudTransListTopViewBlock proiCloudTransListTopViewBlock;

@end
