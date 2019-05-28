//
//  JLGBuildAreaTableViewCell.h
//  mix
//
//  Created by jizhi on 15/12/2.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTextField.h"

typedef void(^BuildAreaEndEditingBlock)(NSString *detailTFStr);
typedef void(^BuildAreaBeginEditingBlock)();
typedef void(^BuildAreaReturnBlock)(NSIndexPath *indexPath);

@interface JLGBuildAreaTableViewCell : UITableViewCell

@property (strong,nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet LengthLimitTextField *detailTF;
@property (weak, nonatomic) IBOutlet UILabel *squareLabel;

- (void )endEditWithBlock:(BuildAreaEndEditingBlock )block;
- (void )beginEditWithBlock:(BuildAreaBeginEditingBlock )block;
- (void )returnWithBlock:(BuildAreaReturnBlock )block;
@end
