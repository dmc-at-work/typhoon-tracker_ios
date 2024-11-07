//
//  TyphoonInfoObject.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/31/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "TyphoonInfoObject.h"

@implementation TyphoonInfoObject


@synthesize typhoonId;

@synthesize typhoonName;
@synthesize typhoonDescription;
@synthesize birthDate;

@synthesize bestTrackMapImage;
@synthesize bestTrackMapImageData;

@synthesize typhoonPosition;

@synthesize averageSpeed;
@synthesize maxWind;

@synthesize pressure;

//Derived Data
@synthesize intensityStrength;
@synthesize signalStrength;

@synthesize typhoonLocation;
@synthesize typhoonCoordinates;
@synthesize typhoonReferenceDirection;


/*
@synthesize currentTemperature;
@synthesize currentWindSpeed;
@synthesize humidity;
@synthesize visibility;
//*/


@end
