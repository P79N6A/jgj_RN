//
//  JLGRegisterInfoTableViewCell.h
//  mix
//
//  Created by jizhi on 15/11/17.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^endEditingBlock)(NSIndexPath *indexPath,NSString *detailTFStr);
typedef void(^beginEditingBlock)();
typedef void(^ReturnBlock)(NSIndexPath *indexPath);
@interface JLGRegisterInfoTableViewCell : UITableViewCell

@property (strong,nonatomic) NSIndexPath *indexPath;
@property (assign,nonatomic) BOOL onlyNum;//只能输入数字
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailTF;

- (void )endEditWithBlock:(endEditingBlock )block;
- (void )beginEditWithBlock:(beginEditingBlock )block;
- (void )returnWithBlock:(ReturnBlock )block;
@end
