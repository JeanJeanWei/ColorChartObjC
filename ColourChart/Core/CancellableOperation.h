//
//  CancellableOperation.h
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-06-03.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CancellableOperation : NSOperation
{
    PFQuery *query;
}

- (id)initWithPFQuery:(PFQuery*)pfQuery;

@end
