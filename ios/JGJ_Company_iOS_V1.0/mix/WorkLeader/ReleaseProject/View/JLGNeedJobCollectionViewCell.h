//
//  JLGNeedJobCollectionViewCell.h
//  mix
//
//  Created by jizhi on 15/11/20.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLGNeedJobCollectionViewCellDelegate <NSObject>

/**
 *  按移动图标这个按钮的delegate
 */
-(void)needJobCollectionCellBtnClikIndex:(NSUInteger )index selected:(BOOL )selected;
@end

@interface JLGNeedJobCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *jobTypeButton;
@property (nonatomic , weak) id<JLGNeedJobCollectionViewCellDelegate> delegate;

//设置按钮的选中状态
- (void)jobTypeButtonSelected:(BOOL)isSelected;
@end
