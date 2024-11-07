//
//  EmergencyNumberObject.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 10/13/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "EmergencyNumberObject.h"

@implementation EmergencyNumberObject

@synthesize country;
@synthesize name;
@synthesize number;


+(id) country:(NSString *)country
         name:(NSString *)name
       number:(NSString *)number
{
  EmergencyNumberObject *emergencyNumberObject = [[self alloc] init];
  
  emergencyNumberObject.country = country;
  emergencyNumberObject.name    = name;
  emergencyNumberObject.number  = number;
  
  return emergencyNumberObject;
}


@end
