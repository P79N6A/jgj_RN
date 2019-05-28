//
//  JGJNewCreateProjectAlertView.h
//  mix
//
//  Created by Tony on 2019/2/20.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CancleBlock)(void);
typedef void(^AgreeBlock)(NSString *project_name,UIView *view);

@interface JGJNewCreateProjectAlertView : UIView

@property (nonatomic, copy) CancleBlock cancle;
@property (nonatomic, copy) AgreeBlock agree;

@property (nonatomic, copy) NSString *projectName;

- (void)show;
@end
