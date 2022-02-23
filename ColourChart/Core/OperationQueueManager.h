//
//  OperationQueueManager.h
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-05-19.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperationQueueManager : NSObject
{
}

@property (strong) NSOperationQueue* queue;

+ (OperationQueueManager*)instance;

- (void)addToQueue:(NSOperation*)op;
- (int)opCount;
@end
