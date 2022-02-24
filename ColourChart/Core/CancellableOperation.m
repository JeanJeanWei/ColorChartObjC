//
//  CancellableOperation.m
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-06-03.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import "CancellableOperation.h"
#import "ColorCodeController.h"
#import "DBManager.h"

@implementation CancellableOperation

- (id)initWithPFQuery:(NSString*)str
{
    if (![super init])
        return nil;
    
    record = str;
    return self;
}

- (void)main {
    // a lengthy operation
    @autoreleasepool
    {
        if (self.isCancelled)
        return;
        
       
        //NSArray *objects = [query findObjects]; findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            //if (objects) {
                
            //    bool success = DBManager.instance.createDB;
           //     if (success) {
                    
                    
                    // The find succeeded.
                    //NSLog(@"Successfully retrieved %lu scores.", objects.count);
                    // Do something with the found objects
//                    for (PFObject *object in objects) {
//                        [DBManager.instance saveData:object[@"Name"] ColorHex:object[@"Hex"]];
//                        NSLog([object[@"Hex"] substringToIndex:2]);
//                        NSLog([object[@"Hex"] substringWithRange:NSMakeRange(2, 2)]);
//                        NSLog([object[@"Hex"] substringFromIndex:4]);
                        
//                        NSLog(@"%d",[self parseHexToInt:[object[@"Hex"] substringToIndex:2]] );
//                        NSLog(@"%d",[self parseHexToInt:[object[@"Hex"] substringWithRange:NSMakeRange(2, 2)]]);
//                        NSLog(@"%d",[self parseHexToInt:[object[@"Hex"] substringFromIndex:4]]);
                        
           //             NSLog(@"Hex:%@ Name:%@", object[@"Hex"], object[@"Name"]);
          //          }
                    
                    //
           //     }
                //NSLog(@"objects >>>>> :%i", objects.count);
        //    } else {
                // Log details of the failure
                //NSLog(@"Error: %@ %@", error, [error userInfo]);
       //     }
        //}];
    }
}

//- (int)parseHexToInt:(NSString*)hex
//{
//    unsigned result = 0;
//    NSScanner *scanner = [NSScanner scannerWithString:hex];
//    
//    //[scanner setScanLocation:1]; // bypass '#' character
//    [scanner scanHexInt:&result];
//    return result;
//}

@end
