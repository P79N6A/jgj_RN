//
//  JGJMemberMangerModel.m
//  mix
//
//  Created by yj on 2018/4/19.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMemberMangerModel.h"

#import "JGJMemberImpressTagView.h"

#import "YYText.h"

@implementation JGJMemberImpressTagViewModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"tagId" : @"id"};
    
}

- (NSString *)tag_name {
    
    NSString *tagName = [NSString stringWithFormat:@"%@ %@", _tag_name,_num?:@""];
    
    if (self.tagViewType == JGJMemberImpressSelTagViewType) {
        
        tagName = [NSString stringWithFormat:@"%@", _tag_name];
    }

    return [NSString isEmpty:tagName] ? @"" : tagName;
}

@end

@implementation JGJMemberAppraiseStarsModel

@end

@implementation JGJMemberMangerModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"tag_list" : @"JGJMemberImpressTagViewModel"};
}

@end

@implementation JGJMemberEvaListModel

- (CGFloat)tagHeight {
    
    if (_tagHeight > 0) {
        
        return _tagHeight;
    }

    _tagHeight = self.tagView.height;
    
    return _tagHeight;
}

- (JGJMemberImpressTagView *)tagView {
    
    if (!_tagView) {
        
        _tagView = [[JGJMemberImpressTagView alloc] init];
        
        _tagView = [_tagView tagViewWithTags:self.tag_list tagViewType:JGJMemberImpressShowTagViewType];
    }
    
    return _tagView;
}

-(NSMutableAttributedString *)attContentStr {
    
    if (!_attContentStr) {
        
        _attContentStr = [[NSMutableAttributedString alloc] initWithString:self.content];
        
        _attContentStr.yy_lineSpacing = 2.0;
        
        _attContentStr.yy_font = [UIFont systemFontOfSize:AppFont28Size];
        
        _attContentStr.yy_color = AppFont333333Color;
    }
    
    return _attContentStr;
}

- (CGFloat)cellHeight {

    YYTextContainer  *contentContarer = [YYTextContainer new];
    
    //限制宽度
    contentContarer.size = CGSizeMake(TYGetUIScreenWidth - 20, CGFLOAT_MAX);
    
    if ([NSString isEmpty:self.content]) {
        
        self.content = @"";
    }
    
    NSMutableAttributedString  *contentAttr = [self getAttr:self.content];
    
    contentAttr.yy_lineSpacing = 2.0;
    
    YYTextLayout *contentLayout = [YYTextLayout layoutWithContainer:contentContarer text:contentAttr];
    
    CGFloat contentHeight = contentLayout.textBoundingSize.height;
    
    CGFloat offsetY = 55 + 15  + 5; //固定偏差高度
    
    _cellHeight = offsetY + self.tagHeight + contentHeight;
    
    return _cellHeight;
}

- (NSMutableAttributedString*)getAttr:(NSString*)attributedString {
    
    NSMutableAttributedString * resultAttr = [[NSMutableAttributedString alloc] initWithString:attributedString];
    
    resultAttr.yy_font = [UIFont systemFontOfSize:AppFont28Size];

    return resultAttr;
    
}

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"tag_list" : @"JGJMemberImpressTagViewModel"};
}

@end

@implementation JGJMemberEvaluateInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"tag_list" : @"JGJMemberImpressTagViewModel"};
}

@end


@implementation JGJWorkdayGetRecordConfirmOffStatusModel


@end
