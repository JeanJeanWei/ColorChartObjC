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
#import "DBManager.h"
#import "ColorCodeController.h"
#import "OperationQueueManager.h"
#import "CancellableOperation.h"
#import "DDFileReader.h"

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
        if (!DBManager.instance.dbExist)
        {
            [DBManager.instance createDB];
            NSString* filePath = @"Colors";//file path...
            NSString* fileRoot = [[NSBundle mainBundle]
                           pathForResource:filePath ofType:@"txt"];
            
            DDFileReader * reader = [[DDFileReader alloc] initWithFilePath:fileRoot];
            [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
              NSLog(@"read line: %@", line);
                NSArray *listItems = [line componentsSeparatedByString:@":"];
                [ColorCodeController.instance buildColorCodeDictionary:listItems[1] ColorHex:listItems[0]];
            }];
            [DBManager.instance saveChunk:[ColorCodeController.instance getHexDictionary]];
            
//                CancellableOperation *op = [[CancellableOperation alloc] initWithPFQuery:query];
//                [OperationQueueManager.instance addToQueue:op];
    
        }
    ColourViewController *viewController = [ColourViewController new];
    
//    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:menuViewController];
//    [navigationController setNavigationBarHidden:YES];
 
    
    return viewController;
}


@end
