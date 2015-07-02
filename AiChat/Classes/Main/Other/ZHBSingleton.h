//
//  Singleton.h
//  BJEomsIOSApp
//
//  Created by 庄彪 on 15/4/27.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

// .h文件
#define ZHBSingletonH(name) + (instancetype)shared##name;

// .m文件
#define ZHBSingletonM(name) \
static id _instance = nil; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}
