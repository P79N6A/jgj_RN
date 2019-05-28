//
//  JGJChatMsgListModel.m
//  mix
//
//  Created by Tony on 2016/8/31.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatMsgListModel.h"
#import "NSObject+MJCoding.h"
#import "TYUIImage.h"
#import "NSDate+Extend.h"
#import "NSString+Extend.h"
#import "NSString+File.h"
#import "AudioRecordingServices.h"
#import "JGJChatListBaseCell.h"
#import "JGJImage.h"

#import "YYText.h"

NSString *const chatMsgTimeFormat = @"yyyy-MM-dd HH:mm:ss";

@implementation JGJChatOtherMsgListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [JGJChatMsgListModel class]};
}
@end

@interface JGJChatMsgListModel ()

@end

@implementation JGJChatMsgListModel
@synthesize msg_type = _msg_type;
@synthesize voice_long = _voice_long;

+ (NSDictionary *)objectClassInArray{
    return @{@"read_info" : [ChatMsgList_Read_info class]};
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _token = [NSString isEmpty:[TYUserDefaults objectForKey:JLGPhone]]?@"":[TYUserDefaults objectForKey:JLGPhone];
    }

    return self;
}

- (void)setMsg_type:(NSString *)msg_type{
    _msg_type = msg_type;
    
    if ([_msg_type isEqualToString:@"text"]) {
        self.chatListType = JGJChatListText;
    }else if([_msg_type isEqualToString:@"voice"]){
        self.chatListType = JGJChatListAudio;
    }else if([_msg_type isEqualToString:@"notice"]){
        self.chatListType = JGJChatListNotice;
    }else if([_msg_type isEqualToString:@"safe"]){
        self.chatListType = JGJChatListSafe;
    }else if([_msg_type isEqualToString:@"quality"]){
        self.chatListType = JGJChatListQuality;
    }else if([_msg_type isEqualToString:@"memberJoin"]){
        self.chatListType = JGJChatListMemberJoin;
    }else if([_msg_type isEqualToString:@"billRecord"]){
        self.chatListType = JGJChatListRecord;
    }else if([_msg_type isEqualToString:@"log"]){
        self.chatListType = JGJChatListLog;
    }else if([_msg_type isEqualToString:@"signIn"]){
        self.chatListType = JGJChatListSign;
    }else if([_msg_type isEqualToString:@"recall"]){
        self.chatListType = JGJChatListRecall;
    }else if([_msg_type isEqualToString:@"pic"]){
        self.chatListType = JGJChatListPic;
    }else if([_msg_type isEqualToString:@"proDetail"]){
        self.chatListType = JGJChatListProDetailType;
    }else if ([_msg_type isEqualToString:@"addGroupFriend"]) {
        self.chatListType = JGJChatListAddGroupFriendType;
    }
    //特殊类型 memberJoin、sign_id非空为签到
    if([_msg_type isEqualToString:@"memberJoin"] && ![NSString isEmpty:self.sign_id]){
        self.chatListType = JGJChatListSign;
    }
}
- (NSString *)msg_type{
    if (_msg_type) {
        return  _msg_type;
    }
    
    //如果没有就通过listType转换
    if (self.chatListType == JGJChatListText) {
        _msg_type = @"text";
    }else if(self.chatListType == JGJChatListAudio){
        _msg_type = @"voice";
    }else if(self.chatListType == JGJChatListNotice){
        _msg_type = @"notice";
    }else if(self.chatListType == JGJChatListSafe){
        _msg_type = @"safe";
    }else if(self.chatListType == JGJChatListQuality){
        _msg_type = @"quality";
    }else if(self.chatListType == JGJChatListMemberJoin){
        _msg_type = @"memberJoin";
    }else if(self.chatListType == JGJChatListRecord){
        _msg_type = @"billRecord";
    }else if(self.chatListType == JGJChatListLog){
        _msg_type = @"log";
    }else if(self.chatListType == JGJChatListSign){
        _msg_type = @"signIn";
    }else if(self.chatListType == JGJChatListRecall){
        _msg_type = @"recall";
    }else if(self.chatListType == JGJChatListPic){
        _msg_type = @"pic";
    }
    return _msg_type;
}

- (BOOL)isDefaultText{
    if(self.chatListType == JGJChatListMemberJoin || self.chatListType == JGJChatListRecall || self.chatListType == JGJChatListAddGroupFriendType || self.chatListType == JGJChatListSign ){
        return YES;
    }else{
        return NO;
    }
    
}

- (JGJChatListBelongType )belongType{
    if (_belongType) {
        return _belongType;
    }
    
    if (self.read_info) {
        return JGJChatListBelongMine;
    }else {
        return [self.is_out_member boolValue]?JGJChatListBelongGroupOut:JGJChatListBelongOther;
    }
}

- (NSString *)head_pic{
    return _head_pic?:@"";
}


- (void)setDate:(NSString *)date{
    _date = date;
    NSDate *converntDate = [NSDate dateFromString:self.date withDateFormat:chatMsgTimeFormat];
    if ([converntDate isToday]) {
        _displayDate = [self.date substringWithRange:NSMakeRange(11, 5)];
    }else{
        _displayDate = [self.date substringWithRange:NSMakeRange(5, 5)];
    }
    
}

- (void)setMsg_src:(NSArray<NSString *> *)msg_src{
    _msg_src = msg_src;
    
    //如果只有一个元素并且含有.amr的字符串就表明是amr文件
    if (msg_src.count == 1 && [msg_src[0] containsString:@".amr"]) {
        
        //如果没有wav的文件才下载
        if ([NSString isEmpty:_voice_filePath]) {
            [JLGHttpRequest_AFN downloadWithUrl:msg_src[0] success:^(NSString *fileURL,NSString *fileName) {
                AudioRecordingServices *audioRecordingServices = [AudioRecordingServices new];
                NSDictionary *dic = [audioRecordingServices decompressionAudioFileWith:fileURL fileName:fileName];
                [NSString removeFileByPath:fileURL];
                
                _voice_filePath = dic[@"filePath"];
                
                [TYNotificationCenter postNotificationName:JGJChatListDownVoiceSuccess object:self];
            } fail:^{
                TYLog(@"下载失败");
            }];
        }
    }
}
- (void)setPicImage:(UIImage *)picImage{
    NSData *data=UIImageJPEGRepresentation(picImage, 1.0);
    
    if (data.length>100*1024) {//如果图片大于100k就转换
        NSData *picData = [TYUIImage imageData:picImage];
        _picImage = [UIImage imageWithData:picData];
    }else{
        _picImage = picImage;
    }
}
#define ProDetailContentViewH 215

#define ProDetailTopViewH 80

#define ProDetailBottomViewH 90

#define ProDetailMemberDesH 21

#define ChatBottomPadding 23
- (CGFloat)cellHeight {
    
    CGFloat height = 0.0;
    
    
    if (![NSString isFloatZero:_cellHeight]) {
        
        return _cellHeight;
    }
    
    if (self.chatListType == JGJChatListRecord) {
        
        return CGFLOAT_MIN;
    }
    
    //项目信息高度
    if (self.chatListType == JGJChatListProDetailType) {
        
        height = ProDetailContentViewH;
        if (!self.msg_prodetail.prodetailactive && self.msg_prodetail.searchuser) {
            
            height -= ProDetailTopViewH;
        }else if (!self.msg_prodetail.searchuser && self.msg_prodetail.prodetailactive) {
            
            height -= ProDetailBottomViewH;
            if ([NSString isEmpty:self.msg_prodetail.searchuser.title]) {
                
                height -= ProDetailMemberDesH;
            }
        }else if (!self.msg_prodetail.searchuser && !self.msg_prodetail.prodetailactive) {
            
            height = 0;
        }
        return height;
    }
    
    // 得到语音高度
    
    if (self.chatListType == JGJChatListAudio) {
        
        return [self getAudioCellHeightWithChatListModel:self];
    }
    
    
    if (self.isDefaultText) {
        
        height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 52 content:self.msg_text font:AppFont24Size] + ChatBottomPadding;
        
        return height;
        
    }else if (self.belongType == JGJChatListBelongMine) {
        if (self.chatListType == JGJChatListPic) {
            
            height = self.imageSize.height + 33;
            
        }else{
            
            height = [self getCellHeightWithChatListModel:self];
            
        }
    }else{
        if (self.chatListType == JGJChatListPic) {
            
            height = self.imageSize.height + 33;
            
        }else{
            height = [self getCellHeightWithChatListModel:self];
        }
    }
    _cellHeight = height;
    return _cellHeight;
}


- (CGFloat)getAudioCellHeightWithChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    CGFloat height = 0.0;
    
    if (self.chatListType == JGJChatListAudio) {
        
        height = 71;
        
    }
    
    return height;
    
}

- (CGFloat)getCellHeightWithChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    CGFloat height = 67;
    
    //仅有文字
    height = [self getMsgHeightWithChatListModel:chatListModel] + 30  + ChatBottomPadding;

    height = (height < 67 ? 67 : height);
    
    //得到质量安全等高度
    
    if (chatListModel.chatListType == JGJChatListNotice || chatListModel.chatListType == JGJChatListSafe || chatListModel.chatListType == JGJChatListLog || chatListModel.chatListType == JGJChatListSign ||chatListModel.chatListType == JGJChatListQuality || self.msg_src.count > 0) {
        
        height = [self getMultipleSelImageWithChatListModel:chatListModel];
        
    }
    
    return height;
    
}

#pragma mark - 获取消息高度
- (CGFloat)getMsgHeightWithChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    CGFloat maxW =  TYIS_IPHONE_5_OR_LESS?202:(TYIS_IPHONE_6 || TYIST_IPHONE_X ? 220 : 260);
    
    YYTextContainer  *contentContarer = [YYTextContainer new];
    
    //限制宽度
    contentContarer.size = CGSizeMake(maxW, CGFLOAT_MAX);
    
    if ([NSString isEmpty:chatListModel.msg_text]) {
        
        chatListModel.msg_text = @"";
    }
    
    NSMutableAttributedString  *contentAttr = [self getAttr:chatListModel.msg_text];
    
    contentAttr.yy_lineSpacing = 4.0;
    
    YYTextLayout *contentLayout = [YYTextLayout layoutWithContainer:contentContarer text:contentAttr];
    
    CGFloat height = contentLayout.textBoundingSize.height;
    
    return height;
}

- (CGFloat)getMultipleSelImageWithChatListModel:(JGJChatMsgListModel *)chatListModel {
    
    CGFloat padding = 60 + 40;
    
    CGFloat height = padding; //上下距离
    
    CGFloat contentMaxW = TYIS_IPHONE_5_OR_LESS?202:(TYIS_IPHONE_6 || TYIST_IPHONE_X ? 220 : 260);
    
    if (chatListModel.msg_src.count == 1) {
        
        height = contentMaxW + padding;
        
        if (self.belongType != JGJChatListBelongMine) {
            
            height += 3;
        }
        
    }else if (chatListModel.msg_src.count > 1) {
        
        //2张以上的图片
        CGFloat ImageWH = (contentMaxW - kChatListCollectionCellMargin*4.0) / 3.0;
        
        NSInteger rowNum = (chatListModel.msg_src.count - 1) / 3 + 1;
        
        height = rowNum*(ImageWH + kChatListCollectionCellMargin);
        
        height += padding;
    }
    
    if (![NSString isEmpty:self.msg_text]) {
        
//        CGFloat msgTextHeight = [NSString stringWithContentWidth:contentMaxW content:self.msg_text font:AppFont32Size];
//        
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"Some Text"];
//        
//        text.yy_font = [UIFont systemFontOfSize:AppFont32Size];

        
        YYTextContainer  *contentContarer = [YYTextContainer new];
        
        //限制宽度
        contentContarer.size = CGSizeMake(contentMaxW, CGFLOAT_MAX);
        
        contentContarer.maximumNumberOfRows = 0;
        
        NSMutableAttributedString  *contentAttr = [self getAttr:self.msg_text];
        
        YYTextLayout *contentLayout = [YYTextLayout layoutWithContainer:contentContarer text:contentAttr];
        
        CGFloat msgTextHeight = contentLayout.textBoundingSize.height;
        
        height += msgTextHeight > 25 ? 55 : 25;
        
    }
    
    return height;
    
}

- (NSMutableAttributedString*)getAttr:(NSString*)attributedString {
    NSMutableAttributedString * resultAttr = [[NSMutableAttributedString alloc] initWithString:attributedString];
    
    //对齐方式 这里是 两边对齐
//    resultAttr.yy_alignment = NSTextAlignmentJustified;
    //设置行间距
//    resultAttr.yy_lineSpacing = 2;
    //设置字体大小
    resultAttr.yy_font = [UIFont systemFontOfSize:AppFont32Size];
    //可以设置某段字体的大小
    //[resultAttr yy_setFont:[UIFont boldSystemFontOfSize:CONTENT_FONT_SIZE] range:NSMakeRange(0, 3)];
    //设置字间距
    //resultAttr.yy_kern = [NSNumber numberWithFloat:1.0];
    
    return resultAttr;
    
}

- (CGSize)imageSize {
    
    _imageSize = CGSizeMake(195, 187);
    if (self.pic_w_h.count == 2) {
        
        CGFloat imageH  = [[self.pic_w_h firstObject] floatValue];
        CGFloat imageW = [[self.pic_w_h lastObject] floatValue];
        _imageSize = CGSizeMake(imageW, imageH);
        
        _imageSize = [JGJImage getFitImageSize:self.pic_w_h maxImageSize:CGSizeMake(195, 187)];
    }
    
    return _imageSize;
}

@end

@implementation ChatMsgList_Read_info

+ (NSDictionary *)objectClassInArray{
    return @{@"unread_user_list" : [ChatMsgList_Read_User_List class], @"readed_user_list" : [ChatMsgList_Read_User_List class]};
}

@end


@implementation ChatMsgList_Read_User_List

- (UIColor *)nameColor {
    
    if (!_nameColor) {
        NSArray *colorArray = @[TYColorHex(0xf4b860),TYColorHex(0xf19937),TYColorHex(0x5ea3f8),TYColorHex(0xc48fe1),TYColorHex(0xeb6e48)];
        NSInteger index = arc4random() % 5;
        _nameColor = colorArray[index];
    }
    return _nameColor;
}

@end




