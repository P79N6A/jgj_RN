//
//  JGJOtherInfoViewController.h
//  mix
//
//  Created by Tony on 16/4/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "UIPhotoViewController.h"
#import "NSDate+Extend.h"
#import "NSString+Extend.h"
#import "JLGDatePickerView.h"
#import "YZGAudioAndPicTableViewCell.h"
#import "YZGRecordWorkNextVcTableViewCell.h"

@interface JGJOtherInfoViewController : UIPhotoViewController
@property (nonatomic,strong) YZGGetBillModel *yzgGetBillModel;
@property (nonatomic,strong) NSMutableArray *deleteImgsArray;
@property (nonatomic,strong) NSMutableDictionary *parametersDic;
@end
