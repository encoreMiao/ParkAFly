//
//  SHApplicationManagerCenter.m
//  SohuHouse
//
//  Created by sohu on 16/4/21.
//  Copyright © 2016年 focus.cn. All rights reserved.
//

#import "SHApplicationManagerCenter.h"

@interface SHApplicationManagerCenter ()
@property (nonatomic, strong) NSMutableArray *observerList;
@end


@implementation SHApplicationManagerCenter
+ (SHApplicationManagerCenter*)defaultCenter
{
    static SHApplicationManagerCenter *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SHApplicationManagerCenter alloc] init];
        
    });
    return _instance;
}

- (void)addObserver:(id<IApplicationInterface>)observer
{
    if ((!observer) || [self.observerList containsObject:observer]) {
        return;
    }
    [self.observerList addObject:observer];
}
- (void)removeObserver:(id<IApplicationInterface>)observer
{
    if (observer && [self.observerList containsObject:observer]) {
        [self.observerList removeObject:observer];
    }
}
- (void)removeAllObserver
{
    [self.observerList removeAllObjects];
}



- (void)applicationDidBecomeActive
{
    for (id<IApplicationInterface> observer in self.observerList) {
        if ([observer respondsToSelector:@selector(applicationDidBecomeActive)]) {
            [observer applicationDidBecomeActive];
        }
    }
}

- (void)applicationWillResignActive
{
    for (id<IApplicationInterface> observer in self.observerList) {
        if ([observer respondsToSelector:@selector(applicationWillResignActive)]) {
            [observer applicationWillResignActive];
        }
    }
}

- (void)applicationDidEnterBackground
{
    for (id<IApplicationInterface> observer in self.observerList) {
        if ([observer respondsToSelector:@selector(applicationDidEnterBackground)]) {
            [observer applicationDidEnterBackground];
        }
    }
}

- (void)applicationWillEnterForeground
{
    for (id<IApplicationInterface> observer in self.observerList) {
        if ([observer respondsToSelector:@selector(applicationWillEnterForeground)]) {
            [observer applicationWillEnterForeground];
        }
    }
}

- (void)applicationWillTerminate
{
    for (id<IApplicationInterface> observer in self.observerList) {
        if ([observer respondsToSelector:@selector(applicationWillTerminate)]) {
            [observer applicationWillTerminate];
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
