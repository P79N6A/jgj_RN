//
//  JGJTSearchProAddressDefaultCell.h
//  JGJCompany
//
//  Created by yj on 2017/5/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JGJTSearchProAddressDefaultCell;

typedef void(^HandleSearchProAddressDefaultCellBlock)(JGJTSearchProAddressDefaultCell *);

@interface JGJProAddressModel : NSObject

@property (nonatomic, copy) NSString *addressTitle;

@property (nonatomic, copy) NSString *addressDetailTitle;

@end

@interface JGJTSearchProAddressDefaultCell : UITableViewCell

@property (nonatomic, strong) JGJProAddressModel *proAddressModel;

@property (nonatomic, copy) HandleSearchProAddressDefaultCellBlock handleSearchProAddressDefaultCellBlock;

@end
