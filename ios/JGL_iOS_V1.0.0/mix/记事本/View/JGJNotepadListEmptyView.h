//
//  JGJNotepadListEmptyView.h
//  mix
//
//  Created by Tony on 2018/4/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJNotepadListEmptyView : UIView

@property (nonatomic, strong) UILabel *recordLabel;
- (void)setEmptyImage:(NSString *)imageStr emptyText:(NSString *)emptyText;
@end
