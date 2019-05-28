//
//  JGJWageLevelInputAmountCell.h
//  mix
//
//  Created by ccclear on 2019/4/15.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTextField.h"
#import "JGJCusTextField.h"
@interface JGJWageLevelInputAmountCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet JGJCusTextField *inputTextField;
@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;


@end

