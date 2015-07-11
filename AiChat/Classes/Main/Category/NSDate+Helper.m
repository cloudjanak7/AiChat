//
//  NSDate+Helper.m
//  TestApp
//
//  Created by 庄彪 on 15/5/27.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

+ (NSString *)currentDateStringWithFormat:(NSString *)format
{
    NSDate *chosenDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *date = [formatter stringFromDate:chosenDate];
    return date;
}

+ (NSString *)currentDateString {
    NSString *format = @"yyyyMMddHHmmss";
    return [NSDate currentDateStringWithFormat:format];
}

+ (NSString *)dateStringWithTimeIntervalSinceNow:(NSTimeInterval)interval {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:interval];
    NSString *format = @"yyyyMMddHHmmss";
    return [date dateWithFormat:format];
}

- (NSString *)dateWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *date = [formatter stringFromDate:self];
    return date;
}

- (NSString *)dateString {
    return [self dateWithFormat:@"yyyy/MM/dd"];
}

- (NSString *)timeString {
    return [self dateWithFormat:@"HH:mm"];
}

- (NSString *)dateTimeString {
    return [self dateWithFormat:@"yyyy/MM/dd HH:mm:ss"];
}

@end
