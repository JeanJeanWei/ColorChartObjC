//
//  ColorCodeController.h
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-04-22.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorCodeController : NSObject
{
    NSMutableDictionary *hexCode;
}

@property (strong) NSMutableArray* red;
@property (strong) NSMutableArray* green;
@property (strong) NSMutableArray* blue;
@property (strong) NSMutableArray* name;

+ (ColorCodeController*)instance;

- (void)buildColorCodeDictionary:(NSString*)name ColorHex:(NSString*)hex;
- (NSMutableDictionary*)getHexDictionary;
- (void)parseColorCode;
- (NSString*)getColorName:(int)r g:(int)g b:(int)b;
@end
