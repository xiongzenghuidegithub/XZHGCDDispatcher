//
//  YYDispatchQueueManager.m
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/7/18.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "YYDispatchQueuePool.h"
#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>

#define MAX_QUEUE_COUNT 32

static inline qos_class_t
NSQualityOfServiceToQOSClass(NSQualityOfService qos) {
  switch (qos) {
    case NSQualityOfServiceUserInteractive: return QOS_CLASS_USER_INTERACTIVE;
    case NSQualityOfServiceUserInitiated: return QOS_CLASS_USER_INITIATED;
    case NSQualityOfServiceUtility: return QOS_CLASS_UTILITY;
    case NSQualityOfServiceBackground: return QOS_CLASS_BACKGROUND;
    case NSQualityOfServiceDefault: return QOS_CLASS_DEFAULT;
    default: return QOS_CLASS_UNSPECIFIED;
  }
}

typedef struct {
  const char *name;
  void **queues;
  uint32_t queueCount;
  int32_t counter;
} YYDispatchContext;

static YYDispatchContext *
YYDispatchContextCreate(const char *name,
                        uint32_t queueCount,
                        NSQualityOfService qos)
{
  // alloc struct context
  YYDispatchContext *context = malloc(sizeof(YYDispatchContext));
  if (!context) return NULL;
  
  // alloc struct context->array
  context->queues =  malloc(queueCount * sizeof(void*));
  if (!context->queues) {
    free(context);
    return NULL;
  }
  
  // alloc struct context->array[i]
  dispatch_qos_class_t qosClass = NSQualityOfServiceToQOSClass(qos);
  char buf[512];
  for (NSUInteger i = 0; i < queueCount; i++)
  {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, qosClass, 0); // 1
    memset(buf, 0, 512);
    sprintf(buf, "%s[%lu]", name, (unsigned long)i);
    dispatch_queue_t queue = dispatch_queue_create(buf, attr);
    context->queues[i] = (__bridge_retained void*)(queue); // bridge retain => 1->2
  } // 2->1
  context->queueCount = queueCount;
  
  // alloc struct context->name
  if (name) {
    context->name = strdup(name);
  }
  
  return context;
}

static void
YYDispatchContextRelease(YYDispatchContext *context)
{
  if (!context) return;
  
  if (context->queues)
  {
    // free array[i]
    for (NSUInteger i = 0; i < context->queueCount; i++)
    {
      void *queuePointer = context->queues[i];
      dispatch_queue_t queue = (__bridge_transfer dispatch_queue_t)(queuePointer); // bridge transfer(relase) => 1->2->1（local）
      const char *name = dispatch_queue_get_label(queue);
      if (name) strlen(name); // avoid compile warning
      queue = nil; // release local
    }
    
    // free array
    free(context->queues);
    context->queues = NULL;
  }
  
  // free name
  if (context->name)
    free((void *)context->name);
  
  // free struct context
  free(context);
}

static dispatch_queue_t
YYDispatchContextGetQueue(YYDispatchContext *context) {
  if (!context) return nil;
  uint32_t counter = (uint32_t)OSAtomicIncrement32(&context->counter);
  void *queue = context->queues[counter % context->queueCount];
  return (__bridge dispatch_queue_t)(queue);
}

@implementation YYDispatchQueueContext {
@public
  YYDispatchContext *_context;
}

- (void)dealloc {
  if (!_context) return;
  YYDispatchContextRelease(_context);
  _context = NULL;
}

- (instancetype)initWithName:(NSString *)name queueCount:(NSUInteger)queueCount qos:(NSQualityOfService)qos {
  if (queueCount == 0 || queueCount > MAX_QUEUE_COUNT) return nil;
  self = [super init];
  _context = YYDispatchContextCreate(name.UTF8String, (uint32_t)queueCount, qos);
  if (!_context) return nil;
  _name = name;
  return self;
}

- (dispatch_queue_t)queue {
  return YYDispatchContextGetQueue(_context);
}

@end
