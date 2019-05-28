//
//  JLGRegisterHeadPicTableViewCell.h
//  mix
//
//  Created by Tony on 16/1/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLGRegisterHeadPicTableViewCellDelegate <NSObject>
- (void)JLGRegisterHeadPicBtnClick;
@end

@interface JLGRegisterHeadPicTableViewCell : UITableViewCell
@property (nonatomic , weak) id<JLGRegisterHeadPicTableViewCellDelegate> delegate;
@property (nonatomic,strong) UIImage *headImage;
@end
