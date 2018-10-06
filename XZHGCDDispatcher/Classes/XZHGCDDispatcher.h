//
//  ZHGCDDispatcher.h
//  ZHDispatchQueuePoolDemo
//
//  Created by xiongzenghui on 2018/9/27.
//  Copyright © 2018年 xiongzenghui. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef XZHGCDDispatcher_H
#define XZHGCDDispatcher_H
#import "YYDispatchQueuePool.h"

NS_ASSUME_NONNULL_BEGIN

/**
 - XZHDispatchQueuePool
   - NSQualityOfServiceUserInteractive Context
     - queue 1
     - queue 2
     - queue 3
     - ........
     - queue N（CPU kernel active count）
   - NSQualityOfServiceUserInitiated Context
     - queue 1
     - queue 2
     - queue 3
     - ........
     - queue N
   - NSQualityOfServiceUtility Context
     - queue 1
     - queue 2
     - queue 3
     - ........
     - queue N
   - NSQualityOfServiceBackground Context
     - queue 1
     - queue 2
     - queue 3
     - ........
     - queue N
   - NSQualityOfServiceDefault Context
     - queue 1
     - queue 2
     - queue 3
     - ........
     - queue N
 */
@interface XZHDispatchQueuePool : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 *  Get dispatch queue from defualt pool
 */
+ (dispatch_queue_t)defaultQueueWithQOS:(NSQualityOfService)qos;

/**
 Creates and returns a dispatch queue pool.
 @param name       The name of the pool.
 @param queueCount Maxmium queue count, should in range (1, 32) or default 0
 @return A new pool, or nil if an error occurs.
 */
- (instancetype)initWithName:(NSString *)name
                  queueCount:(NSUInteger)queueCount;

/// Pool's name.
@property (nonatomic, readonly) NSString *name;

/// Get a serial queue from pool.
- (dispatch_queue_t)queueWithQOS:(NSQualityOfService)qos;

@end

/**
 * use default global singleton pool instance enque block
 */
void XZHAsyncDefaultPoolWithQOSUserInteractive(void (^block)(void));
void XZHAsyncDefaultPoolWithQOSUserInitiated(void (^block)(void));
void XZHAsyncDefaultPoolWithQOSUtility(void (^block)(void));
void XZHAsyncDefaultPoolWithQOSBackgroud(void (^block)(void));
void XZHAsyncDefaultPoolWithQOSDefault(void (^block)(void));

/**
 * use new pool instance enque block, and when not use set `pool instance = nil` to release pool 
 */
void XZHAsyncPoolWithQOSUserInteractive(XZHDispatchQueuePool *pool, void (^block)(void));
void XZHAsyncPoolWithQOSUserInitiated(XZHDispatchQueuePool *pool, void (^block)(void));
void XZHAsyncPoolWithQOSUtility(XZHDispatchQueuePool *pool, void (^block)(void));
void XZHAsyncPoolWithQOSBackgroud(XZHDispatchQueuePool *pool, void (^block)(void));
void XZHAsyncPoolWithQOSDefault(XZHDispatchQueuePool *pool, void (^block)(void));

NS_ASSUME_NONNULL_END

#endif /** XZHGCDDispatcher_H */
