//
//  Utity.m
//  Project
//
//  Created by comdosoft on 13-11-12.
//  Copyright (c) 2013年 Project. All rights reserved.
//

#import "Utity.h"
#import "double_metaphone.h"

@implementation Utity

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (Utity *)shared {
    static Utity * caiJinTongManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        caiJinTongManager = [[super alloc] init];
    });
    return caiJinTongManager;
}

+(NSString*)spellStringWithWord:(NSString*)word{
    if (!word) {
        return NULL;
    }
    char *reslut = NULL;
    DoubleMetaphone([word UTF8String], &reslut);
    return [NSString stringWithCString:reslut encoding:NSUTF8StringEncoding];
}

+(NSArray *)metaphoneArray:(NSArray *)array {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    if (array.count>0) {
        for (int i=0; i<array.count; i++) {
            NSString *strTest = [Utity  spellStringWithWord:[array objectAtIndex:i]];
            [tempArray addObject:strTest];
        }
    }
    return tempArray;
}
//去除标点符号
+(NSArray *)handleTheString:(NSString *)string {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    NSError *error;
    NSString *regTags = @"[a-zA-Z]+";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, [string length])];
    if ([Utity shared].isOrg == NO) {
        [Utity shared].rangeArray = matches;
    }
    for (NSTextCheckingResult *match in matches) {

        NSRange matchRange = [match rangeAtIndex:0];
        NSString *str = [string substringWithRange:matchRange];
        
        [tempArray addObject:str];
    }
    
    return tempArray;
}
//单词转化字母数组
+(NSArray *)handleTheLetter:(NSString *)string {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    NSError *error;
    NSString *regTags = @"[a-zA-Z]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match rangeAtIndex:0];
        NSString *str = [string substringWithRange:matchRange];
        [tempArray addObject:str];
        
    }
    
    return tempArray;
}
//+(int)compare
////开音节 闭音节
//-(NSString *)judgeTheString:(NSString *)string {
//    
//}
@end
