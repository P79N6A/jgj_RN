//
//  JGJNotepadListCell.h
//  mix
//
//  Created by Tony on 2018/4/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJNotepadListModel.h"

typedef void(^markNoteImportWithNoteModel)(JGJNotepadListModel *noteModel,NSIndexPath *indexPath);
@interface JGJNotepadListCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) JGJNotepadListModel *noteModel;
@property (nonatomic, copy) NSString *searchKey;

@property (nonatomic, copy) markNoteImportWithNoteModel markNoteImportWithNoteModel;
// 是否从每日记事本列表进入
@property (nonatomic, assign) BOOL isOneDayComing;

- (void)setImageViewListwWithNoteModel:(JGJNotepadListModel *)noteModel;
@end
