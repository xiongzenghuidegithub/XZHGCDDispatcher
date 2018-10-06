//
//  XZHGCDDispatcherTests.m
//  XZHGCDDispatcherTests
//
//  Created by xiongzenghui on 10/05/2018.
//  Copyright (c) 2018 xiongzenghui. All rights reserved.
//

@import XCTest;
@import XZHGCDDispatcher;

@interface Tests : XCTestCase

@end

@implementation Tests {
  XZHDispatchQueuePool *_pool;
}

- (void)setUp
{
  [super setUp];
  
  _pool = [[XZHDispatchQueuePool alloc] initWithName:@"test" queueCount:0];
}

- (void)tearDown
{
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testXZHDispatchQueuePool1
{
  for (int i = 0; i < 100; i++)
  {
    XZHAsyncDefaultPoolWithQOSUserInteractive(^{
      NSLog(@"%@", [NSThread currentThread]);
    });
    
    XZHAsyncDefaultPoolWithQOSUserInitiated(^{
      NSLog(@"%@", [NSThread currentThread]);
    });
  }
}

- (void)testXZHDispatchQueuePool2
{
  for (int i = 0; i < 1000; i++)
  {
    XZHAsyncPoolWithQOSUserInteractive(_pool, ^{
      NSLog(@"%@", [NSThread currentThread]);
    });
    
    XZHAsyncPoolWithQOSUserInitiated(_pool, ^{
      NSLog(@"%@", [NSThread currentThread]);
    });
  }
  
  _pool = nil;
}

@end

