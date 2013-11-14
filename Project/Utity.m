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
//去除标点符号 hello,will: can't. project me serve?
+(NSArray *)handleTheString:(NSString *)string {
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    NSError *error;
    NSString *regTags = @"([a-zA-Z]+[-']*[a-zA-Z]+)|([a-zA-Z]+)";//added by david
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

+(int) MiniNum:(int)x SetY:(int)y SetZ:(int)z
{
    int tempNum;
    tempNum = x;
    if (y<tempNum) {
        tempNum = y;
    }
    if (z<tempNum) {
        tempNum = z;
    }
    return tempNum;
}
//匹配相似度
+(int)DistanceBetweenTwoString:(NSString*)strA StrAbegin:(int)strAbegin StrAend:(int)strAend StrB:(NSString*)strB StrBbegin:(int)strBbegin StrBend:(int)strBend
{
    int x,y,z;
    if (strAbegin>strAend) {
        if (strBbegin>strBend) {
            return 0;
        }else {
            return strBend -strBbegin +1;
        }
    }
    if (strBbegin>strBend) {
        if (strAbegin>strAend) {
            return 0;
        }else {
            return strAend -strAbegin +1;
        }
    }
    
//    if ([strA characterAtIndex:(NSUInteger)(strAbegin)] == [strB characterAtIndex:(NSUInteger)(strBbegin)]) {
    if ([[[strA substringWithRange:NSMakeRange(strAbegin, 1)]uppercaseString] isEqualToString:[[strB substringWithRange:NSMakeRange(strBbegin, 1)]uppercaseString]]) {
        return [Utity DistanceBetweenTwoString:strA StrAbegin:strAbegin+1 StrAend:strAend StrB:strB StrBbegin: strBbegin+1 StrBend: strBend];
    }else {
        x = [Utity DistanceBetweenTwoString:strA StrAbegin:strAbegin+1 StrAend:strAend StrB:strB StrBbegin: strBbegin+1 StrBend: strBend];
        y = [Utity DistanceBetweenTwoString:strA StrAbegin:strAbegin StrAend:strAend StrB:strB StrBbegin: strBbegin+1 StrBend: strBend];
        z = [Utity DistanceBetweenTwoString:strA StrAbegin:strAbegin+1 StrAend:strAend StrB:strB StrBbegin: strBbegin StrBend: strBend];
        return[Utity MiniNum:x SetY:y SetZ:z] +1;
    }
}
///@"hello,will: can't.u project me serve?";
//返回结果 arrA:输入文本的单词数组  /  arrAA:输入文本简化后的单词数组
//        arrB:原文本单词数组    /   arrBB:原文本简化后的单词数组
+(NSDictionary *)compareWithArray:(NSArray *)arrA andArray:(NSArray *)arrAA WithArray:(NSArray *)arrB andArray:(NSArray *)arrBB WithRange:(NSArray *)rangeArray{
    NSMutableArray *temp_arrA = [NSMutableArray arrayWithArray:arrA];//输入文本的单词数组
    NSMutableArray *temp_arrAA = [NSMutableArray arrayWithArray:arrAA];//输入文本简化后的单词数组
    NSMutableArray *temp_arrB = [NSMutableArray arrayWithArray:arrB];//原文本单词数组
    NSMutableArray *temp_arrBB = [NSMutableArray arrayWithArray:arrBB];//原文本简化后的单词数组
    NSMutableArray *temp_range = [NSMutableArray arrayWithArray:rangeArray];
    if (temp_arrAA.count>0 && temp_arrA.count>[Utity shared].firstpoint && temp_arrBB.count>0) {
        NSString *strAA = [temp_arrAA objectAtIndex:[Utity shared].firstpoint];
        if ([temp_arrBB containsObject:strAA]) {
            NSUInteger index = [temp_arrBB indexOfObject:strAA];
            if (index>[Utity shared].firstpoint) {//位置不同
                //先比较2个数组中的第index个字符
                if (temp_arrAA.count>index) {
                    NSString *strAA2 = [temp_arrAA objectAtIndex:index];
                    if ([strAA isEqualToString:strAA2]) {//index位置元素相同
                        //比较相同后一位的相似度
                        if (temp_arrBB.count>index+1) {//第一位与index＋1位
                            NSString *strBB = [temp_arrBB objectAtIndex:index+1];
                            NSString *strAA3 = [temp_arrAA objectAtIndex:[Utity shared].firstpoint+1];
                            if ([temp_arrBB containsObject:strAA3]) {//arrAA里面后一位在arrBB里面
                                NSUInteger index2 = [temp_arrBB indexOfObject:strAA3];
                                if (index2>index) {//0位置与index位置对应
                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                    NSString *string = [temp_arrA objectAtIndex:[Utity shared].firstpoint];
                                    int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                    BOOL isSure = NO;
                                    if (rotateDis == 0) {
                                        NSLog(@"完全正确");
                                        isSure = YES;
                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {
                                        NSLog(@"基本正确");
                                        isSure = YES;
                                        [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                        [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                    }else {
                                        NSLog(@"黑户");
                                        [Utity shared].firstpoint +=1;
                                    }
                                    if (isSure == YES) {
                                        NSTextCheckingResult *match = [temp_range objectAtIndex:[Utity shared].firstpoint];
                                        NSRange range = [match rangeAtIndex:0];
                                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-[Utity shared].firstpoint];//从起点0开始到中点
                                        [[Utity shared].spaceLineArray addObject:str];
                                        
                                        [temp_arrA removeObjectAtIndex:[Utity shared].firstpoint];
                                        [temp_arrAA removeObjectAtIndex:[Utity shared].firstpoint];
                                        NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                        NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                        for (int yy=[Utity shared].firstpoint; yy<=index; yy++) {
                                            [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                            [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                        }
                                        [temp_arrB removeObjectsInArray:tempArrayB];
                                        [temp_arrBB removeObjectsInArray:tempArrayBB];
                                        [temp_range removeObjectAtIndex:[Utity shared].firstpoint];
                                    }
                                }
                                else {//index位置与index位置对应
                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                    NSString *string = [temp_arrA objectAtIndex:index];
                                    int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                    BOOL isSure = NO;
                                    if (rotateDis == 0) {
                                        NSLog(@"完全正确");
                                        isSure = YES;
                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {
                                        NSLog(@"基本正确");
                                        isSure = YES;
                                        [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                        [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:index]];
                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                    }else {
                                        NSLog(@"黑户");
                                        [Utity shared].firstpoint +=1;
                                    }
                                    if (isSure == YES) {
                                        [temp_arrA removeObjectAtIndex:index];
                                        [temp_arrAA removeObjectAtIndex:index];
                                        [temp_arrB removeObjectAtIndex:index];
                                        [temp_arrBB removeObjectAtIndex:index];
                                        [temp_range removeObjectAtIndex:index];
                                    }
                                }
                            }
                            else {//第一位与index＋1位是否部分匹配
                                BOOL exit = NO;
                                for (int i=0; i<temp_arrBB.count; i++) {
                                    int m=0,n=0;
                                    if (i!=index) {
                                        NSString *strBB3 = [temp_arrBB objectAtIndex:i];
                                        NSArray *arrayAA = [Utity handleTheLetter:strAA3];
                                        NSArray *arrayBB = [Utity handleTheLetter:strBB3];
                                        for (int k=0; k<arrayAA.count; k++) {
                                            NSString *letter = [arrayAA objectAtIndex:k];
                                            if ([arrayBB containsObject:letter]) {
                                                m++;
                                            }
                                        }
                                        float x = (float)strBB.length/2;
                                        if (m-x>0) {//简化部分匹配
                                            NSString *strA = [temp_arrA objectAtIndex:[Utity shared].firstpoint+1];
                                            NSString *strB = [temp_arrB objectAtIndex:i];
                                            NSArray *arrayA = [Utity handleTheLetter:strA];
                                            NSArray *arrayB = [Utity handleTheLetter:strB];
                                            for (int k=0; k<arrayA.count; k++) {
                                                NSString *letter = [arrayA objectAtIndex:k];
                                                if ([arrayB containsObject:letter]) {
                                                    n++;
                                                }
                                            }
                                            float y = (float)strB.length/2;
                                            if (n-y>=0) {//原文部分匹配
                                                exit = YES;
                                                NSLog(@"部分匹配");
                                                //i位置与第一位部分匹配
                                                if (i>index) {//0位置与index位置对应
                                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                                    NSString *string = [temp_arrA objectAtIndex:[Utity shared].firstpoint+1];
                                                    
                                                    int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                                    BOOL isSure = NO;
                                                    if (rotateDis == 0) {//完全相同
                                                        NSLog(@"完全正确");
                                                        isSure = YES;
                                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                                        NSLog(@"基本正确");
                                                        isSure = YES;
                                                        [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                                        [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                                    }else {
                                                        NSLog(@"黑户");
                                                        [Utity shared].firstpoint +=1;
                                                    }
                                                    if (isSure == YES) {
                                                        NSTextCheckingResult *match = [temp_range objectAtIndex:[Utity shared].firstpoint];
                                                        NSRange range = [match rangeAtIndex:0];
                                                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-[Utity shared].firstpoint];//从起点0开始到中点
                                                        [[Utity shared].spaceLineArray addObject:str];
                                                        
                                                        [temp_arrA removeObjectAtIndex:[Utity shared].firstpoint];
                                                        [temp_arrAA removeObjectAtIndex:[Utity shared].firstpoint];
                                                        NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                                        NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                                        for (int yy=[Utity shared].firstpoint; yy<=index; yy++) {
                                                            [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                                            [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                                        }
                                                        [temp_arrB removeObjectsInArray:tempArrayB];
                                                        [temp_arrBB removeObjectsInArray:tempArrayBB];
                                                        [temp_range removeObjectAtIndex:[Utity shared].firstpoint];
                                                    }
                                                    break;
                                                }
                                                else {//index位置与index位置对应
                                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                                    NSString *string = [temp_arrA objectAtIndex:index];
                                                    int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                                    BOOL isSure = NO;
                                                    if (rotateDis == 0) {//完全相同
                                                        NSLog(@"完全正确");
                                                        isSure = YES;
                                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                                        NSLog(@"基本正确");
                                                        isSure = YES;
                                                        [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                                        [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:index]];
                                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                                    }else {
                                                        NSLog(@"黑户");
                                                        [Utity shared].firstpoint +=1;
                                                    }
                                                    if (isSure == YES) {
                                                        [temp_arrA removeObjectAtIndex:index];
                                                        [temp_arrAA removeObjectAtIndex:index];
                                                        [temp_arrB removeObjectAtIndex:index];
                                                        [temp_arrBB removeObjectAtIndex:index];
                                                        [temp_range removeObjectAtIndex:index];
                                                    }
                                                }
                                                break;
                                            }
                                        }
                                        if (index == temp_arrBB.count-1) {
                                            if (i==temp_arrBB.count-2 && exit==NO) {//没有部分匹配index
                                                NSString *orgString = [temp_arrB objectAtIndex:index];
                                                NSString *string = [temp_arrA objectAtIndex:index];
                                                int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                                BOOL isSure = NO;
                                                if (rotateDis == 0) {//完全相同
                                                    NSLog(@"完全正确");
                                                    isSure = YES;
                                                    [[Utity shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                                }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                                    NSLog(@"基本正确");
                                                    isSure = YES;
                                                    [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                                    [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:index]];
                                                    [[Utity shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                                }else {
                                                    NSLog(@"黑户");
                                                    [Utity shared].firstpoint +=1;
                                                }
                                                if (isSure == YES) {
                                                    [temp_arrA removeObjectAtIndex:index];
                                                    [temp_arrAA removeObjectAtIndex:index];
                                                    [temp_arrB removeObjectAtIndex:index];
                                                    [temp_arrBB removeObjectAtIndex:index];
                                                    [temp_range removeObjectAtIndex:index];
                                                }
                                            }
                                        }else {
                                            if (i==temp_arrBB.count-1 && exit==NO) {//没有部分匹配index
                                                NSString *orgString = [temp_arrB objectAtIndex:index];
                                                NSString *string = [temp_arrA objectAtIndex:index];
                                                int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                                BOOL isSure = NO;
                                                if (rotateDis == 0) {//完全相同
                                                    NSLog(@"完全正确");
                                                    isSure = YES;
                                                    [[Utity shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                                }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                                    NSLog(@"基本正确");
                                                    isSure = YES;
                                                    [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                                    [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:index]];
                                                    [[Utity shared].greenArray addObject:[temp_range objectAtIndex:index]];
                                                }else {
                                                    NSLog(@"黑户");
                                                    [Utity shared].firstpoint +=1;
                                                }
                                                [temp_arrA removeObjectAtIndex:index];
                                                [temp_arrAA removeObjectAtIndex:index];
                                                [temp_arrB removeObjectAtIndex:index];
                                                [temp_arrBB removeObjectAtIndex:index];
                                                [temp_range removeObjectAtIndex:index];
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else {//index最后的位数
                            NSString *orgString = [temp_arrB objectAtIndex:index];
                            NSString *string = [temp_arrA objectAtIndex:index];
                            int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                            BOOL isSure = NO;
                            if (rotateDis == 0) {//完全相同
                                NSLog(@"完全正确");
                                isSure = YES;
                                [[Utity shared].greenArray addObject:[temp_range objectAtIndex:index]];
                            }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                NSLog(@"基本正确");
                                isSure = YES;
                                [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:index]];
                                [[Utity shared].greenArray addObject:[temp_range objectAtIndex:index]];
                            }else {
                                NSLog(@"黑户");
                                [Utity shared].firstpoint +=1;
                            }
                            if (isSure == YES) {
                                [temp_arrA removeObjectAtIndex:index];
                                [temp_arrAA removeObjectAtIndex:index];
                                [temp_arrB removeObjectAtIndex:index];
                                [temp_arrBB removeObjectAtIndex:index];
                                [temp_range removeObjectAtIndex:index];
                            }
                        }
                    }
                    else {//index位置元素不同
                        //比较>0位置
                        if (temp_arrAA.count>[Utity shared].firstpoint+1) {
                            for (int j=[Utity shared].firstpoint+1; j<temp_arrAA.count; j++) {
                                BOOL exit = NO;
                                NSString *str_AA = [temp_arrAA objectAtIndex:j];
                                if ([str_AA isEqualToString:strAA]) {
                                    for (int k=0; k<temp_arrBB.count; k++) {
                                        if (k!=index) {
                                            NSString *str_BB = [temp_arrBB objectAtIndex:k];
                                            if ([str_BB isEqualToString:str_AA]) {
                                                if (k>index) {
                                                    exit = YES;
                                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                                    NSString *string = [temp_arrA objectAtIndex:[Utity shared].firstpoint];
                                                    int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                                    BOOL isSure = NO;
                                                    if (rotateDis == 0) {//完全相同
                                                        NSLog(@"完全正确");
                                                        isSure = YES;
                                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                                        NSLog(@"基本正确");
                                                        isSure = YES;
                                                        [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                                        [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                                    }else {
                                                        NSLog(@"黑户");
                                                        [Utity shared].firstpoint +=1;
                                                    }
                                                    if (isSure == YES) {
                                                        NSTextCheckingResult *match = [temp_range objectAtIndex:[Utity shared].firstpoint];
                                                        NSRange range = [match rangeAtIndex:0];
                                                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-[Utity shared].firstpoint];//从起点0开始到中点
                                                        [[Utity shared].spaceLineArray addObject:str];
                                                        
                                                        [temp_arrA removeObjectAtIndex:[Utity shared].firstpoint];
                                                        [temp_arrAA removeObjectAtIndex:[Utity shared].firstpoint];
                                                        NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                                        NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                                        for (int yy=[Utity shared].firstpoint; yy<=index; yy++) {
                                                            [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                                            [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                                        }
                                                        [temp_arrB removeObjectsInArray:tempArrayB];
                                                        [temp_arrBB removeObjectsInArray:tempArrayBB];
                                                        [temp_range removeObjectAtIndex:[Utity shared].firstpoint];
                                                    }
                                                    break;
                                                }
                                            }else {//j与index对应
                                                if (index>j) {
                                                    exit = YES;
                                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                                    NSString *string = [temp_arrA objectAtIndex:j];
                                                    int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                                    BOOL isSure = NO;
                                                    if (rotateDis == 0) {//完全相同
                                                        NSLog(@"完全正确");
                                                        isSure = YES;
                                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:j]];
                                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                                        NSLog(@"基本正确");
                                                        isSure = YES;
                                                        [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                                        [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:j]];
                                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:j]];
                                                    }else {
                                                        NSLog(@"黑户");
                                                        [Utity shared].firstpoint +=1;
                                                    }
                                                    
                                                    if (isSure == YES) {
                                                        NSTextCheckingResult *match = [temp_range objectAtIndex:j];
                                                        NSRange range = [match rangeAtIndex:0];
                                                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-j];//从起点0开始到中点
                                                        [[Utity shared].spaceLineArray addObject:str];
                                                        
                                                        [temp_arrA removeObjectAtIndex:j];
                                                        [temp_arrAA removeObjectAtIndex:j];
                                                        NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                                        NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                                        for (int yy=j; yy<=index; yy++) {
                                                            [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                                            [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                                        }
                                                        [temp_arrB removeObjectsInArray:tempArrayB];
                                                        [temp_arrBB removeObjectsInArray:tempArrayBB];
                                                        [temp_range removeObjectAtIndex:j];
                                                    }
                                                    break;
                                                }
                                                else {
                                                    exit = YES;
                                                    //0与index对应
                                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                                    NSString *string = [temp_arrA objectAtIndex:[Utity shared].firstpoint];
                                                    int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                                    BOOL isSure = NO;
                                                    if (rotateDis == 0) {//完全相同
                                                        NSLog(@"完全正确");
                                                        isSure = YES;
                                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                                        NSLog(@"基本正确");
                                                        isSure = YES;
                                                        [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                                        [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                                    }else {
                                                        NSLog(@"黑户");
                                                        [Utity shared].firstpoint +=1;
                                                    }
                                                    if (isSure == YES) {
                                                        NSTextCheckingResult *match = [temp_range objectAtIndex:[Utity shared].firstpoint];
                                                        NSRange range = [match rangeAtIndex:0];
                                                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-[Utity shared].firstpoint];//从起点0开始到中点
                                                        [[Utity shared].spaceLineArray addObject:str];
                                                        
                                                        [temp_arrA removeObjectAtIndex:[Utity shared].firstpoint];
                                                        [temp_arrAA removeObjectAtIndex:[Utity shared].firstpoint];
                                                        NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                                        NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                                        for (int yy=[Utity shared].firstpoint; yy<=index; yy++) {
                                                            [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                                            [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                                        }
                                                        [temp_arrB removeObjectsInArray:tempArrayB];
                                                        [temp_arrBB removeObjectsInArray:tempArrayBB];
                                                        [temp_range removeObjectAtIndex:[Utity shared].firstpoint];
                                                    }
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                                if (j==temp_arrAA.count-1 && exit ==NO) {
                                    NSString *orgString = [temp_arrB objectAtIndex:index];
                                    NSString *string = [temp_arrA objectAtIndex:[Utity shared].firstpoint];
                                    int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                                    BOOL isSure = NO;
                                    if (rotateDis == 0) {//完全相同
                                        NSLog(@"完全正确");
                                        isSure = YES;
                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                        NSLog(@"基本正确");
                                        isSure = YES;
                                        [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                        [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                    }else {
                                        NSLog(@"黑户");
                                        [Utity shared].firstpoint +=1;
                                    }
                                    if (isSure == YES) {
                                        NSTextCheckingResult *match = [temp_range objectAtIndex:[Utity shared].firstpoint];
                                        NSRange range = [match rangeAtIndex:0];
                                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-[Utity shared].firstpoint];//从起点0开始到中点
                                        [[Utity shared].spaceLineArray addObject:str];
                                        
                                        [temp_arrA removeObjectAtIndex:[Utity shared].firstpoint];
                                        [temp_arrAA removeObjectAtIndex:[Utity shared].firstpoint];
                                        NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                        NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                        for (int yy=[Utity shared].firstpoint; yy<=index; yy++) {
                                            [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                            [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                        }
                                        [temp_arrB removeObjectsInArray:tempArrayB];
                                        [temp_arrBB removeObjectsInArray:tempArrayBB];
                                        [temp_range removeObjectAtIndex:[Utity shared].firstpoint];
                                    }
                                }
                            }
                        }
                        else {
                            //0与index对应
                            NSString *orgString = [temp_arrB objectAtIndex:index];
                            NSString *string = [temp_arrA objectAtIndex:[Utity shared].firstpoint];
                            int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                            BOOL isSure = NO;
                            if (rotateDis == 0) {//完全相同
                                NSLog(@"完全正确");
                                isSure = YES;
                                [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                            }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                                NSLog(@"基本正确");
                                isSure = YES;
                                [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                                [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                                [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                            }else {
                                NSLog(@"黑户");
                                [Utity shared].firstpoint +=1;
                            }
                            
                            if (isSure == YES) {
                                NSTextCheckingResult *match = [temp_range objectAtIndex:[Utity shared].firstpoint];
                                NSRange range = [match rangeAtIndex:0];
                                NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-[Utity shared].firstpoint];//从起点0开始到中点
                                [[Utity shared].spaceLineArray addObject:str];
                                
                                [temp_arrA removeObjectAtIndex:[Utity shared].firstpoint];
                                [temp_arrAA removeObjectAtIndex:[Utity shared].firstpoint];
                                NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                                NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                                for (int yy=[Utity shared].firstpoint; yy<=index; yy++) {
                                    [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                    [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                                }
                                [temp_arrB removeObjectsInArray:tempArrayB];
                                [temp_arrBB removeObjectsInArray:tempArrayBB];
                                [temp_range removeObjectAtIndex:[Utity shared].firstpoint];
                            }
                        }
                    }
                }
                else {//就是0位置与index位置对应
                    NSString *orgString = [temp_arrB objectAtIndex:index];
                    NSString *string = [temp_arrA objectAtIndex:[Utity shared].firstpoint];
                    int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                    BOOL isSure = NO;
                    if (rotateDis == 0) {//完全相同
                        NSLog(@"完全正确");
                        isSure = YES;
                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                    }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                        NSLog(@"基本正确");
                        isSure = YES;
                        [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                        [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                        [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                    }else {
                        NSLog(@"黑户");
                        [Utity shared].firstpoint +=1;
                    }
                    
                    if (isSure == YES) {
                        NSTextCheckingResult *match = [temp_range objectAtIndex:[Utity shared].firstpoint];
                        NSRange range = [match rangeAtIndex:0];
                        NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,index-[Utity shared].firstpoint];
                        [[Utity shared].spaceLineArray addObject:str];
                        
                        [temp_arrA removeObjectAtIndex:[Utity shared].firstpoint];
                        [temp_arrAA removeObjectAtIndex:[Utity shared].firstpoint];
                        NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                        NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                        for (int yy=[Utity shared].firstpoint; yy<=index; yy++) {
                            [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                            [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                        }
                        [temp_arrB removeObjectsInArray:tempArrayB];
                        [temp_arrBB removeObjectsInArray:tempArrayBB];
                        [temp_range removeObjectAtIndex:[Utity shared].firstpoint];
                    }
                }
                return [Utity compareWithArray:temp_arrA andArray:temp_arrAA WithArray:temp_arrB andArray:temp_arrBB WithRange:temp_range];
            }
            //输入句子长度大于原文本长度
            else if (index <[Utity shared].firstpoint) {
                NSString *orgString = [temp_arrB objectAtIndex:index];
                NSString *string = [temp_arrA objectAtIndex:[Utity shared].firstpoint];
                int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                BOOL isSure = NO;
                if (rotateDis == 0) {//完全相同
                    NSLog(@"完全正确");
                    isSure = YES;
                    [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {//基本正确
                    NSLog(@"基本正确");
                    isSure = YES;
                    [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:index]];
                    [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                    [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                }else {
                    NSLog(@"黑户");
                    [Utity shared].firstpoint +=1;
                }
                if (isSure == YES) {
                    [temp_arrA removeObjectAtIndex:[Utity shared].firstpoint];
                    [temp_arrAA removeObjectAtIndex:[Utity shared].firstpoint];
                    [temp_arrB removeObjectAtIndex:index];
                    [temp_arrBB removeObjectAtIndex:index];
                    [temp_range removeObjectAtIndex:[Utity shared].firstpoint];
                }
                return [Utity compareWithArray:temp_arrA andArray:temp_arrAA WithArray:temp_arrB andArray:temp_arrBB WithRange:temp_range];
            }
            else {//位置相同
                NSString *orgString = [temp_arrB objectAtIndex:[Utity shared].firstpoint];
                NSString *string = [temp_arrA objectAtIndex:[Utity shared].firstpoint];
                int rotateDis = [Utity DistanceBetweenTwoString:string StrAbegin:0 StrAend:string.length-1 StrB:orgString StrBbegin:0 StrBend:orgString.length-1];
                BOOL isSure = NO;
                if (rotateDis == 0) {//完全相同
                    NSLog(@"完全正确");
                    isSure = YES;
                    [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                }else if (rotateDis<= (abs(orgString.length-string.length)==0?1:2)) {
                    NSLog(@"基本正确");
                    isSure = YES;
                    [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:[Utity shared].firstpoint]];
                    [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                    [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                }else {
                    NSLog(@"黑户");
                    [Utity shared].firstpoint +=1;
                }
                if (isSure == YES) {
                    [temp_arrA removeObjectAtIndex:[Utity shared].firstpoint];
                    [temp_arrAA removeObjectAtIndex:[Utity shared].firstpoint];
                    [temp_arrB removeObjectAtIndex:[Utity shared].firstpoint];
                    [temp_arrBB removeObjectAtIndex:[Utity shared].firstpoint];
                    [temp_range removeObjectAtIndex:[Utity shared].firstpoint];
                }
                return [Utity compareWithArray:temp_arrA andArray:temp_arrAA WithArray:temp_arrB andArray:temp_arrBB WithRange:temp_range];
            }
        }else {//不包含
            BOOL exit = NO;
            for (int i=0; i<temp_arrBB.count; i++) {
                int m=0,n=0;
                NSString *strBB = [temp_arrBB objectAtIndex:i];
                NSRange range = [strBB rangeOfString:strAA];
                if (range.location!=NSNotFound) {
                    if (range.location==0 && range.length <strBB.length) {
                        NSString *strLetter = [strBB substringFromIndex:range.length];
                        if ([strLetter isEqualToString:@"S"]) {
                            NSLog(@"基本正确");
                            [[Utity shared].correctArray addObject:[temp_arrB objectAtIndex:i]];
                            [[Utity shared].noticeArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                            [[Utity shared].greenArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                            if (i > [Utity shared].firstpoint) {
                                NSTextCheckingResult *match = [temp_range objectAtIndex:[Utity shared].firstpoint];
                                NSRange range = [match rangeAtIndex:0];
                                NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,i-[Utity shared].firstpoint];//从起点x开始之前少x个单词
                                [[Utity shared].spaceLineArray addObject:str];
                            }
                            [temp_arrA removeObjectAtIndex:[Utity shared].firstpoint];
                            [temp_arrAA removeObjectAtIndex:[Utity shared].firstpoint];
                            NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                            NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                            for (int yy=[Utity shared].firstpoint; yy<=i; yy++) {
                                [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                            }
                            [temp_arrB removeObjectsInArray:tempArrayB];
                            [temp_arrBB removeObjectsInArray:tempArrayBB];
                            [temp_range removeObjectAtIndex:[Utity shared].firstpoint];
                            break;
                        }
                    }
                }else {
                    //判断是否部分匹配
                    NSArray *arrayAA = [Utity handleTheLetter:strAA];
                    NSArray *arrayBB = [Utity handleTheLetter:strBB];
                    for (int k=0; k<arrayAA.count; k++) {
                        NSString *letter = [arrayAA objectAtIndex:k];
                        if ([arrayBB containsObject:letter]) {
                            m++;
                        }
                    }
                    float x = (float)strBB.length/2;
                    if (m-x>0) {//简化部分匹配
                        NSString *strA = [temp_arrA objectAtIndex:[Utity shared].firstpoint];
                        NSString *strB = [temp_arrB objectAtIndex:i];
                        NSArray *arrayA = [Utity handleTheLetter:strA];
                        NSArray *arrayB = [Utity handleTheLetter:strB];
                        for (int k=0; k<arrayA.count; k++) {
                            NSString *letter = [arrayA objectAtIndex:k];
                            if ([arrayB containsObject:letter]) {
                                n++;
                            }
                        }
                        float y = (float)strB.length/2;
                        if (n-y>=0) {//原文部分匹配
                            exit = YES;
                            NSLog(@"部分匹配");
                            [[Utity shared].yellowArray addObject:[temp_range objectAtIndex:[Utity shared].firstpoint]];
                            if (i > [Utity shared].firstpoint) {
                                NSTextCheckingResult *match = [temp_range objectAtIndex:[Utity shared].firstpoint];
                                NSRange range = [match rangeAtIndex:0];
                                NSString *str = [NSString stringWithFormat:@"%d_%d",range.location,i-[Utity shared].firstpoint];//从起点x开始之前少x个单词
                                [[Utity shared].spaceLineArray addObject:str];
                            }
                            [temp_arrA removeObjectAtIndex:[Utity shared].firstpoint];
                            [temp_arrAA removeObjectAtIndex:[Utity shared].firstpoint];
                            NSMutableArray *tempArrayB = [[NSMutableArray alloc]init];
                            NSMutableArray *tempArrayBB = [[NSMutableArray alloc]init];
                            for (int yy=[Utity shared].firstpoint; yy<=i; yy++) {
                                [tempArrayB addObject:[temp_arrB objectAtIndex:yy]];
                                [tempArrayBB addObject:[temp_arrBB objectAtIndex:yy]];
                            }
                            [temp_arrB removeObjectsInArray:tempArrayB];
                            [temp_arrBB removeObjectsInArray:tempArrayBB];
                            [temp_range removeObjectAtIndex:[Utity shared].firstpoint];
                            break;
                        }
                    }
                }
                if (i==temp_arrBB.count-1 && exit==NO) {//没有部分匹配
                    NSLog(@"黑户");
                    [Utity shared].firstpoint +=1;
                }
            }
            return [Utity compareWithArray:temp_arrA andArray:temp_arrAA WithArray:temp_arrB andArray:temp_arrBB WithRange:temp_range];
        }
    }else {
        if (temp_arrBB.count>temp_arrAA.count) {
            NSTextCheckingResult *match = [[Utity shared].rangeArray objectAtIndex:[Utity shared].rangeArray.count-1];
            NSRange range = [match rangeAtIndex:0];
            NSString *str = [NSString stringWithFormat:@"%d_%d",range.location+range.length,temp_arrBB.count-temp_arrAA.count];//从起点x开始之前少x个单词
            [[Utity shared].spaceLineArray addObject:str];
        }
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]init];
        if ([Utity shared].greenArray.count>0) {
            [mutableDic setObject:[Utity shared].greenArray forKey:@"green"];
        }
        if ([Utity shared].yellowArray.count>0) {
            [mutableDic setObject:[Utity shared].yellowArray forKey:@"yellow"];
        }
        if ([Utity shared].spaceLineArray.count>0) {
            [mutableDic setObject:[Utity shared].spaceLineArray forKey:@"space"];
        }
        if ([Utity shared].noticeArray.count>0) {
            [mutableDic setObject:[Utity shared].noticeArray forKey:@"notice"];
            [mutableDic setObject:[Utity shared].correctArray forKey:@"correct"];
        }
        [Utity shared].noticeArray = nil;
        [Utity shared].correctArray = nil;
        [Utity shared].greenArray = nil;
        [Utity shared].yellowArray = nil;
        [Utity shared].spaceLineArray = nil;
        return mutableDic;
    }
    return nil;
}
@end
