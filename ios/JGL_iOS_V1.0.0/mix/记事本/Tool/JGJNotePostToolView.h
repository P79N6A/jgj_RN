//
//  JGJNotePostToolView.h
//  mix
//
//  Created by yj on 2019/1/9.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    JGJNotePostMarkImportButtonType, //标记重要
    
    JGJNotePostMarkPhotoButtonType,  //拍照
    
} JGJNotePostToolViewButtonType;

@class JGJNotePostToolView;

@protocol JGJNotePostToolViewDelegate <NSObject>

- (void)notePostToolView:(JGJNotePostToolView *)toolView buttonType:(JGJNotePostToolViewButtonType)buttonType button:(UIButton *)button;

@end

NS_ASSUME_NONNULL_BEGIN

@interface JGJNotePostToolView : UIView

@property (nonatomic, weak) id <JGJNotePostToolViewDelegate> delegate;

@property (weak, nonatomic,readonly) IBOutlet UIButton *markButton;

@property (weak, nonatomic,readonly) IBOutlet UIButton *photoButton;

+ (CGFloat)toolViewHeight;

@end

NS_ASSUME_NONNULL_END
