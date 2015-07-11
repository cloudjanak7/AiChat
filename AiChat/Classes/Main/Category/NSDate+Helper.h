//
//  NSDate+Helper.h
//  TestApp
//
//  Created by 庄彪 on 15/5/27.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)

+ (NSString *)currentDateString;

//+ (NSString *)currentDateStringWithSeparator:(NSString *)separetor;

+ (NSString *)currentDateStringWithFormat:(NSString *)format;

+ (NSString *)dateStringWithTimeIntervalSinceNow:(NSTimeInterval)interval;

- (NSString *)dateWithFormat:(NSString *)format;

- (NSString *)dateString;

- (NSString *)timeString;

@end
