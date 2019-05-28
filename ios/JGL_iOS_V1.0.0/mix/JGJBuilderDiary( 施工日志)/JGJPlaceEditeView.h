//
//  JGJPlaceEditeView.h
//  JGJCompany
//
//  Created by Tony on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol editeDelegate <NSObject>
- (void)clickEditeButton;
- (void)clickdeleteButton;
- (void)clickcancelButton;
@end
@interface JGJPlaceEditeView : UIView
@property (strong, nonatomic) IBOutlet UIButton *editeButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIView *placeView;
//@property (strong, nonatomic) UIView *holdView;
@property (strong, nonatomic) id <editeDelegate> delegate;
@property (strong, nonatomic) UIView *XibView;

-(void)ShowviewWithVC;
-(void)reomoveView;

@end
