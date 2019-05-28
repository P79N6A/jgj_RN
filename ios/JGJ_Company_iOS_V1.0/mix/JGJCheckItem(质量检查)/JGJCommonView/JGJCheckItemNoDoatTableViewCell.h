//
//  JGJCheckItemNoDoatTableViewCell.h
//  JGJCompany
//
//  Created by Tony on 2017/12/4.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCheckItemNoDoatTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (nonatomic ,strong)NSString *Content;
@end
