//
//  DBManager.m
//  ColourChart
//
//  Created by Jean-Jean Wei on 2015-04-16.
//  Copyright (c) 2015 Ice Whale. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;
NSString *dbFilename = @"color_codes.db";
NSString *ColorTable = @"Color";
+ (DBManager*)instance
{
    static DBManager* instance = nil;
    
    if (!instance)
    {
        instance = [DBManager new];
    }
    [instance getDbPath];
    return instance;
}

- (void)getDbPath
{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:dbFilename]];
}

- (BOOL)dbExist
{
    bool exist = true;
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
        exist = false;
    return exist;
}

- (void)removeDbFile
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([filemgr fileExistsAtPath: databasePath])
    {
        [filemgr removeItemAtPath:databasePath error:&error];
    }
}

- (BOOL)createDB
{
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "create table if not exists Color (name text, hex text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL)saveData:(NSString*)name ColorHex:(NSString*)hex
{
    const char *dbpath = [databasePath UTF8String];
    bool success = false;
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into %@ (name, hex) values (\"%@\",\"%@\")",ColorTable, name, hex];
        NSLog(@"insertSQL : %@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
        }
        sqlite3_reset(statement);
        sqlite3_close(database);
    }
    return success;
}

- (BOOL)saveChunk:(NSDictionary*)hexcode
{
    const char *dbpath = [databasePath UTF8String];
    bool success = false;
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        for (NSString *key in hexcode)
        {
            NSString *colorName = [hexcode objectForKey:key];
            NSString* hex = key;
            NSString *insertSQL = [NSString stringWithFormat:@"insert into %@ (name, hex) values (\"%@\",\"%@\")",ColorTable, colorName, hex];
            NSLog(@"insertSQL : %@",insertSQL);
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success = true;
            }
            else
            {
                success = false;
            }
            sqlite3_reset(statement);
        }
        
        
        //sqlite3_close(database);
    }
    return success;
}

- (NSDictionary*)getData
{
    bool success = false;
    NSMutableDictionary *colorHex = [NSMutableDictionary new];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select name, hex from %@",ColorTable];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                NSString *hex = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                
                [colorHex setValue:name forKey:hex];
                
                success = true;
            }
            
            sqlite3_reset(statement);
            sqlite3_close(database);
        }
    }
    return colorHex;
}

@end
