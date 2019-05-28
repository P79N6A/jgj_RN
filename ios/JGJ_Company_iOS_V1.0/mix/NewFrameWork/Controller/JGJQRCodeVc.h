//
//  JGJQRCodeVc.h
//  mix
//
//  Created by Tony on 2016/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYQRCodeVc.h"

typedef void(^JGJQRCodeVcBlock)(void);

@interface JGJQRCodeVc : TYQRCodeVc

//会议扫码后返回头子闪烁问题
@property (copy, nonatomic) JGJQRCodeVcBlock QRCodeVcBlock;

@end
