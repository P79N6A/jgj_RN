//
//  JGJWorkReprotMustTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/5/22.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol needCoordinateWorkdelegate <NSObject>
-(void)endeditingneedCoordinateWork:(NSString *)text;
@end
@interface JGJWorkReprotMustTableViewCell : UITableViewCell
<
UITextViewDelegate
>
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *placeLable;
@property (strong, nonatomic) IBOutlet UITextView *textview;
@property (strong, nonatomic)  id <needCoordinateWorkdelegate> delegate;

@end
