
//
//  ZHBSystemMacro.h
//  AiChat
//
//  Created by 庄彪 on 15/8/2.
//  Copyright (c) 2015年 XMPP. All rights reserved.
//

#ifndef AiChat_ZHBSystemMacro_h
#define AiChat_ZHBSystemMacro_h

#define SYSTEM_VERSION [[UIDevice currentDevice].systemVersion doubleValue]
#define iOS7 (SYSTEM_VERSION >= 7.0 && SYSTEM_VERSION < 8.0)

#define ZHBScreenW [UIScreen mainScreen].bounds.size.width
#define ZHBScreenH [UIScreen mainScreen].bounds.size.height
#define ZHBSystemKeyboardH_V 258
#define ZHBSystemKeyboardH_H 194

#endif
