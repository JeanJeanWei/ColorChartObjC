//
//  ColorCodeController.m
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-04-22.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import "ColorCodeController.h"
#import "DBManager.h"
#import "OperationQueueManager.h"
#import "CancellableOperation.h"


@implementation ColorCodeController
@synthesize red, green, blue, name;

+ (ColorCodeController*)instance
{
    static ColorCodeController* instance = nil;
    
    if (!instance)
    {
        instance = [ColorCodeController new];
        [instance initArrays];
        [instance initHexDictionary];
    }
    
    return instance;
}

- (void)initHexDictionary
{
    hexCode = [NSMutableDictionary new];
}

- (NSMutableDictionary*)getHexDictionary
{
    return hexCode;
}

- (void)initArrays
{
    red = [NSMutableArray new];
    green = [NSMutableArray new];
    blue = [NSMutableArray new];
    name = [NSMutableArray new];
}

- (void)buildColorCodeDictionary:(NSString*)name ColorHex:(NSString*)hex
{
    [hexCode setValue:name forKey:hex];
}

- (void)parseColorCode
{
    @try
    {
        if (!hexCode || hexCode.count == 0)
            hexCode = [DBManager.instance getData];
        if (!name)
            [self initArrays];
        
        if (name.count != hexCode.count)
            [self initArrays];
        
        if (hexCode != nil && name != nil && name.count == 0)
        {
            for (NSString *key in hexCode)
            {
                NSString *colorName = [hexCode objectForKey:key];
                [name addObject:colorName];
                [red addObject:[NSNumber numberWithInteger:[self parseHexToInt:[key substringToIndex:2]]]];
                [green addObject:[NSNumber numberWithInteger:[self parseHexToInt:[key substringWithRange:NSMakeRange(2, 2)]]]];
                [blue addObject:[NSNumber numberWithInteger:[self parseHexToInt:[key substringFromIndex:4]]]];
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"NSException : %@",exception);
    }
    @finally {
        //<#Code that gets executed whether or not an exception is thrown#>
    }
    
   
}

- (int)parseHexToInt:(NSString*)hex
{
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    
    //[scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&result];
    return result;
}

- (NSString*)getColorName:(int)r g:(int)g b:(int)b
{

    [self parseColorCode];
    
    NSString *cName = [NSString new];
    double distance = 999999999;
    for (int i=0; i<name.count; i++)
    {
        int r1 = [[red objectAtIndex:i] intValue];
        int g1 = [[green objectAtIndex:i] intValue];
        int b1 = [[blue objectAtIndex:i] intValue];
        
        int r2 = pow((r-r1), 2);
        int g2 = pow((g-g1), 2);
        int b2 = pow((b-b1), 2);
        
        double d = sqrtl(r2+b2+g2)*1000;
        if(d<distance)
        {
            distance = d;
            cName = [name objectAtIndex:i];
        }
    }
    return  cName;
}
@end
