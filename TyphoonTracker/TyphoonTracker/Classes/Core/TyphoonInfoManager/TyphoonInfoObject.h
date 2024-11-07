//
//  TyphoonInfoObject.h
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/31/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface TyphoonInfoObject : NSObject<CLLocationManagerDelegate>


@property (strong, nonatomic) NSString *typhoonId;

@property (strong, nonatomic) NSString *typhoonName;
@property (strong, nonatomic) NSString *typhoonDescription;
@property (strong, nonatomic) NSString *birthDate;

@property (strong, nonatomic) UIImage *bestTrackMapImage;
@property (strong, nonatomic) NSData *bestTrackMapImageData;

@property (strong, nonatomic) NSString *typhoonPosition;


@property (strong, nonatomic) NSString *averageSpeed;
@property (strong, nonatomic) NSString *maxWind;

@property (strong, nonatomic) NSString *pressure;

//Derived data
@property (strong, nonatomic) NSString *intensityStrength;
@property (strong, nonatomic) NSString *signalStrength;

@property (strong, nonatomic) NSString *typhoonLocation;
@property (strong, nonatomic) CLLocation *typhoonCoordinates;
@property (strong, nonatomic) NSString *typhoonReferenceDirection;


/*
@property (strong, nonatomic) NSNumber *currentTemperature;
@property (strong, nonatomic) NSNumber *currentWindSpeed;
@property (strong, nonatomic) NSNumber *humidity;
@property (strong, nonatomic) NSNumber *visibility;

//*/


@end
