//
//  ZHGCDDispatcher.m
//  ZHDispatchQueuePoolDemo
//
//  Created by xiongzenghui on 2018/9/27.
//  Copyright © 2018年 xiongzenghui. All rights reserved.
//

#import "XZHGCDDispatcher.h"
#import "YYDispatchQueuePool.h"

@implementation XZHDispatchQueuePool {
  YYDispatchQueueContext *_UserInteractiveContext;
  YYDispatchQueueContext *_UserInitiatedContext;
  YYDispatchQueueContext *_UtilityContext;
  YYDispatchQueueContext *_BackgroundContext;
  YYDispatchQueueContext *_DefaultContext;
}

- (void)dealloc {
  _UserInteractiveContext = nil;
  _UserInitiatedContext = nil;
  _UtilityContext = nil;
  _BackgroundContext = nil;
  _DefaultContext = nil;
}

- (instancetype)initWithName:(NSString *)name
                  queueCount:(NSUInteger)queueCount {
  self = [super init];
  if (!self) return nil;
  
  NSUInteger count = (int)[NSProcessInfo processInfo].activeProcessorCount;
  count = (count > queueCount) ? count : queueCount;
  
  _UserInteractiveContext = [[YYDispatchQueueContext alloc] initWithName:[NSString stringWithFormat:@"%@.user-interactive", name]
                                                              queueCount:count
                                                                     qos:NSQualityOfServiceUserInteractive];
  
  _UserInitiatedContext = [[YYDispatchQueueContext alloc] initWithName:[NSString stringWithFormat:@"%@.user-initiated", name]
                                                            queueCount:count
                                                                   qos:NSQualityOfServiceUserInitiated];
  
  _UtilityContext = [[YYDispatchQueueContext alloc] initWithName:[NSString stringWithFormat:@"%@.utility", name]
                                                      queueCount:count
                                                             qos:NSQualityOfServiceUtility];
  
  _BackgroundContext = [[YYDispatchQueueContext alloc] initWithName:[NSString stringWithFormat:@"%@.user-background", name]
                                                         queueCount:count
                                                                qos:NSQualityOfServiceBackground];
  
  _DefaultContext = [[YYDispatchQueueContext alloc] initWithName:[NSString stringWithFormat:@"%@.default", name]
                                                      queueCount:count
                                                             qos:NSQualityOfServiceDefault];
  return self;
  
}

- (dispatch_queue_t)queueWithQOS:(NSQualityOfService)qos {
  switch (qos)
  {
    case NSQualityOfServiceUserInteractive: {
      return _UserInteractiveContext.queue;
    } break;
    
    case NSQualityOfServiceUserInitiated: {
      return _UserInitiatedContext.queue;
    } break;
    
    case NSQualityOfServiceUtility: {
      return _UtilityContext.queue;
    } break;
    
    case NSQualityOfServiceBackground: {
      return _BackgroundContext.queue;
    } break;
      
    case NSQualityOfServiceDefault:
    default: {
      return _DefaultContext.queue;
    } break;
  }
}

+ (dispatch_queue_t)defaultQueueWithQOS:(NSQualityOfService)qos {
  static XZHDispatchQueuePool *_ins;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _ins = [[XZHDispatchQueuePool alloc] initWithName:@"xzh.dispatcher"
                                           queueCount:0];
  });
  
  return [_ins queueWithQOS:qos];
}

@end

#pragma mark -

static dispatch_queue_t __inline__ __attribute__((always_inline))
XZHDispatchQueueGetFromDefaultPoolWithQOS(NSQualityOfService qos) {
  return [XZHDispatchQueuePool defaultQueueWithQOS:qos];
}

static dispatch_queue_t __inline__ __attribute__((always_inline))
XZHDispatchQueueGetFromPoolWithQOS(XZHDispatchQueuePool *pool, NSQualityOfService qos) {
  return [pool queueWithQOS:qos];
}

static void __inline__ __attribute__((always_inline))
XZHAsyncPool(dispatch_queue_t queue, void (^block)(void)) {
  if (!queue) queue = dispatch_get_global_queue(0, 0); // ensure a not nil queue enque block
  dispatch_async(queue, block);
}

#pragma mark -

void XZHAsyncDefaultPoolWithQOSUserInteractive(void (^block)(void)) {
  XZHAsyncPool(XZHDispatchQueueGetFromDefaultPoolWithQOS(NSQualityOfServiceUserInteractive), block);
}

void XZHAsyncDefaultPoolWithQOSUserInitiated(void (^block)(void)) {
  XZHAsyncPool(XZHDispatchQueueGetFromDefaultPoolWithQOS(NSQualityOfServiceUserInitiated), block);
}

void XZHAsyncDefaultPoolWithQOSUtility(void (^block)(void)) {
  XZHAsyncPool(XZHDispatchQueueGetFromDefaultPoolWithQOS(NSQualityOfServiceUtility), block);
}

void XZHAsyncDefaultPoolWithQOSBackgroud(void (^block)(void)) {
  XZHAsyncPool(XZHDispatchQueueGetFromDefaultPoolWithQOS(NSQualityOfServiceBackground), block);
}

void XZHAsyncDefaultPoolWithQOSDefault(void (^block)(void)) {
  XZHAsyncPool(XZHDispatchQueueGetFromDefaultPoolWithQOS(NSQualityOfServiceDefault), block);
}

#pragma mark - 

void XZHAsyncPoolWithQOSUserInteractive(XZHDispatchQueuePool *pool, void (^block)(void)) {
  XZHAsyncPool(XZHDispatchQueueGetFromPoolWithQOS(pool, NSQualityOfServiceUserInteractive), block);
}

void XZHAsyncPoolWithQOSUserInitiated(XZHDispatchQueuePool *pool, void (^block)(void)) {
  XZHAsyncPool(XZHDispatchQueueGetFromPoolWithQOS(pool, NSQualityOfServiceUserInitiated), block);
}

void XZHAsyncPoolWithQOSUtility(XZHDispatchQueuePool *pool, void (^block)(void)) {
  XZHAsyncPool(XZHDispatchQueueGetFromPoolWithQOS(pool, NSQualityOfServiceUtility), block);
}

void XZHAsyncPoolWithQOSBackgroud(XZHDispatchQueuePool *pool, void (^block)(void)) {
  XZHAsyncPool(XZHDispatchQueueGetFromPoolWithQOS(pool, NSQualityOfServiceBackground), block);
}

void XZHAsyncPoolWithQOSDefault(XZHDispatchQueuePool *pool, void (^block)(void)) {
  XZHAsyncPool(XZHDispatchQueueGetFromPoolWithQOS(pool, NSQualityOfServiceDefault), block);
}
