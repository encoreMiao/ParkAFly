//
//  BAFUserModelManger.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/3.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFUserModelManger.h"
#import "BAFUserInfo.h"

#define kBAFUserInfo    @"kBAFUserInfo"

static BAFUserModelManger * instance = nil;

@interface BAFUserModelManger()
@property (nonatomic, retain) BAFUserInfo *userInfo;
@end

@implementation BAFUserModelManger
+ (BAFUserModelManger *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BAFUserModelManger alloc] init];
        
    });
    return instance;
}

- (void)saveUserInfo:(BAFUserInfo *)userInfo{
    _userInfo = userInfo;
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [[NSUserDefaults standardUserDefaults] setObject:archiveData forKey:kBAFUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BAFUserInfo *)userInfo
{
    if (_userInfo) {
        return _userInfo;
    }
    NSData *encodedData = [[NSUserDefaults standardUserDefaults] objectForKey:kBAFUserInfo];
    _userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    if (!_userInfo) {
        _userInfo = [[BAFUserInfo alloc] init];
    }
    return _userInfo;
}

- (void)removeUserInfo
{
    _userInfo = nil;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kBAFUserInfo];
}

@end
