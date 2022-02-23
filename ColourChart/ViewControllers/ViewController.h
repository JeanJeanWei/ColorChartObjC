//
//  ViewController.h
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-01-06.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SET_X(frame, x) CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height)
#define SET_Y(frame, y) CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height)
#define SET_WIDTH(frame, w) CGRectMake(frame.origin.x, frame.origin.y, w, frame.size.height)
#define SET_HEIGHT(frame, h) CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, h)

#define GET_X(frame) frame.origin.x
#define GET_Y(frame) frame.origin.y
#define GET_WIDTH(frame) frame.size.width
#define GET_HEIGHT(frame) frame.size.height

#define iPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)


@interface ViewController : UIViewController

- (void)roundView:(UIView*)view withRadius:(float)radius andStroke:(float)stroke andColor:(UIColor*)borderColor;

@end

