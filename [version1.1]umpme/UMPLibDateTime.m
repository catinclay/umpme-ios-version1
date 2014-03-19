//
//  UMPLibDateTime.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/17/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLibDateTime.h"

@implementation UMPLibDateTime

+(id)shareDateTimeManager {
    static UMPLibDateTime *umpDateTime = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpDateTime = [[UMPLibDateTime alloc] init];
    });
    return umpDateTime;
}

- (NSString *)getUmpDate {
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    NSString *umpTimeZone = umpCsntManager.umpCsntDateTimeManager.umpTimeZone;
    
    long year;
    long month;
    long day;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSTimeZone *tmz = [NSTimeZone timeZoneWithName:umpTimeZone];
    [cal setTimeZone:tmz];
    NSDateComponents *comps = [cal
                               components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                               fromDate:now];
    year = [comps year];
    month = [comps month];
    day = [comps day];
    
    NSString *umpCurrDate = [[NSString alloc] initWithFormat:@"%ld-%ld-%ld", year, month, day];
    return umpCurrDate;
}

- (NSString *)getUmpTime {
    UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
    NSString *umpTimeZone = umpCsntManager.umpCsntDateTimeManager.umpTimeZone;
    
    long hour;
    long minute;
    long second;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSTimeZone *tmz = [NSTimeZone timeZoneWithName:umpTimeZone];
    [cal setTimeZone:tmz];
    NSDateComponents *comps = [cal
                               components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                               fromDate:now];
    hour = [comps hour];
    minute = [comps minute];
    second = [comps second];
    
    NSString *umpCurrTime = [[NSString alloc] initWithFormat:@"%ld:%ld:%ld", hour, minute, second];
    return umpCurrTime;
}

@end
