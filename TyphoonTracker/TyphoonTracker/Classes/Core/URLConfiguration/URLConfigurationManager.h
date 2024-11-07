//
//  URLConfigurationManager.h
//  VertexApp
//
//  Created by Mary Rose Oh on 6/3/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "sqlite3.h"

@interface URLConfigurationManager : NSObject
{
  sqlite3 *db;
}

/*
 Table Structure
 ------------------------
 url_configuration
 -------------------------
 - protocol | text
 - hostname | text
 - port     | text
 - project  |int
 //*/


-(void) openDB;

-(void) createTable: (NSString *) url_configuration
         withField1: (NSString *) protocol
         withField2: (NSString *) hostname
         withField3: (NSString *) port
         withField4: (NSString *) project;

-(void) saveURLConfiguration: (NSString *) protocol
                            : (NSString *) hostname
                            : (NSString *) port
                            : (NSString *) project;

-(NSString *) getURLConfiguration;

-(NSString *) getURLHostname;

-(void) truncateURLConfiguration;

@property (strong, nonatomic) NSString *urlPath;


@end






