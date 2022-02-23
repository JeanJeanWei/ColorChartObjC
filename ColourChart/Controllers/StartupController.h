//
//  StartupController.h
//  Common Framework
//
//  Created by JJ Wei
//  Copyright (c) 2012 Ice Whale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StartupController : NSObject 
{

}
+ (StartupController*)instance;

// update to specify the starting view controller for the application
- (UIViewController*)startingViewController;
 
@end
