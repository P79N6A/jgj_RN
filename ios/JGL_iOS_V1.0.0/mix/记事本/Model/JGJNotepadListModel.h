//
//  JGJNotepadListModel.h
//  mix
//
//  Created by Tony on 2018/4/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJNotepadListModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *publish_time;

@property (nonatomic, copy) NSString *weekday;

@property (nonatomic, assign) NSInteger noteId;

@property (nonatomic, copy) NSArray *images;

//当前是否标记重要
@property (nonatomic, assign) BOOL is_import;

@property (nonatomic, assign) CGFloat row_height;

@end
