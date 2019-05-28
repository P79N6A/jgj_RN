//
//  JGJNewHomeVCTopView.h
//  mix
//
//  Created by Tony on 2019/3/4.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitIdentityBlock)(void);
typedef void(^MakeANewNoteBlock)(void);
typedef void(^LeftChoiceTimeBtnBlock)(void);
typedef void(^RightChoiceTimeBtnBlock)(void);
typedef void(^TimeLabelChoiceBlock)(void);
@interface JGJNewHomeVCTopView : UIView

@property (nonatomic, copy) SwitIdentityBlock switIdentityBlock;
@property (nonatomic, copy) MakeANewNoteBlock makeANewNoteBlock;
@property (nonatomic, copy) LeftChoiceTimeBtnBlock leftChoiceTimeBtnBlock;
@property (nonatomic, copy) RightChoiceTimeBtnBlock rightChoiceTimeBtnBlock;
@property (nonatomic, copy) TimeLabelChoiceBlock timeLabelChoiceBlock;

@property (nonatomic, strong) UILabel *dateLabel;// 时间显示
@property (nonatomic, strong) UIButton *rightChangeBtn;

//更新顶部信息

-(void)updateTopView;

@end
