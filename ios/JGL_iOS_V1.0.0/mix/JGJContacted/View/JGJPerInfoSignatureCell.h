//
//  JGJPerInfoSignatureCell.h
//  mix
//
//  Created by Json on 2019/3/29.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJPerInfoSignatureCell : UITableViewCell
/** 个性签名 */
@property (nonatomic, copy) NSString *signature;
/** 是否显示箭头 */
@property (nonatomic, assign) BOOL showArrow;
+ (CGFloat)heightWithSignature:(NSString *)signature;
@end
