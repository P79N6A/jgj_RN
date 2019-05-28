//
//  TYSingleton.h
//  TYSingleton
//
//  Created by Tony on 15/4/18.
//  Copyright (c) 2015年 tony. All rights reserved.
//

#ifndef TY_Singleton_h
#define TY_Singleton_h

// 帮助实现单例设计模式

// .h文件的实现
#define TYSingleton_interface(methodName) + (instancetype)shared##methodName;

// .m文件的实现
#if __has_feature(objc_arc) // 是ARC
#define TYSingleton_implementation(methodName) \
\
static id _instace = nil; \
+ (id)allocWithZone:(struct _NSZone *)zone \
    { \
        if (_instace == nil) { \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
        _instace = [super allocWithZone:zone]; \
        }); \
    } \
    return _instace; \
} \
\
\
- (id)init \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
    _instace = [super init]; \
    }); \
    return _instace; \
} \
\
\
+ (instancetype)shared##methodName \
{ \
    return [[self alloc] init]; \
} \
\
\
+ (id)copyWithZone:(struct _NSZone *)zone \
{ \
    return _instace; \
} \
\
\
+ (id)mutableCopyWithZone:(struct _NSZone *)zone \
{ \
    return _instace; \
}

#else // 不是ARC

#define TYSingleton_implementation(methodName) \
static id _instace = nil; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
    if (_instace == nil) { \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
        _instace = [super allocWithZone:zone]; \
        }); \
    } \
\
    return _instace; \
} \
\
\
- (id)init \
{ \
    static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
        _instace = [super init]; \
    }); \
    return _instace; \
} \
\
\
+ (instancetype)shared##methodName \
{ \
    return [[self alloc] init]; \
} \
\
- (oneway void)release \
{ \
\
\
} \
\
- (id)retain \
{ \
    return self; \
} \
\
\
- (NSUInteger)retainCount \
{ \
    return 1; \
} \
+ (id)copyWithZone:(struct _NSZone *)zone \
{ \
    return _instace; \
} \
\
\
+ (id)mutableCopyWithZone:(struct _NSZone *)zone \
{ \
    return _instace; \
}
#endif

#endif
