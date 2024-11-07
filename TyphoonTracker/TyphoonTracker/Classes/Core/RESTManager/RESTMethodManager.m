//
//  RESTMethodManager.m
//  VertexApp
//
//  Created by Mary Rose Oh on 6/3/13.
//  Copyright (c) 2013 Dungeon Innovations. All rights reserved.
//

#import "RESTMethodManager.h"


@implementation RESTMethodManager

@synthesize userId;
@synthesize username;
@synthesize token;

@synthesize httpResponseCode;


#pragma mark - Handling user tokens
-(void) initUserAccountInformation
{
  //Initialize urlConfigurationSQLManager
  urlConfigurationSQLManager = [URLConfigurationManager alloc];
  
  /*
  //Get logged user userAccountInformation
  userAccountInfoSQLManager = [UserAccountInfoManager alloc];
  userAccountsObject        = [UserAccountsObject alloc];
  userAccountsObject        = [userAccountInfoSQLManager getUserAccountInfo];
  
  userId   = userAccountsObject.userId;
  username = userAccountsObject.username;
  token    = userAccountsObject.token;
   //*/
}


#pragma mark - POST (Create) method implementation
-(int) postMethod: (NSString *) URL
                 : (NSMutableDictionary *) postRequestJSON
                 //httpHeaderFields
{
  [self initUserAccountInformation];
  
  NSLog(@"REST POST");
  NSError *error   = [[NSError alloc] init];
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postRequestJSON
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
  NSLog(@"jsonData Request: %@", jsonData);
  
  NSString *jsonString = [[NSString alloc] initWithData:jsonData
                               encoding:NSUTF8StringEncoding];
  NSLog(@"jsonString Request: %@", jsonString);
  
  NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                      requestWithURL:[NSURL URLWithString:URL]];
  
  //POST method - Create
  [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  //[postRequest setValue:token forHTTPHeaderField:@"token"];
  //[postRequest setValue:username forHTTPHeaderField:@"username"];
  [postRequest setHTTPMethod:@"POST"];
  [postRequest setHTTPBody:[NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]]];
  NSLog(@"%@", postRequest);
  
  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:postRequest
                                                                delegate:self];
  
  [connection start];
  
  return httpResponseCode;
}


#pragma mark - PUT (Update) method implementation
-(int) putMethod: (NSString *) URL
                : (NSMutableDictionary *) putRequestJSON
                //httpHeaderFields
{
  [self initUserAccountInformation];
  
  NSLog(@"REST PUT");
  NSError *error = [[NSError alloc] init];
  
  NSData *jsonData = [NSJSONSerialization
                      dataWithJSONObject:putRequestJSON
                                 options:NSJSONWritingPrettyPrinted
                                   error:&error];
  NSLog(@"jsonData Request: %@", jsonData);
  
  NSString *jsonString = [[NSString alloc]
                          initWithData:jsonData
                              encoding:NSUTF8StringEncoding];
  NSLog(@"jsonString Request: %@", jsonString);
  
  NSMutableURLRequest *putRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:URL]];
  
  //PUT method - Update
  [putRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  //[putRequest setValue:token forHTTPHeaderField:@"token"];
  //[putRequest setValue:username forHTTPHeaderField:@"username"];
  [putRequest setHTTPMethod:@"PUT"];
  [putRequest setHTTPBody:[NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]]];
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:putRequest
                                        delegate:self];
  
  [connection start];
  
  return httpResponseCode;
}


#pragma mark - GET (Read) method implementation
-(NSMutableDictionary *) getMethod: (NSString *) URL
                    //get endpoint connection for what module
{
  [self initUserAccountInformation];
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:URL]];
  
  [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  //[getRequest setValue:token forHTTPHeaderField:@"token"];
  //[getRequest setValue:username forHTTPHeaderField:@"username"];
  [getRequest setHTTPMethod:@"GET"];
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:getRequest
                                        delegate:self];
  [connection start];
  
  NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
  NSError *error = [[NSError alloc] init];
  
  NSData *responseData = [NSURLConnection
                          sendSynchronousRequest:getRequest
                               returningResponse:&urlResponse
                                           error:&error];
  
  NSMutableDictionary *getResponseJSON = [[NSMutableDictionary alloc] init];
  
  if(responseData == nil)
  {
    //Show an alert if connection is not available
    UIAlertView *responseDataAlert = [[UIAlertView alloc]
                                        initWithTitle:@"Warning"
                                              message:@"No network connection detected. Please try again later."
                                             delegate:nil     
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [responseDataAlert show];
  }
  else
  {
    getResponseJSON = [NSJSONSerialization
                       JSONObjectWithData:responseData
                                  options:kNilOptions
                                    error:&error];
    //NSLog(@"getResponseJSON: %@", getResponseJSON);
  }
  
  return getResponseJSON;
}


#pragma mark - DELETE (Delete) method implementation
-(int) deleteMethod: (NSString *) URL
{
  NSMutableURLRequest *deleteRequest = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:URL]];
  
  [deleteRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  //[deleteRequest setValue:token forHTTPHeaderField:@"token"];
  //[deleteRequest setValue:username forHTTPHeaderField:@"username"];
  [deleteRequest setHTTPMethod:@"DELETE"];
  NSLog(@"%@", deleteRequest);
  
  NSURLConnection *connection = [[NSURLConnection alloc]
                                 initWithRequest:deleteRequest
                                        delegate:self];
  [connection start];
  
  NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
  NSError *error = [[NSError alloc] init];
  
  NSData *responseData = [NSURLConnection
                          sendSynchronousRequest:deleteRequest
                               returningResponse:&urlResponse
                                           error:&error];
  
  if (responseData == nil)
  {
    //Show an alert if connection is not available
    UIAlertView *deleteMethodAlert = [[UIAlertView alloc]
                                             initWithTitle:@"Warning"
                                                   message:@"Item not deleted. Please try again later."
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [deleteMethodAlert show];
  }
  else
  {
    UIAlertView *deleteMethodAlert = [[UIAlertView alloc]
                                             initWithTitle:@"Delete"
                                                   message:@"Item deleted."
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [deleteMethodAlert show];
  }

  return httpResponseCode;
}


#pragma mark - Connection didFailWithError
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  NSLog(@"connection didFailWithError: %@", [error localizedDescription]);
}


#pragma mark - Connection didReceiveResponse
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  NSHTTPURLResponse *httpResponse;
  httpResponse     = (NSHTTPURLResponse *)response;
  httpResponseCode = [httpResponse statusCode];
  NSLog(@"httpResponse status code: %d", httpResponseCode);
}


@end
