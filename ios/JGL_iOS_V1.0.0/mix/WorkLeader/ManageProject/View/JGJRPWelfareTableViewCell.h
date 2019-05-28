//
//  JGJRPWelfareTableViewCell.h
//  mix
//
//  Created by Tony on 16/4/15.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYModel.h"

@interface JGJRPWelfareModel : TYModel

@property (nonatomic,assign) NSInteger id;
@property (nonatomic,copy)   NSString *name;
@property (nonatomic,assign) NSInteger selected;//是否选中
@end

@class JGJRPWelfareTableViewCell;
@protocol JGJRPWelfareTableViewCellDelegate <NSObject>
- (void )JGJWelfareTypeBtnClick:(JGJRPWelfareTableViewCell *)welfareTableCell;
- (void )JGJAddWelfareBtnClick:(JGJRPWelfareTableViewCell *)welfareTableCell;
@end

@interface JGJRPWelfareTableViewCell : UITableViewCell
@property (nonatomic , weak) id<JGJRPWelfareTableViewCellDelegate> delegate;

@property (nonatomic,assign) CGFloat viewH;
@property (strong,nonatomic) NSMutableArray *WelfaresArray;
@end


