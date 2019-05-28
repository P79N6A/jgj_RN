//
//  JGJSelProAddressPopView.h
//  JGJCompany
//
//  Created by yj on 2017/5/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJSelProAddressPopView;

typedef void(^HandleSelProAddressPopViewBlock)(JGJSelProAddressPopView *);

@interface JGJSelProAddressPopView : UIView

@property (copy, nonatomic) HandleSelProAddressPopViewBlock
    handleSelProAddressPopViewBlock;

+ (JGJSelProAddressPopView *)selProAddressPopViewWithCommonModel:(JGJTeamMemberCommonModel *)commonModel;
@end
