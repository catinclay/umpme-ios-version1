//
//  UMPLibLocalDB.m
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import "UMPLibLocalDB.h"

@implementation UMPLibLocalDB

+ (id)shareLocalDBManager {
    static UMPLibLocalDB *umpLocalDBManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        umpLocalDBManager = [[UMPLibLocalDB alloc] init];
    });
    return umpLocalDBManager;
}

- (id)init {
    if (self = [super init]) {
        UMPCsntManager *umpCsntManager = [UMPCsntManager shareCsntManager];
        self.localDBName = umpCsntManager.umpCsntLocalDBManager.localDBName;
    }
    return self;
}

// Get the local main path
- (NSString *)getLocalDBPath {
    // Get the main dir of sandbox.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *databasePath = [documentsPath stringByAppendingString:self.localDBName];
    
    return databasePath;
}

// Create DB
- (BOOL)createLocalDB {
    // Get the local db path.
    NSString *localDBPath = [self getLocalDBPath];
    // Create local db.
    if (sqlite3_open([localDBPath UTF8String], &currDB) == SQLITE_OK) return YES;
    else {
        if (UMPME_DEBUG) NSLog(@"[Debug][Error]Can not create the local db which is named %@", self.localDBName);
        return NO;
    }
}

// Delete DB
- (BOOL)deleteLocalDB {
    // Get the local db path.
    NSString *localDBPath = [self getLocalDBPath];
    // Delete local db.
    if([[NSFileManager defaultManager] fileExistsAtPath:localDBPath]){
        [[NSFileManager defaultManager] removeItemAtPath:localDBPath error:nil];
        return YES;
    } else {
        if (UMPME_DEBUG) NSLog(@"[Debug][Error]Can not delete the local db which is named %@", self.localDBName);
        return NO;
    }
}

// Open DB
- (BOOL)openLocalDB {
    // Get the local db path.
    NSString *localDBPath = [self getLocalDBPath];
    // Open local db.
    if (sqlite3_open([localDBPath UTF8String], &currDB) == SQLITE_OK) return YES;
    else {
        if (UMPME_DEBUG) NSLog(@"[Debug][Error]Can not open the local db which is named %@", self.localDBName);
        return NO;
    }
}

// Close DB
- (BOOL)closeLocalDB {
    if (sqlite3_close(currDB) == SQLITE_OK) {
        return YES;
    } else {
        if (UMPME_DEBUG) NSLog(@"[Debug][Error]Can not close curr db.");
        return NO;
    }
}

// Execute SQL
- (BOOL)executeSQLOnLocalDB:(NSString *)sqlSentence {
    if ([sqlSentence length] > 0) {
        char *executeSQLError;
        if (sqlite3_exec(currDB, [sqlSentence UTF8String], NULL, NULL, &executeSQLError) == SQLITE_OK) return YES;
        else {
            if (UMPME_DEBUG) NSLog(@"[Debug][Error]Can not execute the sql (%@) on the local db.", sqlSentence);
            return NO;
        }
        
    } else {
        if (UMPME_DEBUG) NSLog(@"[Debug][Error]The input of local db name is empty.");
        return NO;
    }
}

// Create Table
- (BOOL)createTableOnLocalDB:(NSString *)sqlSentence {
    return [self executeSQLOnLocalDB:sqlSentence];
}

// Insert Data
- (BOOL)insertDataOnLocalDB:(NSString *)sqlSentence {
    return [self executeSQLOnLocalDB:sqlSentence];
}

// Update Data
- (BOOL)updateDataOnLocalDB:(NSString *)sqlSentence {
    return [self executeSQLOnLocalDB:sqlSentence];
}

// Query Data
- (NSMutableArray *)querySingleRowDataOnLocalDB:(NSString *)sqlSentence {
    // sqlSentence must be "SELECT * FROM ... [WHERE ...]".
    sqlite3_stmt *sql_statement;
    NSMutableArray *queryResArray = [[NSMutableArray alloc] init];
    if (sqlite3_prepare(currDB, [sqlSentence UTF8String], -1, &sql_statement, nil) == SQLITE_OK) {
        int num_res = sqlite3_step(sql_statement);
        if (num_res == SQLITE_ROW) {
            int num_column = sqlite3_column_count(sql_statement);
            for (int i = 0; i < num_column; i ++)
                [queryResArray
                 addObject:
                 [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sql_statement, i)]];
            
            
            sqlite3_finalize(sql_statement);
            return queryResArray;
        } else {
            if (UMPME_DEBUG) NSLog(@"[Debug][Error]The num of res is not equal to the SQITE_ROW.");
            return nil;
        }
        
    } else {
        if (UMPME_DEBUG) NSLog(@"[Debug][Error]Can not execute query on the local db.");
        return nil;
    }
}

// Clear table
- (BOOL)clearTableOnLocalDB:(NSString *)tableName {
    if ([tableName length] > 0) {
        NSString *sqlSentence = [[NSString alloc] initWithFormat:@"DELETE FROM %@", tableName];
        return [self executeSQLOnLocalDB:sqlSentence];
        
    } else {
        if (UMPME_DEBUG) NSLog(@"[Debug][Error]The input of table name can not be empty.");
        return NO;
    }
}

// Drop table
- (BOOL)dropTableOnLocalDB:(NSString *)tableName {
    if ([tableName length] > 0) {
        NSString *sqlSentence = [[NSString alloc] initWithFormat:@"DROP TABLE %@", tableName];
        return [self executeSQLOnLocalDB:sqlSentence];
        
    } else {
        if (UMPME_DEBUG) NSLog(@"[Debug][Error]The input of table name can not be empty.");
        return NO;
    }
}

@end
