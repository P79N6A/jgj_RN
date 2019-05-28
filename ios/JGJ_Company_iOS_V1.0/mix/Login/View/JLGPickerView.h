//
//  JLGPickerView.h
//  HuDuoDuoCustomer
//
//  Created by jizhi on 15/9/21.
//  Copyright (c) 2015年 celion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JLGPickerView;
@protocol JLGPickerViewDelegate <NSObject>

@optional
- (void)JLGPickerViewSelect:(NSArray *)finishArray;
- (void)JGJPickViewEditButtonPressed:(NSArray *)dataArray;//点击编辑按钮跳转页面
@end

@interface JLGPickerView : UIView

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) id<JLGPickerViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (assign, nonatomic) BOOL isShowEditButton;//是否显示编辑按钮
- (void)hiddenPicker;
/**
 *  设置一开始选中的components,
 *  如果数组是@[@4],表示只默认选中第1个compoent的第4个row
 *  如果数组是@[@3,@2],表示选中第1个component的第3个row和第2个component的第2个row
 *  @param selectedComponentsArray components数组
 */
- (void)setAllSelectedComponents:(NSArray *)selectedComponentsArray;
- (void)showPickerByIndexPath:(NSIndexPath *)indexPath dataArray:(NSArray *)dataArray title:(NSString *)title isMulti:(BOOL )isMulti;

@end
