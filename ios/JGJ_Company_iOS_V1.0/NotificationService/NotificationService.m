//
//  NotificationService.m
//  JGJNotificationService
//
//  Created by yj on 2019/2/27.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "NotificationService.h"

#define JGJShareSuiteName   @"group.manger.jizhi.com"

#define JGJShareSuiteNameKey   @"jizhibadge"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    NSInteger badge = [[self readUserDefaults] integerValue] + 1;
    
    NSString *value = [NSString stringWithFormat:@"%@",@(badge)];
    
    [self saveUserDefaults:value];
    
    self.bestAttemptContent.badge = @(badge);
    
    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

- (void)saveUserDefaults:(NSString *)badge
{
    if ([self isEmpty:badge]) {
        
        badge = 0;
    }
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:JGJShareSuiteName];
    
    [shared setObject:badge forKey:JGJShareSuiteNameKey];
    
    [shared synchronize];
}

- (NSString *)readUserDefaults
{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:JGJShareSuiteName];
    
    NSString *value = [shared valueForKey:JGJShareSuiteNameKey];
    
    if ([self isEmpty:value]) {
        
        value = @"0";
    }
    
    return value;
}

//判断字符串是否为空
- (BOOL)isEmpty:(NSString *)string
{
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if (!string || [string isEqualToString:@""] || string.length == 0)
    {
        return YES;
    }
    else
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
        if (trimedString.length == 0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

@end
