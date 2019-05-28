//
//  JGJTouchLabel.m
//  JGJCompany
//
//  Created by Tony on 2016/10/28.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJTouchLabel.h"

@implementation JGJTouchLabel

-(void)awakeFromNib {
    
    [super awakeFromNib];
//    [self attachTapHandler];
}

- (void)tapLinkActionWithHighlight:(YYTextHighlight *)highlight tapLinkUrlRange:(NSRange)highlightRange  {
    
    if (highlight.tapAction && ![NSString isEmpty:self.text]) {
        
        NSString *url = [self.text substringWithRange:highlightRange];
        
        if (![NSString isEmpty:url]) {
            
            NSMutableAttributedString *attriUrl = [[NSMutableAttributedString alloc] initWithString:url];
            
            highlight.tapAction(self, attriUrl, highlightRange, CGRectZero);
        }
        
    }
}

@end
