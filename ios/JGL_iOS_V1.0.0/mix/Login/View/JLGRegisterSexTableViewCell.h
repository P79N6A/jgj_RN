//
//  JLGRegisterSexTableViewCell.h
//  mix
//
//  Created by jizhi on 15/11/17.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SexNum) {
    SexUnkown = 0,
    SexMan,
    SexFemale,
};

@protocol JLGRegisterSexTableViewCellDelegate <NSObject>
- (void)setSexNum:(SexNum )sexNum;
@end

@interface JLGRegisterSexTableViewCell : UITableViewCell
@property (nonatomic , weak) id<JLGRegisterSexTableViewCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *manButton;
@property (strong, nonatomic) IBOutlet UIButton *famleButton;

- (SexNum )getSexNum;
- (void)setSexNum:(SexNum )sexNum;
@end
