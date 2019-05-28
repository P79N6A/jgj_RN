//
//  JGJAddAccountMemberInfoCell.h
//  mix
//
//  Created by yj on 2018/6/7.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJAccountComDesModel.h"

#import "CustomView.h"

typedef void(^AccountMemberInfoCellBlock)(JGJCommonInfoDesModel *desModel);

@interface JGJAddAccountMemberInfoCell : UITableViewCell

@property (nonatomic, strong) JGJCommonInfoDesModel *desModel;

@property (nonatomic, strong) AccountMemberInfoCellBlock accountMemberInfoCellBlock;

@property (weak, nonatomic) IBOutlet LineView *topLineView;

@property (nonatomic, copy) NSString *contractor_type; //1，//承包 2:分包

@end
