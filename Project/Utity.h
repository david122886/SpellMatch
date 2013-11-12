//
//  Utity.h
//  Project
//
//  Created by comdosoft on 13-11-12.
//  Copyright (c) 2013年 Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utity : NSObject

@property (nonatomic, assign) BOOL isOrg;
@property (nonatomic, strong) NSArray *rangeArray;

+ (Utity *)shared;

+(NSString*)spellStringWithWord:(NSString*)word;
+(NSArray *)metaphoneArray:(NSArray *)array;
//去除标点符号
+(NSArray *)handleTheString:(NSString *)string;
//单词转化字母数组
+(NSArray *)handleTheLetter:(NSString *)string;
@end
