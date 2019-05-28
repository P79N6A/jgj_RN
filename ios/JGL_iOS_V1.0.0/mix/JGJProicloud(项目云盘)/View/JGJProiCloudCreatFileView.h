//
//  JGJProiCloudCreatFileView.h
//  JGJCompany
//
//  Created by yj on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTextField.h"

@class JGJProiCloudCreatFileView;
typedef void(^ProiCloudCreatFileViewBlock)(JGJProiCloudCreatFileView *creatFileView, NSString *fileNameText);

@interface JGJProiCloudCreatFileView : UIView

@property (nonatomic, copy) void (^onOkBlock) (JGJProiCloudCreatFileView *);
@property (weak, nonatomic) IBOutlet LengthLimitTextField *fileNameTextField;

@property (nonatomic, copy) ProiCloudCreatFileViewBlock proiCloudCreatFileViewBlock;

+ (JGJProiCloudCreatFileView *)proiCloudCreatFileView:(JGJProicloudListModel *)cloudListModel;

@end
