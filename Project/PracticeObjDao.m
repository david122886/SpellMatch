//
//  PracticeObjDao.m
//  MatchSpeedString
//
//  Created by david on 13-11-13.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "PracticeObjDao.h"
#import "ASIHTTPRequest.h"
@interface PracticeObjDao()<ASIHTTPRequestDelegate>
@property (nonatomic,strong) void (^success)(NSMutableDictionary *dataArr);
@property (nonatomic,strong) void (^failure)(NSError *error);
@end
@implementation PracticeObjDao
static PracticeObjDao *staticPratice;
+(id)defaultDao{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticPratice = [[PracticeObjDao alloc] init];
    });
    return staticPratice;
}

+(void)downloadAudioDataWithURL:(NSURL*)url success:(void (^)(NSMutableDictionary *dataArr))sucess failure:(void(^)(NSError *error))failure{
    PracticeObjDao *dao = [PracticeObjDao defaultDao];
    dao.success = sucess;
    dao.failure = failure;
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
    [client getPath:@"/api/exercises/index_list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSString *dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *jsonDic=(NSDictionary*)[NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            NSArray *arr = [jsonDic objectForKey:@"exercise"];
            if (arr) {
                NSMutableDictionary *praticeDic = [NSMutableDictionary dictionary];
                for (NSDictionary *objDic in arr) {
                    NSArray *objArr = [objDic objectForKey:@"questions"];
                    NSString *praticeTitle = [objDic objectForKey:@"name"];
                    int count = 0;
                    NSMutableArray *praticeArr = [NSMutableArray array];
                    for (NSDictionary *subObjDic in objArr) {
                        PracticeObj *obj = [[PracticeObj alloc] init];
                        obj.practiceText = [subObjDic objectForKey:@"text"];
                        obj.practiceTitle = praticeTitle;
                        obj.practiceAudioURL = [subObjDic objectForKey:@"audio_url"];
                        obj.practiceID = [NSString stringWithFormat:@"%d",count++];
                        [praticeArr addObject:obj];
                    }
                    [praticeDic setValue:praticeArr forKey:praticeTitle];
                }
                if (sucess) {
                    sucess(praticeDic);
                }
            }else{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:100 userInfo:@{@"error": @"无数据"}]);
                }
            }
            
            
            
        }else {
            if (failure) {
                failure([NSError errorWithDomain:@"" code:100 userInfo:@{@"error": @"无数据"}]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:100 userInfo:@{@"error": @"无法连接服务器"}]);
        }
    }];
}

//+(void)downloadAudioDataWithURL:(NSURL*)url success:(void (^)(NSArray *dataArr))sucess failure:(void(^)(NSError *error))failure{
//    PracticeObjDao *dao = [PracticeObjDao defaultDao];
//    dao.success = sucess;
//    dao.failure = failure;
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    request.delegate = dao;
//    [request setRequestMethod:@"GET"];
//    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
//    [request startAsynchronous];
//}

#pragma mark ASIHTTPRequestDelegate
-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
    NSLog(@"%d",[data length]);
}

-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    NSLog(@"responseHeaders:%@",responseHeaders);
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *resultHeaders = [request responseHeaders];
    if (resultHeaders) {
        NSData *data = [[NSData alloc]initWithData:[request responseData]];
        NSArray *jsonObject=(NSArray*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (jsonObject !=nil) {
            if (self.success) {
                self.success(jsonObject);
            }
        }else{
            if (self.failure) {
                self.failure([NSError errorWithDomain:@"" code:100 userInfo:@{@"error": @"无数据"}]);
            }
        }
    }else {
        if (self.failure) {
            self.failure([NSError errorWithDomain:@"" code:100 userInfo:@{@"error": @"获取失败"}]);
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    if (self.failure) {
        self.failure([NSError errorWithDomain:@"" code:100 userInfo:@{@"error": @"获取失败"}]);
    }
}
#pragma mark --
@end
