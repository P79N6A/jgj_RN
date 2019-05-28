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

@property (nonatomic, copy) ProiCloudCreatFileViewBlock proiCloudCreatFileViewBlock;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *fileNameTextField;

+ (JGJProiCloudCreatFileView *)proiCloudCreatFileView:(JGJProicloudListModel *)cloudListModel;

@end
