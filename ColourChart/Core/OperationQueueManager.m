//
//  OperationQueueManager.m
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-05-19.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import "OperationQueueManager.h"

@implementation OperationQueueManager
@synthesize queue;

+ (OperationQueueManager*)instance
{
    static OperationQueueManager* instance = nil;
    
    if (!instance)
    {
        instance = [OperationQueueManager new];
        [instance createQueue];
    }
    
    return instance;
}

- (void)createQueue
{
    queue = [NSOperationQueue new];
    queue.name = @"Download Queue";
    queue.maxConcurrentOperationCount = 1;
}

- (void)addToQueue:(NSOperation*) op
{
    [queue addOperation:op];
}

- (int)opCount
{
    return (int)queue.operationCount;
}
@end
