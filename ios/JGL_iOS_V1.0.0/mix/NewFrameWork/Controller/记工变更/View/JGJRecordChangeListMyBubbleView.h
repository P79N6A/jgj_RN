//
//  JGJRecordChangeListMyBubbleView.h
//  mix
//
//  Created by Tony on 2018/8/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJRecordWorkpointsChangeModel.h"

typedef void(^MyInfoCellHeaderPicClick)(NSIndexPath *indexPach);
@interface JGJRecordChangeListMyBubbleView : UIView

@property (nonatomic, copy) MyInfoCellHeaderPicClick headerPickClick;
@property (nonatomic, strong) JGJRecordWorkpointsChangeModel *changeInfoModel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
