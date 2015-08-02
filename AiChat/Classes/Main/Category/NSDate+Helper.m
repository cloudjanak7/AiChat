//
//  NSDate+Helper.m
//  TestApp
//
//  Created by 庄彪 on 15/5/27.
//  Copyright (c) 2015年 神州泰岳. All rights reserved.
//

#import "NSDate+Helper.h"

#define WEEK_DAYS @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"]

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

+ (NSDate *)formatLongDateTimeFromString:(NSString *)string
{
    static NSDateFormatter *dateFormatter = nil;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    return [dateFormatter dateFromString:string];
}

- (NSString *)formatIMDate {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                                         NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday
                                                    fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                                        NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday
                                                   fromDate:self];
    
    static NSDateFormatter *formatter = nil;
    NSString *dateString = nil;
    NSString *hourMinuteString = nil;
    
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    
    formatter.dateFormat = @"HH:mm";
    hourMinuteString = [formatter stringFromDate:self];
    
    if (todayComponents.day == dateComponents.day) {
        dateString = hourMinuteString;
    }
    else if (todayComponents.day - 1 == dateComponents.day) {
        dateString = [NSString stringWithFormat:@"昨天 %@", hourMinuteString];
    }
    else if (todayComponents.day - dateComponents.day <= 7) {
        if (WEEK_DAYS.count > dateComponents.weekday-1) {
            dateString = [NSString stringWithFormat:@"%@ %@",
                          WEEK_DAYS[dateComponents.weekday-1], hourMinuteString];
        }
    }
    else {
        formatter.dateFormat = @"YY-MM-dd hh:mm";
        dateString = [formatter stringFromDate:self];
    }
    
    return dateString;
}

- (BOOL)isToday
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayComponents = [calendar components:NSCalendarUnitDay
                                                    fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay
                                                   fromDate:self];
    
    if (todayComponents.day == dateComponents.day) {
        return YES;
    }
    return NO;
}

- (BOOL)isYesterday
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayComponents = [calendar components:NSCalendarUnitDay
                                                    fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay
                                                   fromDate:self];
    
    if (todayComponents.day - 1 == dateComponents.day) {
        return YES;
    }
    return NO;
}

- (BOOL)isTomorrow
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayComponents = [calendar components:NSCalendarUnitDay
                                                    fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay
                                                   fromDate:self];
    
    if (todayComponents.day + 1 == dateComponents.day) {
        return YES;
    }
    return NO;
}

- (BOOL)isInWeek
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayComponents = [calendar components:NSCalendarUnitDay
                                                    fromDate:[NSDate date]];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay
                                                   fromDate:self];
    
    if (todayComponents.day - dateComponents.day <= 7) {
        return YES;
    }
    return NO;
}

@end
