//
//  JGJAddNewNotepadViewController.h
//  mix
//
//  Created by Tony on 2018/4/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJNotepadListModel.h"
#import "UIPhotoViewController.h"
#import "JGJNotepadDetailInfoViewController.h"
@interface JGJAddNewNotepadViewController : JLGAddProExperienceViewController

@property (nonatomic, assign) BOOL isEditeNotepad;
@property (nonatomic, strong) JGJNotepadListModel *noteModel;
@property (nonatomic, strong) UIViewController *tagVC;
@property (nonatomic, strong) NSMutableArray *orignalImgArr;
@end
