//
//  JGJNativeBridge.h
//  mix
//
//  Created by Json on 2019/5/5.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import <React/RCTEventEmitter.h>
@interface JGJNativeEventEmitter : RCTEventEmitter<RCTBridgeModule>

+ (void)emitEventWithName:(NSString *)name body:(id)body;
@end


