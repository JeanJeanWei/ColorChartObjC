//
//  DBManager.h
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-04-16.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+ (DBManager*)instance;
- (BOOL)createDB;
- (BOOL)saveData:(NSString*)name ColorHex:(NSString*)hex;
- (NSMutableDictionary*)getData;
- (BOOL)dbExist;
- (void)removeDbFile;
@end
