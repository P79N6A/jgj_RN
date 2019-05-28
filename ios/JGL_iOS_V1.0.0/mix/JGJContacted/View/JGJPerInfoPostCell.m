//
//  JGJPerInfoPostCell.m
//  JGJCompany
//
//  Created by yj on 2017/8/15.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPerInfoPostCell.h"

#import "JGJPerInfoPostView.h"

#import "NSString+Extend.h"

@interface JGJPerInfoPostCell ()

//他的帖子
@property (weak, nonatomic) IBOutlet UILabel *postLable;

@property (weak, nonatomic) IBOutlet JGJPerInfoPostView *postView;

@property (weak, nonatomic) IBOutlet UILabel *postContentLable;
@end

@implementation JGJPerInfoPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.postLable.textColor = AppFont333333Color;
    
    self.postContentLable.textColor = AppFont333333Color;
    
    self.postContentLable.preferredMaxLayoutWidth = [JGJPerInfoPostCell postCellMaxLayoutWidth];
}

+ (CGFloat)postCellMaxLayoutWidth {

    return TYGetUIScreenWidth - 121;
}

+ (CGFloat)postCellMaxRowHeight {

    //3行文字高度
    return 3 * 19;
}

- (void)setPerInfoModel:(JGJChatPerInfoModel *)perInfoModel {

    _perInfoModel = perInfoModel;
    
    
    self.postView.hidden = perInfoModel.pic_src.count == 0;
    
    self.postContentLable.text = perInfoModel.content;
    
    self.postContentLable.hidden = YES;
    
    if (perInfoModel.pic_src.count == 0 && ![NSString isEmpty:perInfoModel.content]) {
        
        self.postContentLable.text = perInfoModel.content;
        
        self.postContentLable.hidden = NO;
    }
    
    if (perInfoModel.pic_src.count > 0) {
        
        [self.postView perInfoPostViewWithPics:perInfoModel.pic_src padding:10];
    }
    
    NSString *myUid = [TYUserDefaults objectForKey:JLGUserUid];
    
    if ([self.perInfoModel.uid isEqualToString:myUid]) {
        
        self.postLable.text = @"我的贴子";
        
    }else {
        
        self.postLable.text = @"他的贴子";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
