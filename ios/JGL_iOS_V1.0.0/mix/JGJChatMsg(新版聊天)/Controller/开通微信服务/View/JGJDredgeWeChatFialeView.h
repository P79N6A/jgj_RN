//
//  JGJDredgeWeChatFialeView.h
//  mix
//
//  Created by Tony on 2018/12/18.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SaveQrCodePicture)(void);
@interface JGJDredgeWeChatFialeView : UIView

@property (nonatomic, copy) SaveQrCodePicture saveQrCodePicture;
@property (nonatomic, copy) NSString *codeUrl;
@property (nonatomic, strong,readonly) UIImageView *qrcodeImage;
@end
