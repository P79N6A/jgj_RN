//
//  JGJQuickCreatChatModel.m
//  mix
//
//  Created by yj on 2018/12/12.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJQuickCreatChatModel.h"

@implementation JGJQuickCreatChatHeaderViewModel


@end

@implementation JGJQuickCreatChatListModel


MJExtensionCodingImplementation
@end

@implementation JGJQuickCreatChatModel

+(NSDictionary *)mj_objectClassInArray {
    
    return @{@"local_list" : @"JGJQuickCreatChatListModel" , @"work_list" : @"JGJQuickCreatChatListModel"};
}

- (NSMutableArray *)headerModels {
    
    if (!_headerModels) {

        _headerModels = [[NSMutableArray alloc] init];
        
        NSArray *titles = @[@"快速加群",@"快速加入工种群"];
        
        NSArray *desInfos = @[@"",@""];
        
        NSArray *icons = @[@"creat_chat_local_icon",@"creat_chat_worktype_icon"];
        
        NSArray *remarks = @[@"（只能加一个地方工友群）",@"（只能加一个工种群）"];

        NSArray *titleColors = @[AppFontE2800CColor,AppFont2584EFColor];
        
        if (self.local_list.count > 0 && self.work_list.count > 0) {
            
            titles = @[@"快速加群",@"快速加入工种群"];
            
            desInfos = @[@"",@""];
            
            icons = @[@"creat_chat_local_icon",@"creat_chat_worktype_icon"];
            
            remarks = @[@"（只能加一个地方工友群）",@"（只能加一个工种群）"];
            
            titleColors = @[AppFontE2800CColor,AppFont2584EFColor];
            
        }else if (self.local_list.count > 0 && self.work_list.count == 0) {
            
            titles = @[@"快速加群"];
            
            desInfos = @[@""];
            
            icons = @[@"creat_chat_local_icon"];
            
            remarks = @[@"（只能加一个地方工友群）"];
            
            titleColors = @[AppFontE2800CColor];
            
        }else if (self.local_list.count == 0 && self.work_list.count > 0) {
            
            titles = @[@"快速加入工种群"];
            
            desInfos = @[@""];
            
            icons = @[@"creat_chat_worktype_icon"];
            
            remarks = @[@"（只能加一个工种群）"];
            
            titleColors = @[AppFont2584EFColor];
            
        }else if (self.local_list.count == 0 && self.work_list.count == 0) {
            
            titles = @[];
            
            desInfos = @[];
            
            icons = @[];
            
            remarks = @[];
            
            titleColors = @[];
        }
        
        for (NSInteger indx = 0; indx < titles.count; indx++) {
            
            JGJQuickCreatChatHeaderViewModel *headerModel = [JGJQuickCreatChatHeaderViewModel new];
            
            headerModel.title = titles[indx];
            
            headerModel.icon = icons[indx];
            
            headerModel.des = desInfos[indx];
            
            headerModel.remark = remarks[indx];
            
            headerModel.titleColor = titleColors[indx];
            
            [_headerModels addObject:headerModel];
            
        }
        
    }
    
    return _headerModels;
}

@end

