//
//  JGJChoiceTheCurrentAddressCell.h
//  mix
//
//  Created by Tony on 2018/3/9.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJCoreTextLable.h"
typedef void(^ChoiceTheCurAddress)(void);
typedef void(^RefreshCurLocation)(void);
@interface JGJChoiceTheCurrentAddressCell : UITableViewCell

@property (nonatomic, copy) ChoiceTheCurAddress theCurrentAddress;
@property (nonatomic, copy) RefreshCurLocation refreshCurLocation;
@property (nonatomic, copy) NSString *theCurrentLocationStr;
@property (nonatomic, assign) BOOL isEidteBuilderDaily;

@end
