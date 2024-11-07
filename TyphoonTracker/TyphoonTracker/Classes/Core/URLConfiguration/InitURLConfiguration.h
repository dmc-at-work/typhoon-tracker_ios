//
//  InitURLConfiguration.h
//  VertexApp
//
//  Created by Mary Rose Oh on 6/4/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "URLConfigurationManager.h"


@interface InitURLConfiguration : NSObject
{
  URLConfigurationManager *urlConfigurationManager;
}

@property (strong, nonatomic) NSString *protocol;
@property (strong, nonatomic) NSString *hostname;
@property (strong, nonatomic) NSString *port;
@property (strong, nonatomic) NSString *project;


-(void) setURLConfigValues;

-(void) initURLConfigTable;


@end
