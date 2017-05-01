//
//  SHNetNotificationCenter.m
//  SohuHouse
//
//  Created by sohu on 16/4/20.
//  Copyright © 2016年 focus.cn. All rights reserved.
//

#import "SHNetNotificationCenter.h"

@interface SHNetNotificationCenter ()
@property (nonatomic, strong) NSMutableArray *observerList;
@end

@implementation SHNetNotificationCenter
+ (SHNetNotificationCenter*)defaultCenter
{
    static SHNetNotificationCenter *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHNetNotificationCenter alloc] init];
        
    });
    return _instance;
}



- (void)addObserver:(id<INetStatusInterface>)observer
{
    if ((!observer) || [self.observerList containsObject:observer]) {
        return;
    }
    
    [self.observerList addObject:observer];
}
- (void)removeObserver:(id<INetStatusInterface>)observer
{
    if (observer && [self.observerList containsObject:observer]) {
        [self.observerList removeObject:observer];
    }
}
- (void)removeAllObserver
{
    [self.observerList removeAllObjects];
}



- (void)updateState:(SHNetworkStatus)status
{
    for (id<INetStatusInterface> observer in self.observerList) {
        if ([observer respondsToSelector:@selector(netReachabilityStatusChange:)]) {
            [observer netReachabilityStatusChange:status];
        }
    }
}


#pragma mark - setting or getting 
- (NSMutableArray*)observerList
{
    if (!_observerList) {
        _observerList = [[NSMutableArray alloc] init];
    }
    
    return _observerList;
}

@end
