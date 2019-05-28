//
//  JLGPadFundedTableViewCell.h
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLGPadFundedTableViewCellDelegate <NSObject>
-(void)PadFundedSelected:(NSInteger )index;
@end

@interface JLGPadFundedTableViewCell : UITableViewCell
@property (nonatomic , weak) id<JLGPadFundedTableViewCellDelegate> delegate;

@property (nonatomic,assign) NSUInteger selectedNum;
@end
