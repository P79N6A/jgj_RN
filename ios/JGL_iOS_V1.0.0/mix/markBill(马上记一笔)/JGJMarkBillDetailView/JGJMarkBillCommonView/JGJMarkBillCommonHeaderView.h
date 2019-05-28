//
//  JGJMarkBillCommonHeaderView.h
//  mix
//
//  Created by Tony on 2018/1/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum: NSUInteger{
    JGJMarkSelectTinyBtnType = 0,
    
    JGJMarkSelectContractBtnType,
    
    JGJMarkSelectBrrowBtnType,
    
    JGJMarkSelectCloseAccountBtnType,
    
}JGJMarkSelectBtnType;
@protocol JGJMarkBillCommonHeaderViewDelegate <NSObject>

- (void)clickMarkBillTopBtnWithType:(JGJMarkSelectBtnType )MarkSelectBtnType;//点击
@optional
- (void)collectionViewScoroll:(JGJMarkSelectBtnType )MarkSelectBtnType;//滚动


@end
@interface JGJMarkBillCommonHeaderView : UIView

@property (strong, nonatomic) IBOutlet UIButton *tinyButton;

@property (strong, nonatomic) IBOutlet UIButton *contractBtn;

@property (strong, nonatomic) IBOutlet UIButton *brrowBtn;

@property (strong, nonatomic) IBOutlet UIButton *closeAccountBt;

@property (assign, nonatomic) JGJMarkSelectBtnType markBillClicKType;

@property (strong, nonatomic) UIImageView *arrowUpImageView;

@property (strong, nonatomic) id <JGJMarkBillCommonHeaderViewDelegate> delegate;

- (void)setBtnStateFromBtnTag:(NSUInteger)tag;
@end
