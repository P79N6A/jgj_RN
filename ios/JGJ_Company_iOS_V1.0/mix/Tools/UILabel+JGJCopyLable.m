//
//  UILabel+JGJCopyLable.m
//  JGJCompany
//
//  Created by Tony on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "UILabel+JGJCopyLable.h"
#import <CoreText/CoreText.h>

static NSString *linkPointskey = @"hyperlinks";
static NSMutableArray *_linkPoints;
static NSArray* matches;
static NSSet* lastTouches;

static NSString *JGJCopyLableActionAction_key = @"JGJCopyLableActionAction_key";


@implementation UILabel (JGJCopyLable)
-(void)canCopyWithlable:(UILabel *)lable
{
    UILongPressGestureRecognizer *longGusstrue = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(copyTexts:)];
    longGusstrue.minimumPressDuration = .2;
    self.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:longGusstrue];
}
-(void)copyTexts:(UIGestureRecognizer *)gesture
{
    if (UIGestureRecognizerStateBegan == gesture.state)
    {
    
        [self becomeFirstResponder];
        UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText)];
        NSMutableArray *itemarr = [NSMutableArray array];
        [itemarr addObject:item];
        [[UIMenuController sharedMenuController] setMenuItems:itemarr];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self                                                                                                                                                             ];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        
        if (self.copyLableActionBlock) {
            
            self.copyLableActionBlock();
            
        }
    }

}

-(void)copyText
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.text;
    
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(copyText)) {
        return YES;
    }
    return NO;
}
-(void)SetLinDepart:(NSInteger)distance
{
    if(self.text == nil || self.text.length == 0){
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:distance];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
    self.attributedText = attributedString;

}
- (void)creatInternetHyperlinks
{
    if ([NSString isEmpty: self.text ]) {
        
        return;
    }
    
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    matches = [detector matchesInString:self.text options:0 range:NSMakeRange(0, self.text.length)];
    [self highlightLinksWithIndex:NSNotFound];
    
    
}
- (void)highlightLinksWithIndex:(CFIndex)index {
    
    NSMutableAttributedString* attributedString = [self.attributedText mutableCopy];
    
    for (NSTextCheckingResult *match in matches) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            
            NSRange matchRange = [match range];
            
            if ([self isIndex:index inRange:matchRange]) {
                //                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:matchRange];
            }
            else {
                [attributedString addAttribute:NSForegroundColorAttributeName value:AppFont628ae0Color range:matchRange];
            }
            
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:matchRange];
        }
    }
    
    self.attributedText = attributedString;
}
- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range {
    return index > range.location && index < range.location+range.length;
}
/*
 -(void)creatInternetHyperlinks
 {
 
 NSString *pattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
 NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
 
 _linkPoints = [NSMutableArray array];
 [regular enumerateMatchesInString:self.text options:0 range:NSMakeRange(0, self.text.length)usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
 NSRange range = result.range;
 NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:self.text];
 //添加下划线，下划线默认颜色为对应范围字体的颜色
 [attribute addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleDouble) range:range];
 //重新设置属性文字的字体
 [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, self.text.length)];
 //特殊字符颜色
 [attribute addAttribute:NSForegroundColorAttributeName value:AppFonte8e8e8Color range:range];
 self.attributedText = attribute;
 
 //        _selectedRange = range;
 //        NSArray *arrays = [self selectionRectsForRange:_selectedTextRange];
 //        for (UITextSelectionRect *selectionRect in arrays) {
 //            CGRect rect = selectionRect.rect;
 //            if (rect.size.width> 0 && rect.size.height>0) {
 //                NSValue *rectValue = [NSValue valueWithCGRect:rect];
 //                [_linkPoints addObject: rectValue];
 //                NSLog(@"选中的链接的frame:%@",NSStringFromCGRect(rect));
 //            }
 //        }
 }];
 }*/


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    lastTouches = touches;
    
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    lastTouches = touches;
    
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    if ([NSString isEmpty: self.text ]) {
        
        return;
    }
    
    NSError *error = NULL;
    
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    
    matches = [detector matchesInString:self.text options:0 range:NSMakeRange(0, self.text.length)];
    
    [self highlightLinksWithIndex:NSNotFound];

    
    if (!lastTouches) {
        return;
    }
    
    lastTouches = nil;
    
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    for (NSTextCheckingResult *match in matches) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            
            NSRange matchRange = [match range];
            
            if ([self isIndex:index inRange:matchRange]) {
                
//                [[UIApplication sharedApplication] openURL:match.URL];
                NSMutableDictionary *urlDic = [NSMutableDictionary dictionary];
                if (!match.URL) {
                    return;
                }
                [urlDic setObject:match.URL forKey:@"url"];
                
                [TYNotificationCenter postNotificationName:JLGcontentOpenUrl object:urlDic];
                break;
            }
        }
    }
    
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!lastTouches) {
        return;
    }
    
    lastTouches = nil;
    
    UITouch *touch = [touches anyObject];
    
    
}

- (CFIndex)characterIndexAtPoint:(CGPoint)point {
    
    ////////
    
    NSMutableAttributedString* optimizedAttributedText = [self.attributedText mutableCopy];
    
    // use label's font and lineBreakMode properties in case the attributedText does not contain such attributes
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, [self.attributedText length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        if (!attrs[(NSString*)kCTFontAttributeName]) {
            
            [optimizedAttributedText addAttribute:(NSString*)kCTFontAttributeName value:self.font range:NSMakeRange(0, [self.attributedText length])];
        }
        
        if (!attrs[(NSString*)kCTParagraphStyleAttributeName]) {
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:self.lineBreakMode];
            
            [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        }
    }];
    
    // modify kCTLineBreakByTruncatingTail lineBreakMode to kCTLineBreakByWordWrapping
    [optimizedAttributedText enumerateAttribute:(NSString*)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, [optimizedAttributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        
        NSMutableParagraphStyle* paragraphStyle = [value mutableCopy];
        
        if ([paragraphStyle lineBreakMode] == kCTLineBreakByTruncatingTail) {
            [paragraphStyle setLineBreakMode:kCTLineBreakByWordWrapping];
        }
        
        [optimizedAttributedText removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range];
        [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
    }];
    
    ////////
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }
    
    CGRect textRect = [self textRect];
    
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    //////
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedText length]), path, NULL);
    
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    
    //NSLog(@"num lines: %d", numberOfLines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}
- (CGRect)textRect {
    
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.origin.y = (self.bounds.size.height - textRect.size.height)/2;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        textRect.origin.x = (self.bounds.size.width - textRect.size.width)/2;
    }
    if (self.textAlignment == NSTextAlignmentRight) {
        textRect.origin.x = self.bounds.size.width - textRect.size.width;
    }
    
    return textRect;
}


-(NSMutableArray *)linkPoints
{
    return objc_getAssociatedObject(self, &linkPointskey);
}

-(void)setLinkPoints:(NSMutableArray *)linkPoints
{
    objc_setAssociatedObject(self, &linkPointskey, linkPoints, OBJC_ASSOCIATION_ASSIGN);
    
}

- (void)setCopyLableActionBlock:(JGJCopyLableActionBlock)copyLableActionBlock {
    
    objc_setAssociatedObject(self, &JGJCopyLableActionAction_key, copyLableActionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JGJCopyLableActionBlock)copyLableActionBlock {
    
    return objc_getAssociatedObject(self, &JGJCopyLableActionAction_key);
}


@end
