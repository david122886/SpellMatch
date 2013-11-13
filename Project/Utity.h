//
//  Utity.h
//  Project
//
//  Created by comdosoft on 13-11-12.
//  Copyright (c) 2013年 Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utity : NSObject
@property (nonatomic, assign) int firstpoint;
@property (nonatomic, assign) BOOL isOrg;
@property (nonatomic, strong) NSArray *rangeArray;

@property (nonatomic, strong) NSMutableArray *greenArray;//绿色:正确，基本正确
@property (nonatomic, strong) NSMutableArray *yellowArray;//黄色:部分匹配
@property (nonatomic, strong) NSMutableArray *spaceLineArray;//下划线:缺词
@property (nonatomic, strong) NSMutableArray *noticeArray;//标记需要提示的地方
+ (Utity *)shared;

+(NSString*)spellStringWithWord:(NSString*)word;
+(NSArray *)metaphoneArray:(NSArray *)array;
//去除标点符号
+(NSArray *)handleTheString:(NSString *)string;
//单词转化字母数组
+(NSArray *)handleTheLetter:(NSString *)string;
//匹配相似度
+(int)DistanceBetweenTwoString:(NSString*)strA StrAbegin:(int)strAbegin StrAend:(int)strAend StrB:(NSString*)strB StrBbegin:(int)strBbegin StrBend:(int)strBend;
//返回结果
+(NSDictionary *)compareWithArray:(NSArray *)arrA andArray:(NSArray *)arrAA WithArray:(NSArray *)arrB andArray:(NSArray *)arrBB WithRange:(NSArray *)rangeArray;
@end
