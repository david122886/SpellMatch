//
//  PracticeObjDao.h
//  MatchSpeedString
//
//  Created by david on 13-11-13.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PracticeObj.h"
@interface PracticeObjDao : NSObject
+(void)downloadAudioDataWithURL:(NSURL*)url success:(void (^)(NSMutableDictionary *dataArr))sucess failure:(void(^)(NSError *error))failure;
@end
