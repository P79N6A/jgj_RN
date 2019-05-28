//
//  JLGSelectProjectTableViewCell.h
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CALayer+SetLayer.h"

#define defaultH 50
#define marginValue 10


@protocol JLGSelectProjectTableViewCellDelegate <NSObject>
- (void)selectedProButton:(NSInteger )index;//起点是1
@end

@interface JLGSelectProjectTableViewCell : UITableViewCell
@property (nonatomic , weak) id<JLGSelectProjectTableViewCellDelegate> delegate;

@property (nonatomic,copy) NSArray *dataArray;
@property (assign,nonatomic) BOOL notCreateMybutton;
@property (assign,nonatomic) BOOL isHiddenTopTileLabel;
@property (assign,nonatomic) NSUInteger selectButton;
@property (assign,nonatomic) NSInteger projectNum;
@property (assign,nonatomic) CGFloat cellHeight;

- (CGFloat )setoriginalButtonY;
- (void)initButtonLayer:(UIButton *)button;
- (void )setFirstButton:(UIButton *)firstButton;
- (void )selectProjectBtnClick:(UIButton *)sender;
@end
