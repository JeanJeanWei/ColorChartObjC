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
- (BOOL)saveData:(NSString*)name ColorHex:(NSString*)hex R:(int)r G:(int)g B:(int)b;
- (BOOL)bulkSave:(NSArray*)name Hex:(NSArray*)hex R:(NSArray*)r G:(NSArray*)g B:(NSArray*)b;
- (NSMutableDictionary*)getData;
- (void)loadColorData:(NSMutableArray*)name Hex:(NSMutableArray*)hex R:(NSMutableArray*)r G:(NSMutableArray*)g B:(NSMutableArray*)b;
- (BOOL)dbExist;
- (void)removeDbFile;
@end
