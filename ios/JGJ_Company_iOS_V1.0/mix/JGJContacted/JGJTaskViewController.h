//
//  JGJTaskViewController.h
//  JGJCompany
//
//  Created by Tony on 2017/6/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJDetailViewController.h"
typedef NS_ENUM(NSInteger ,editeTaskType) {
  editePrincipalType,
  editeJoinType,

};
typedef NS_ENUM(NSInteger ,buttonTaskType) {
   clickPrincipalType,
   clickJoinType,
    
};

@interface JGJTaskViewController : JGJDetailViewController
@property(nonatomic, assign)editeTaskType taskType;
@property(nonatomic, assign)buttonTaskType buttonType;
-(void)upEditeTaskPersonAndUID:(NSMutableArray *)uidArr isPrincipal:(BOOL)principal;//编辑参与者和负责人
@end
