//
//  TyphoonInfoManager.h
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/31/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "Reachability.h"

#import "math.h"

#import "TyphoonInfoObject.h"


@interface TyphoonInfoManager : NSObject<CLLocationManagerDelegate>
{
  Reachability *internetReachable;
  Reachability *hostReachable;
}

//Raw JSON data for ALL typhoonInfo
@property (strong, nonatomic) NSMutableArray *typhoonInfoJSONArray;


//Geolocation
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) NSString *geolocation;

@property int httpResponseCode;


-(NSData *) getSatelliteImage;

-(NSData *) getSatelliteVideo;

-(NSMutableArray *) getTyphoonInfo;

-(TyphoonInfoObject *) getTyphoonDetailedInfo : (NSString *) infoLink;


//Derived info
-(float) parseNumber : (NSString *) numString;
-(CLLocationCoordinate2D ) parseLatitudeLongitude : (NSString *) latlongString;
-(NSString *) getTyphoonReferenceDirection : (CLLocation *) typhoonCoordinates;
-(NSString *) getTyphoonIntensityStrength : (float) windKnots;
-(NSNumber *) getTyphoonSignalStrength : (float) windKnots;



//Check Network Status
@property BOOL internetActive;
@property BOOL hostActive;

-(void) checkNetworkStatus:(NSNotification *)notice;



@end
