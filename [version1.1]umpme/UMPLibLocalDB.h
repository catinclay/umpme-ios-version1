//
//  UMPLibLocalDB.h
//  [version1.1]umpme
//
//  Created by Zhaonan Li on 3/15/14.
//  Copyright (c) 2014 umpme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "UMPCsntManager.h"

@interface UMPLibLocalDB : NSObject {
    sqlite3 *currDB;
}

@property (strong, nonatomic) NSString *localDBName;

+ (id)shareLocalDBManager;

// Get the DB Path
- (NSString *)getLocalDBPath;

// Create DB
- (BOOL)createLocalDB;

// Delete DB
- (BOOL)deleteLocalDB;

// Open DB
- (BOOL)openLocalDB;

// Close DB
- (BOOL)closeLocalDB;

// Execute SQL
- (BOOL)executeSQLOnLocalDB:(NSString *)sqlSentence;

// Create Table
- (BOOL)createTableOnLocalDB:(NSString *)sqlSentence;

// Insert Data
- (BOOL)insertDataOnLocalDB:(NSString *)sqlSentence;

// Update Data
- (BOOL)updateDataOnLocalDB:(NSString *)sqlSentence;

// Query Data
- (NSMutableArray *)querySingleRowDataOnLocalDB:(NSString *)sqlSentence;

// Clear table
- (BOOL)clearTableOnLocalDB:(NSString *)tableName;

// Drop table
- (BOOL)dropTableOnLocalDB:(NSString *)tableName;


@end
