//
//  StartupController.m
//  Common Framework
//
//  Created by Jean-Jean Wei on 12-05-25.
//  Copyright (c) 2012 Ice Whale. All rights reserved.
//

#import "StartupController.h"
#import "MainViewController.h"
#import "ColourViewController.h"
#import <Parse/Parse.h>
#import "DBManager.h"
#import "ColorCodeController.h"
#import "OperationQueueManager.h"
#import "CancellableOperation.h"


@implementation StartupController

+ (StartupController*)instance
{
    static StartupController* instance = nil;
    
    if (!instance)
    {
        instance = [StartupController new];
    }
    
    return instance;
}



- (UIViewController*)startingViewController
{
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];
//    PFQuery *query = [PFQuery queryWithClassName:@"ColorCodes"];
//    query.limit = 500;
//    
//    
//    for (int i=0; i<2; i++)
//    {
//        query.skip = i*500;
//        CancellableOperation *op = [[CancellableOperation alloc] initWithPFQuery:query];
//        [OperationQueueManager.instance addToQueue:op];
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            if (!error) {
//                
//                bool success = DBManager.instance.createDB;
//                if (success) {
//                    
//                    
//                    // The find succeeded.
//                    NSLog(@"Successfully retrieved %lu scores.", objects.count);
//                    // Do something with the found objects
//                    for (PFObject *object in objects) {
//                        [DBManager.instance saveData:object[@"Name"] ColorHex:object[@"Hex"]];
//                        NSLog([object[@"Hex"] substringToIndex:2]);
//                        NSLog([object[@"Hex"] substringWithRange:NSMakeRange(2, 2)]);
//                        NSLog([object[@"Hex"] substringFromIndex:4]);
//                        
//                        NSLog(@"%d",[self parseHexToInt:[object[@"Hex"] substringToIndex:2]] );
//                        NSLog(@"%d",[self parseHexToInt:[object[@"Hex"] substringWithRange:NSMakeRange(2, 2)]]);
//                        NSLog(@"%d",[self parseHexToInt:[object[@"Hex"] substringFromIndex:4]]);
//                        
//                        NSLog(@"Hex:%@ Name:%@", object[@"Hex"], object[@"Name"]);
//                    }
//                    [ColorCodeController.instance parseColorCode];
//                }
//            } else {
//                // Log details of the failure
//                NSLog(@"Error: %@ %@", error, [error userInfo]);
//            }
//        }];

//    }
    
    if (!DBManager.instance.dbExist)
    {
        [DBManager.instance createDB];
        for (int i=0; i<2; i++)
        {
            PFQuery *query = [PFQuery queryWithClassName:@"ColorCodes"];
            query.limit = 600;
            query.skip = i*600;
            CancellableOperation *op = [[CancellableOperation alloc] initWithPFQuery:query];
            [OperationQueueManager.instance addToQueue:op];
        }
    }
    
    ColourViewController *viewController = [ColourViewController new];
    
//    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
//    [navigationController setNavigationBarHidden:YES];
 
    
    return viewController;
}




@end
