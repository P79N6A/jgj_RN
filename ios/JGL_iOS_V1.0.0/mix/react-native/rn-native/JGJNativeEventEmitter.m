//
//  JGJNativeBridge.m
//  mix
//
//  Created by Json on 2019/5/5.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJNativeEventEmitter.h"

static JGJNativeEventEmitter * _emitter;

@implementation JGJNativeEventEmitter

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"refreshRN",@"offSelect"];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emitter = [super allocWithZone:zone];
    });
    return _emitter;
}

- (void)startObserving
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emitEventInternal:)
                                                 name:@"event-emitted"
                                               object:nil];
}
- (void)stopObserving
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)emitEventInternal:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    NSString *eventName = userInfo[@"eventName"];
    id body = userInfo[@"body"];
    [self sendEventWithName:eventName body:body];
}

+ (void)emitEventWithName:(NSString *)name body:(id)body
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"eventName"] = name;
    userInfo[@"body"] = body;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"event-emitted"
                                                        object:self
                                                      userInfo:userInfo];
}



@end
