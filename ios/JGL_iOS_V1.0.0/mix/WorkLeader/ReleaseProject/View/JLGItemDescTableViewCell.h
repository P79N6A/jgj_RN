//
//  JLGItemDescTableViewCell.h
//  mix
//
//  Created by jizhi on 15/11/21.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemDescEndEditingBlock)(NSString *detailTFStr);
typedef void(^ItemDescBeginEditingBlock)();
@interface JLGItemDescTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *detailTF;
- (void )endEditWithBlock:(ItemDescEndEditingBlock )block;
- (void )beginEditWithBlock:(ItemDescBeginEditingBlock )block;
@end
