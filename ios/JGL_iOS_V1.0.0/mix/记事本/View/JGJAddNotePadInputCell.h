//
//  JGJAddNotePadInputCell.h
//  mix
//
//  Created by Tony on 2019/3/11.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
@protocol JGJAddNotePadInputCellDelegate <NSObject>

@optional
- (void)inputContentViewInputWithText:(NSString *)content;

@end
@interface JGJAddNotePadInputCell : UITableViewCell

@property (nonatomic, weak) id<JGJAddNotePadInputCellDelegate> delegate;

@property (nonatomic, strong) YYTextView *inputContentView;
@end
