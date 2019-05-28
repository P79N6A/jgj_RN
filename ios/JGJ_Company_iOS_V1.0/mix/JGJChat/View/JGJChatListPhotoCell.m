//
//  JGJChatListPhotoCell.m
//  mix
//
//  Created by Tony on 2016/8/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatListPhotoCell.h"
#import "UIImageView+WebCache.h"

@interface JGJChatListPhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic,strong) NSIndexPath *indexPath;
@end

@implementation JGJChatListPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.userInteractionEnabled = YES;
    //添加单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.imageView addGestureRecognizer:singleTap];
}


- (void)setIndex:(NSIndexPath *)indexPath image:(id)image{

    self.indexPath = indexPath;

    if ([image isKindOfClass:[UIImage class]]) {
        self.imageView.image = image;
        return;
    }
    
    NSURL *imgUrl = [NSURL new];
    if([image isKindOfClass:[NSString class]]){
        imgUrl = [NSURL URLWithString:[JLGHttpRequest_IP stringByAppendingString:image]];
    }else if([image isKindOfClass:[NSURL class]]){
        imgUrl = image;
    }

    [self.imageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"defaultPic"]];
}
#pragma mark - 单击手势
- (void)singleTap:(id)sender
{
    if (self.didSelectedPhotoBlock) {
        self.didSelectedPhotoBlock(self,self.imageView.image);
    }
}

@end
