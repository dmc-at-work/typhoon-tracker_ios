//
//  EmergencyNumberObject.h
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 10/13/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmergencyNumberObject : NSObject
{
  NSString *country;
  NSString *name;
  NSString *number;
}

@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *number;


+(id) country :(NSString *)country
         name :(NSString *)name
       number :(NSString *)number;

@end
