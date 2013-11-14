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
@property (nonatomic,weak) void (^success)(NSArray *dataArr);
@property (nonatomic,weak) void (^failure)(NSError *error);
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
+(void)downloadAudioDataWithURL:(NSURL*)url success:(void (^)(NSArray *dataArr))sucess failure:(void(^)(NSError *error))failure{
    PracticeObjDao *dao = [PracticeObjDao defaultDao];
    dao.success = sucess;
    dao.failure = failure;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = dao;
    [request startAsynchronous];
}

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
