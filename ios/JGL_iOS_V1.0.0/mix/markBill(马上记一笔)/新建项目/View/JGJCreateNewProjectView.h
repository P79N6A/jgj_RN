//
//  JGJCreateNewProjectView.h
//  mix
//
//  Created by Tony on 2018/6/4.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TYTextField.h"

typedef void(^CreateNewProject)(NSString *pro_name);
@interface JGJCreateNewProjectView : UIView

@property (nonatomic, strong) LengthLimitTextField *inputContent;
@property (nonatomic, copy) CreateNewProject createProject;
@end
