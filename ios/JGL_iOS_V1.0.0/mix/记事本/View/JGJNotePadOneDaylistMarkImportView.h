//
//  JGJNotePadOneDaylistMarkImportView.h
//  mix
//
//  Created by Tony on 2019/1/10.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^markNoteImportWithIs_Import)(BOOL is_import);
@interface JGJNotePadOneDaylistMarkImportView : UIView

@property (nonatomic, copy) markNoteImportWithIs_Import markImport;
@property (nonatomic, assign) BOOL is_import;
@end
