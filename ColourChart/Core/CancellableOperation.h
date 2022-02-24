//
//  CancellableOperation.h
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-06-03.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CancellableOperation : NSOperation
{
    NSString *record;
}

- (id)initWithPFQuery:(NSString*)record;

@end
