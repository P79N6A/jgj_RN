//
//  JGJNotepadListModel.m
//  mix
//
//  Created by Tony on 2018/4/20.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJNotepadListModel.h"

@implementation JGJNotepadListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"noteId":@"id"};
}

- (CGFloat)row_height {
    
    CGFloat total_height = 25;
    
    CGFloat contentHeight = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 40, CGFLOAT_MAX) content:self.content font:16].height + 5;
    
    UIFont *font = [UIFont systemFontOfSize:AppFont32Size];
    if (contentHeight > 5 * font.lineHeight) {
        
        total_height = total_height + 5 * font.lineHeight + 10;
        
    }else {
        
        total_height = total_height + contentHeight;
    }
    
    
    if (self.images.count > 0) {
        
        total_height = total_height + 10 + (TYGetUIScreenWidth - 70) / 4;
    }
    
    total_height = total_height + 25;
    
    return total_height;
}

@end
