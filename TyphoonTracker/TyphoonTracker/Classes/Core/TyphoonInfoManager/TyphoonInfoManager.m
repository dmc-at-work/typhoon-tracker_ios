//
//  TyphoonInfoManager.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/31/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "TyphoonInfoManager.h"

@implementation TyphoonInfoManager

@synthesize typhoonInfoJSONArray;

@synthesize geocoder;
@synthesize placemark;
@synthesize geolocation;

@synthesize httpResponseCode;

//Network Status
@synthesize internetActive;
@synthesize hostActive;


#pragma mark - Initialize Reachability
-(void) initReachability
{
  //Check for internet connection
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(checkNetworkStatus:)
                                               name:kReachabilityChangedNotification
                                             object:nil];
  
  internetReachable = [Reachability reachabilityForInternetConnection];
  [internetReachable startNotifier];
  
  //Check if a pathway to a random host exists
  hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
  [hostReachable startNotifier];
}


#pragma mark - Check device network status
-(void) checkNetworkStatus:(NSNotification *)notice
{
  //Called after network status changes
  NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
  switch (internetStatus)
  {
    case NotReachable:
    {
      NSLog(@"The internet is down.");
      internetActive = NO;
      
      break;
    }
    case ReachableViaWiFi:
    {
      NSLog(@"The internet is working via WIFI.");
      internetActive = YES;
      
      break;
    }
    case ReachableViaWWAN:
    {
      NSLog(@"The internet is working via WWAN.");
      internetActive = YES;
      
      break;
    }
  }
  
  NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
  switch (hostStatus)
  {
    case NotReachable:
    {
      NSLog(@"A gateway to the host server is down.");
      hostActive = NO;
      
      break;
    }
    case ReachableViaWiFi:
    {
      NSLog(@"A gateway to the host server is working via WIFI.");
      hostActive = YES;
      
      break;
    }
    case ReachableViaWWAN:
    {
      NSLog(@"A gateway to the host server is working via WWAN.");
      hostActive = YES;
      
      break;
    }
  }
}


#pragma mark - Get curent Satellite image from S3 and save in NSUserDefaults
-(NSData *) getSatelliteImage
{
  NSLog(@"TyphoonInfoManager - getSatelliteImage");
  
  NSURL *satelliteImageURL = [NSURL URLWithString:
                              @"http://di-typhoon-bucket.s3.amazonaws.com/feeds/images/satellite/globe-visible_512x512.jpg"];
  
 
  //2048x2048 resolution
  //@"http://di-typhoon-bucket.s3.amazonaws.com/feeds/images/satellite/globe-visible_2048x2048.jpg"];
  
  NSData *satelliteImageData = [NSData dataWithContentsOfURL:satelliteImageURL];
  
  //If nothing is retrieved, return image from cache
  if(satelliteImageData == nil || satelliteImageData == NULL)
  {
    satelliteImageData = [[NSUserDefaults standardUserDefaults] valueForKey:@"satelliteImageData"];
  }
  else
  {
    [[NSUserDefaults standardUserDefaults] setValue:satelliteImageData forKey:@"satelliteImageData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  
  return satelliteImageData;
}


#pragma mark - Get last 240 hour video in S3
-(NSData *) getSatelliteVideo
{
  NSLog(@"TyphoonInfoManager - getSatelliteVideo");
  
  NSURL *satelliteVideoURL = [NSURL URLWithString:
                              @"http://di-typhoon-bucket.s3.amazonaws.com/feeds/animation/mp4/last-240h.mp4"];
  
  NSData *satelliteVideoData = [NSData dataWithContentsOfURL:satelliteVideoURL];
  
  [[NSUserDefaults standardUserDefaults] setValue:satelliteVideoData forKey:@"satelliteVideoData"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  return satelliteVideoData;
}


#pragma mark - Get Typhoon Summary Information and store in NSUserDefaults
-(NSMutableArray *) getTyphoonInfo
{
  NSLog(@"TyphoonInfoManager - getTyphoonInfo");
  
  NSMutableArray *typhoonInfoDetailsArray;
  typhoonInfoJSONArray = [[NSMutableArray alloc] init];
  
  //Typhoon Summary URL
  NSString *rssURL = @"http://di-typhoon-bucket.s3.amazonaws.com/feeds/rssj.json";
  
  
  //TEST ONLY
  //@"http://di-typhoon-bucket.s3.amazonaws.com/feeds/old_rssj.json";
  //@"http://di-typhoon-bucket.s3.amazonaws.com/feeds/test_rssj.json";
  
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:rssURL]];
  
  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:getRequest
                                                                delegate:self];
  [connection start];
  
  NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
  NSError *error                 = [[NSError alloc] init];
  
  NSData *responseData = [NSURLConnection sendSynchronousRequest:getRequest
                                               returningResponse:&urlResponse
                                                           error:&error];
  
  //Checking for response received
  if(responseData == nil)
  {
    UIAlertView *responseDataAlert = [[UIAlertView alloc] initWithTitle:@"No Connection Detected"
                                                                message:@"Please connect to the Internet to get the updated information. Thank you."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
    [responseDataAlert show];
    
    //Disable isUpdated flag - 20140802
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isUpdated"];
  }
  else
  {
    NSMutableDictionary *rssJSONResponse = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:kNilOptions
                                                             error:&error];
    NSLog(@"rssJSONResponse: %@", rssJSONResponse);
    
    NSMutableDictionary *typhoonItems = [[rssJSONResponse valueForKey:@"channel"] valueForKey:@"items"];
    int typhoonItemsCount             = (int)[typhoonItems count];
    
    //Set lastUpdated date
    NSString *lastUpdatedDate = [[rssJSONResponse valueForKey:@"channel"] valueForKey:@"pubDate"];
    [[NSUserDefaults standardUserDefaults] setObject:lastUpdatedDate forKey:@"lastUpdated"];
    
    //Disable isUpdated flag - 20140802
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isUpdated"];
    
    //Set active typhoon/s flag and store JSON items node as NSData
    if(typhoonItemsCount > 0)
    {
      [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isThereActiveTyphoon"];
      
      [[NSUserDefaults standardUserDefaults] setObject:[[rssJSONResponse valueForKey:@"channel"] valueForKey:@"items"] forKey:@"typhoonInfoItems"];
    }
    //No active typhoons
    else
    {
      [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isThereActiveTyphoon"];
    }
    
    
    //Parse items array and get typhoon info details
    typhoonInfoDetailsArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < typhoonItemsCount; i++)
    {
      TyphoonInfoObject *typhoonInfoObject = [[TyphoonInfoObject alloc] init];
      
      //Pass URL pointing to Typhoon info.json
      typhoonInfoObject = [self getTyphoonDetailedInfo:[[typhoonItems valueForKey:@"link"] objectAtIndex:i]];
      
      if(typhoonInfoObject.typhoonId)
      {
        [typhoonInfoDetailsArray addObject:typhoonInfoObject];
      }
      else
      {
        NSLog(@"Typhoon Info == null.");
      }
    }
    
    //~ 2014 08 13
    //Save all retrieved raw typhoon JSON info in NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:typhoonInfoJSONArray forKey:@"typhoonInfoJSONArray"];
    
    
    //Synchronize changes made in NSUserDefaults
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  
  return typhoonInfoDetailsArray;
}


#pragma mark - Get Typhoon Detailed Information given URL to info.json
-(TyphoonInfoObject *) getTyphoonDetailedInfo : (NSString *) infoLink
{
  NSLog(@"getTyphoonDetailedInfo-infoLink: %@", infoLink);
  
  TyphoonInfoObject *typhoonInfoObject = [[TyphoonInfoObject alloc] init];
  
  //Update link from 'https' to 'http'
  infoLink = [infoLink stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
  NSLog(@"infoLink-http: %@", infoLink);
  
  NSMutableURLRequest *getRequest = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:infoLink]];
  
  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:getRequest
                                                                delegate:self];
  [connection start];
  
  NSHTTPURLResponse *urlResponse = [[NSHTTPURLResponse alloc] init];
  NSError *error                 = [[NSError alloc] init];
  
  NSData *responseData = [NSURLConnection sendSynchronousRequest:getRequest
                                               returningResponse:&urlResponse
                                                           error:&error];
  
  if(responseData == nil)
  {
    NSLog(@"No typhoon detailed information retrieved.");
  }
  else
  {
    NSMutableDictionary *typhoonInfoJSON = [NSJSONSerialization JSONObjectWithData:responseData
                                                                           options:kNilOptions
                                                                             error:&error];
    NSLog(@"typhoonInfoJSON: %@", typhoonInfoJSON);
    
    //Parse typhoonInfoResponse
    if(typhoonInfoJSON)
    {
      //~ 2014 08 13
      [typhoonInfoJSONArray addObject:typhoonInfoJSON];
      
      typhoonInfoObject.typhoonId          = [[[typhoonInfoJSON valueForKey:@"typhoon"] valueForKey:@"properties"] valueForKey:@"id"];
      
      typhoonInfoObject.typhoonName        = [[[typhoonInfoJSON valueForKey:@"typhoon"] valueForKey:@"properties"] valueForKey:@"name"];
      
      typhoonInfoObject.typhoonDescription = [[[typhoonInfoJSON valueForKey:@"typhoon"] valueForKey:@"properties"] valueForKey:@"description"];
      
      typhoonInfoObject.birthDate          = [[[typhoonInfoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"birth"];
      
      
      //Best Track Map image and data
      NSURL *bestTrackMapImageURL             = [NSURL URLWithString:[[[typhoonInfoJSON valueForKey:@"typhoon"] valueForKey:@"media"] valueForKey:@"bestTrackMapUrl"]];
      NSData *bestTrackMapImageData           = [NSData dataWithContentsOfURL:bestTrackMapImageURL];
      typhoonInfoObject.bestTrackMapImageData = bestTrackMapImageData;
      typhoonInfoObject.bestTrackMapImage     = [UIImage imageWithData:bestTrackMapImageData];
      

      //Parse to get coordinate numbers
      typhoonInfoObject.typhoonPosition    = [[[typhoonInfoJSON valueForKey:@"typhoon"] valueForKey:@"summary"] valueForKey:@"position"];
      
      CLLocationCoordinate2D coordinates   = [self parseLatitudeLongitude:typhoonInfoObject.typhoonPosition];
      CLLocation *typhoonCoordinates       = [[CLLocation alloc] initWithLatitude:coordinates.latitude
                                                                        longitude:coordinates.longitude];
      typhoonInfoObject.typhoonCoordinates = typhoonCoordinates;
      
      //GEOLOCATION DISABLED - BUGGY
      //typhoonInfoObject.typhoonLocation = [self geolocateTyphoon:typhoonCoordinates];
      
      
      typhoonInfoObject.averageSpeed = [[[typhoonInfoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"avgSpeed"];
      
      typhoonInfoObject.maxWind      = [[[typhoonInfoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"maxWind"];
      
      typhoonInfoObject.pressure     = [[[typhoonInfoJSON valueForKey:@"typhoon"] valueForKey:@"summary"] valueForKey:@"pressure"];
      
      
      //Derived Data - Intensity Strength & PH Signal Strength
      float windKnots                     = [self parseNumber:typhoonInfoObject.maxWind];
      typhoonInfoObject.intensityStrength = [self getTyphoonIntensityStrength:windKnots];
      
      typhoonInfoObject.signalStrength    = [[NSString alloc] initWithFormat:
                                               @"%@"
                                             , [self getTyphoonSignalStrength:windKnots]];
      
      
      //Derived Data - Typhoon Reference Direction
      typhoonInfoObject.typhoonReferenceDirection = [self getTyphoonReferenceDirection:typhoonInfoObject.typhoonCoordinates];
      
      
      return typhoonInfoObject;
    }
    else
    {
      NSLog(@"typhoonInfoJSON == NULL values.");
    }
  }
  
  return typhoonInfoObject;
}


#pragma mark - Get Typhoon Reference direction (N, S, E, W)
-(NSString *) getTyphoonReferenceDirection : (CLLocation *) typhoonCoordinates
{
  NSLog(@"getTyphoonReferenceDirection");
  
  NSString *direction = [[NSString alloc] init];
  
  //Coordinates for Rizal Park - Reference Point for PH
  CLLocation *referencePoint = [[CLLocation alloc] initWithLatitude:14.582
                                                          longitude:120.978];
  
  
  //Get derived point from referencePoint and typhoonCoordinates
  float refLatitude  = 0.0;
  float refLongitude = 0.0;
  
  refLatitude  = (referencePoint.coordinate.latitude - typhoonCoordinates.coordinate.latitude);
  refLongitude = (referencePoint.coordinate.longitude - typhoonCoordinates.coordinate.longitude);
  
  CLLocation *derivedPoint = [[CLLocation alloc] initWithLatitude:refLatitude
                                                        longitude:refLongitude];
  
  NSLog(@"typhoonCoordinates: %@", typhoonCoordinates.description);
  NSLog(@"referencePoint: %@", referencePoint.description);
  NSLog(@"derivedPoint: %@", derivedPoint.description);
  
  //tan^-1
  //opposite == latitude / adjacent == longitude
  float angle        = 0.0;
  float angleRadians = 0.0;
  
  angleRadians = atan(refLatitude / refLongitude);
  
  //convert from degree > radians : 180/pi
  angle = (angleRadians * (180 / 3.14159));
  
  NSLog(@"angle (radians): %f", angleRadians);
  NSLog(@"angle (degrees): %f", angle);
  
  
  //Check which quadrant the angle falls into
  if(angle == 0.0 || angle == 360.0)
  {
    direction = @"E";
  }
  else if(angle > 0.0 && angle < 45.0)
  {
    direction = @"ENE";
  }
  else if(angle == 45.0)
  {
    direction = @"NE";
  }
  else if(angle > 45.0 && angle < 90.0)
  {
    direction = @"NNE";
  }
  else if(angle == 90.0)
  {
    direction = @"N";
  }
  else if(angle > 90.0 && angle < 135.0)
  {
    direction = @"NNW";
  }
  else if(angle == 135.0)
  {
    direction = @"NW";
  }
  else if(angle > 135.0 && angle < 180.0)
  {
    direction = @"WNW";
  }
  else if(angle == 180.0)
  {
    direction = @"W";
  }
  else if(angle > 180.0 && angle < 225.0)
  {
    direction = @"WSW";
  }
  else if(angle == 225.0)
  {
    direction = @"SW";
  }
  else if(angle > 225.0 && angle < 270.0)
  {
    direction = @"SSW";
  }
  else if(angle == 270.0)
  {
    direction = @"S";
  }
  else if(angle > 270.0 && angle < 315.0)
  {
    direction = @"SSE";
  }
  else if(angle == 315.0)
  {
    direction = @"SE";
  }
  else if(angle > 315.0 && angle < 360.0)
  {
    direction = @"ESE";
  }
  
  NSLog(@"typhoon-direction relative to PH: %@", direction);
  
  return  direction;
}


#pragma mark - Parse Number from NSString
-(float) parseNumber : (NSString *) numString
{
  NSString *parsedNumString = [[numString componentsSeparatedByCharactersInSet:
                                [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                               componentsJoinedByString:@""];
  
  return  [parsedNumString floatValue];
}


#pragma mark - Parse Latitude / Longitude
-(CLLocationCoordinate2D ) parseLatitudeLongitude : (NSString *) latlongString
{
  CLLocationCoordinate2D coordinates;
  
  NSArray *latlongFirstPass         = [latlongString  componentsSeparatedByString:@","];
  NSMutableArray *latlongSecondPass = [[NSMutableArray alloc] init];
  NSString *numberString;
  
  for(int i = 0; i < [latlongFirstPass count]; i++)
  {
    NSScanner *scanner = [NSScanner scannerWithString:(NSString *)[latlongFirstPass objectAtIndex:i]];
    
    NSCharacterSet *filter = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    
    while([scanner isAtEnd] == NO)
    {
      numberString = @"";
      [scanner scanUpToCharactersFromSet:filter intoString:NULL];
      if ([scanner scanCharactersFromSet:filter intoString:&numberString])
      {
        [latlongSecondPass addObject:[NSNumber numberWithFloat:[numberString floatValue]]];
      }
    }
  }
  
  NSNumber *latitude  = [latlongSecondPass objectAtIndex:0];
  NSNumber *longitude = [latlongSecondPass objectAtIndex:1];
  
  coordinates.latitude  = [latitude floatValue];
  coordinates.longitude = [longitude floatValue];
  
  return coordinates;
}

#pragma mark - Geolocate Typhoon given the latitude and longitude
-(NSString *) geolocateTyphoon : (CLLocation *) coordinates
{
  NSLog(@"geolocateTyphoon.coordinates.latitude: %f", coordinates.coordinate.latitude);
  NSLog(@"geolocateTyphoon.coordinates.longitude: %f", coordinates.coordinate.longitude);
  
  geocoder = [[CLGeocoder alloc] init];
  NSLog(@"geocoder: %@", geocoder);
  
  [geocoder reverseGeocodeLocation:coordinates completionHandler:^(NSArray *placemarks, NSError *error)
   {
     NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
     if (error == nil && [placemarks count] > 0)
     {
       placemark = [[CLPlacemark alloc] init];
       
       placemark   = [placemarks objectAtIndex:0];
       geolocation = [NSString stringWithFormat:
                      @"%@, %@"
                      , placemark.administrativeArea
                      , placemark.country];
       
       NSLog(@"didUpdateToLocation-geoLocation: %@", geolocation);
       
     }
     else
     {
       NSLog(@"%@", error.debugDescription);
     }
   } ];
  
  NSLog(@"TyphoonInfoManager-typhoon-geoLocation: %@", geolocation);
  
  return geolocation;
}


#pragma mark - Compute Typhoon Intensity / Strength
-(NSString *) getTyphoonIntensityStrength : (float) windKnots
{
  /*
    --------------------------------------------------------------
    Digital Typhoon Chart
    --------------------------------------------------------------
    Intensity Class                 | MAX WIND - In KNOTS (kt)
    --------------------------------------------------------------
    Tropical Depression	            | < 33
    Tropical Storm (Typhoon)        | 34 - 47
    Severe Tropical Storm (Typhoon) | 48 - 63
    Strong Typhoon                  | 64 - 84
    Very Strong Typhoon             | 85 - 104
    Violent Typhoon                 | > 105
  //*/
  
  NSString *intensity = [[NSString alloc] init];
  
  //Tropical Depression
  if(windKnots < 33)
  {
    intensity = @"Tropical Depression";
  }
  //Tropical Storm (Typhoon)
  else if(windKnots >= 34 && windKnots <= 47)
  {
    intensity = @"Tropical Storm (Typhoon)";
  }
  //Severe Tropical Storm (Typhoon)
  else if(windKnots >= 48 && windKnots <= 63)
  {
    intensity = @"Severe Tropical Storm (Typhoon)";
  }
  //Strong Typhoon
  else if(windKnots >= 64 && windKnots <= 84)
  {
    intensity = @"Strong Typhoon";
  }
  //Very Strong Typhoon
  else if(windKnots >= 85 && windKnots <= 104)
  {
    intensity = @"Very Strong Typhoon";
  }
  //Violent Typhoon
  else if(windKnots >= 105)
  {
    intensity = @"Violent Typhoon";
  }
  
  return intensity;
}


#pragma mark - Compute Typhoon Signal Strength
-(NSNumber *) getTyphoonSignalStrength : (float) windKnots
{
  /*
     1 knot == 1.85200 km/h
     1.852 * Vkn = Vkmh
     
     
     Signal Number 1
     wind = 30-60 km/h | 20-35 mph
     at least 36 hours
     
     Signal Number 2
     wind = 60-100 km/h | 65-115 mph
     at least 24 hours
     
     Signal Number 3
     wind = 100-185 km/h | 65-115 mph
     at least 18 hours
     
     Signal Number 4
     wind = >=185 km/h | 115 mph
     at least 12 hours
   //*/
  
  NSNumber *signalStrength;
  float windKPH;
  
  //Convert knots to km/h
  windKPH = 1.852 * windKnots;
  
  //#1
  if(windKPH >= 30 && windKPH < 60)
  {
    signalStrength = @1;
  }
  //#2
  else if(windKPH >= 60 && windKPH < 100)
  {
    signalStrength = @2;
  }
  //#3
  else if(windKPH >= 100 && windKPH < 185)
  {
    signalStrength = @3;
  }
  //#4
  else if(windKPH >= 185)
  {
    signalStrength = @4;
  }
  
  return  signalStrength;
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
  //NSLog(@"connection-httpResponse status code: %d", httpResponseCode);
  
  if(httpResponseCode == 200)
  {
    //NSLog(@"Typhoon data retrieved.");
  }
  else
  {
    //NSLog(@"Typhoon data NOT retrieved.");
  }
}



@end
