//
//  JGJFilterTabHeaderView.h
//  mix
//
//  Created by yj on 2019/1/3.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JGJFilterTabHeaderView : UIView

@property (nonatomic, strong) JGJComTitleDesInfoModel *timeInfoModel;

@property (nonatomic, strong) JGJRecordWorkStaListModel *staModel;

@property (nonatomic, strong, readonly) NSString *selDate;
@end

NS_ASSUME_NONNULL_END
