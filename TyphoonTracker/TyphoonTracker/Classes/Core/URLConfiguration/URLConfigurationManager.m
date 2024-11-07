//
//  URLConfigurationManager.m
//  VertexApp
//
//  Created by Mary Rose Oh on 6/3/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "URLConfigurationManager.h"


@implementation URLConfigurationManager

@synthesize urlPath;


#pragma mark - SQLite Operations
#pragma mark - Open the db
-(void) openDB
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
  
  if(sqlite3_open([[[paths objectAtIndex:0] stringByAppendingPathComponent:@"di_typhoon_tracker.sql"] UTF8String], &db) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSLog(@"di_typhoon_tracker.sql failed to open");
  }
  else
  {
    NSLog(@"di_typhoon_tracker.sql opened");
  }
}


#pragma mark - Create url_configuration table
-(void) createTable:(NSString *)url_configuration
         withField1:(NSString *)protocol
         withField2:(NSString *)hostname
         withField3:(NSString *)port
         withField4:(NSString *)project
{
  [self openDB];
  
  char *err;
  NSString *sql = [NSString stringWithFormat:
                   @"CREATE TABLE"
                   @"  IF NOT EXISTS"
                   @"  '%@'"
                   @"  ( '%@' TEXT"
                   @"  , '%@' TEXT"
                   @"  , '%@' TEXT"
                   @"  , '%@' TEXT"
                   @"  );"
                   , url_configuration
                   , protocol
                   , hostname
                   , port
                   , project];
  
  if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSLog(@"Could not create url_configuration table.");
  }
  else
  {
    NSLog(@"url_configuration created.");
  }
}


#pragma mark - Collect URL configuration data from configuration and save to db
-(void) saveURLConfiguration: (NSString *) protocol
                            : (NSString *) hostname
                            : (NSString *) port
                            : (NSString *) project
{
  [self openDB];
  
  //Truncate url_configuration first to remove unecessary info, only save info for current configuration
  [self truncateURLConfiguration];
  
  NSString *sql = [NSString stringWithFormat:
                   @"INSERT INTO"
                   @"  url_configuration"
                   @"  ( 'protocol'"
                   @"  , 'hostname'"
                   @"  , 'port'"
                   @"  , 'project'"
                   @"  )"
                   @" VALUES"
                   @"  ( '%@'"
                   @"  , '%@'"
                   @"  , '%@'"
                   @"  , '%@')"
                   , protocol
                   , hostname
                   , port
                   , project];
  
  char *err;
  if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSLog(@"Could not update the table.");
  }
  else
  {
    NSLog(@"Table updated.");
  }
}


#pragma mark - Get URL configuration and store it in urlPath
-(NSString *) getURLConfiguration
{
  [self openDB];
  
  //url_configuration table only stores the information for the current url configuration
  NSString *sql = [NSString stringWithFormat:
                   @"SELECT * FROM url_configuration"];
  
  sqlite3_stmt *statement;

  if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
  {
    while(sqlite3_step(statement) == SQLITE_ROW)
    {
      //protocol
      char *field1 = (char *) sqlite3_column_text(statement, 0);
      NSString *protocol = [[NSString alloc] initWithUTF8String:field1];
      if([protocol isEqual:@"null"])
      {
        protocol = @"";
      }
      
      //hostname
      char *field2 = (char *) sqlite3_column_text(statement, 1);
      NSString *hostname = [[NSString alloc] initWithUTF8String:field2];
      if([hostname isEqual:@"null"])
      {
        hostname = @"";
      }
      
      //*
      //port
      char *field3 = (char *) sqlite3_column_text(statement, 2);
      NSString *port = [[NSString alloc] initWithUTF8String:field3];
      if([port isEqual:@"null"])
      {
        port = @"";
      }
      //*/
      
      //project
      char *field4 = (char *) sqlite3_column_text(statement, 3);
      NSString *project = [[NSString alloc] initWithUTF8String:field4];
      if([project isEqual:@"null"])
      {
        project = @"";
      }
      
      //Construct urlPath
      urlPath = [[NSString alloc] initWithFormat:
                 @"%@%@%@%@"
                 , protocol
                 , hostname
                 , port
                 , project];
    }
  }
  return urlPath;
}


#pragma mark - Get concatenated protocol and hostname only
-(NSString *) getURLHostname
{
  [self openDB];
  
  //url_configuration table only stores the information for the current url configuration
  NSString *sql = [NSString stringWithFormat:
                   @"SELECT * FROM url_configuration"];
  
  sqlite3_stmt *statement;
  
  if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
  {
    while(sqlite3_step(statement) == SQLITE_ROW)
    {
      //protocol
      char *field1 = (char *) sqlite3_column_text(statement, 0);
      NSString *protocol = [[NSString alloc] initWithUTF8String:field1];
      if([protocol isEqual:@"null"])
      {
        protocol = @"";
      }
      
      //hostname
      char *field2 = (char *) sqlite3_column_text(statement, 1);
      NSString *hostname = [[NSString alloc] initWithUTF8String:field2];
      if([hostname isEqual:@"null"])
      {
        hostname = @"";
      }
      
      //Construct urlPath
      urlPath = [[NSString alloc] initWithFormat:
                 @"%@%@"
                 , protocol
                 , hostname];
    }
  }
  return urlPath;
}


#pragma mark - Truncate url_configuration table
-(void) truncateURLConfiguration
{
  [self openDB];
  
  char *err;
  NSString *sql = [NSString stringWithFormat:
                   @"DELETE FROM url_configuration"];
  
  if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK)
  {
    sqlite3_close(db);
    NSLog(@"Could not truncate url_configuration table.");
  }
  else
  {
    NSLog(@"url_configuration table truncated.");
  }
}


@end
