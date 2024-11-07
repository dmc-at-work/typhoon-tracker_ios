//
//  RESTMethodManager.h
//  VertexApp
//
//  Created by Mary Rose Oh on 6/3/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "URLConfigurationManager.h"
//#import "UserAccountInfoManager.h"
//#import "UserAccountsObject.h"


@interface RESTMethodManager : NSObject
{
  URLConfigurationManager *urlConfigurationSQLManager;
  /*
  UserAccountInfoManager *userAccountInfoSQLManager;
  UserAccountsObject *userAccountsObject;
   //*/
}


//Create
-(int) postMethod: (NSString *) URL
                 : (NSMutableDictionary *) postRequest;

//Update
-(int) putMethod: (NSString *) URL
                : (NSMutableDictionary *) putRequest;

//Read
-(NSMutableDictionary *) getMethod: (NSString *) URL;


//Delete
-(int) deleteMethod: (NSString *) URL;


@property int httpResponseCode;

@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *token;


@end