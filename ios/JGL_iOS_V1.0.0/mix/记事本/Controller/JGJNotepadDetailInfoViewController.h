//
//  JGJNotepadEditeViewController.h
//  mix
//
//  Created by Tony on 2018/4/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLGAddProExperienceViewController.h"
#import "JGJNotepadListModel.h"

typedef void(^NoteModifyStatusSuccessBlock)(id);

@interface JGJNotepadDetailInfoViewController : JLGAddProExperienceViewController

@property (nonatomic, strong) JGJNotepadListModel *noteModel;

@property (nonatomic ,copy) NoteModifyStatusSuccessBlock noteModifyStatusSuccessBlock;

@end
