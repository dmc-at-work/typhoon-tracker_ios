//
//  InitURLConfiguration.m
//  VertexApp
//
//  Created by Mary Rose Oh on 6/4/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

/*
............................................................................................
This class can be used to create and initialize values for the url_configuration SQLite table without manually accessing the SQLite tables for Vertex.
............................................................................................
//*/

#import "InitURLConfiguration.h"


@implementation InitURLConfiguration

@synthesize protocol;
@synthesize hostname;
@synthesize port;
@synthesize project;


#pragma mark - This method sets the value for the URL Configuration of Vertex, UPDATE and CHANGE as Necessary
-(void) setURLConfigValues
{
  protocol = @"http://";
  
  hostname = @"192.168.2.113";
  
  port = @"null";
  
  project  = @"";
}


#pragma mark - This method saves the values for the URL configuration in the SQLite table url_configuration
-(void) initURLConfigTable
{
  //setConfigValues first
  [self setURLConfigValues];
  
  //Initialize urlConfigurationSQLManager
  urlConfigurationManager = [URLConfigurationManager alloc];
  
  //SQLite operations - save user account information of logged user
  [urlConfigurationManager createTable:@"url_configuration"
                              withField1:@"protocol"
                              withField2:@"hostname"
                              withField3:@"port"
                              withField4:@"project"];
  
  [urlConfigurationManager saveURLConfiguration:protocol
                                                  :hostname
                                                  :port
                                                  :project];
}


@end
