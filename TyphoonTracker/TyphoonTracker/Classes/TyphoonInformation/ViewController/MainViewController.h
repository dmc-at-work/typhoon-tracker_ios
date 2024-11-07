//
//  MainViewController.h
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/28/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Social/Social.h>

#import <iAd/iAd.h>

#import "Reachability.h"

#import "MyAnnotation.h"
#import "CustomAnnotationView.h"

#import "URLConfigurationManager.h"
#import "RESTMethodManager.h"

#import "TyphoonInfoManager.h"
#import "TyphoonInfoObject.h"


@interface MainViewController : UIViewController<CLLocationManagerDelegate, ADBannerViewDelegate, UIScrollViewDelegate>
{
  URLConfigurationManager *urlConfigurationManager;
  RESTMethodManager *restMethodManager;
  
  TyphoonInfoManager *typhoonInfoManager;
  
  Reachability *internetReachable;
  Reachability *hostReachable;
}


//Check Network Status
@property BOOL internetActive;
@property BOOL hostActive;

- (BOOL)connected;

-(void) checkNetworkStatus:(NSNotification *)notice;


//PageViewController
@property NSUInteger pageIndex;


//iAds
@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;


@property (strong, nonatomic) IBOutlet UIScrollView *mainPageScrollView;
@property (strong, nonatomic) IBOutlet UILabel *typhoonTrackerLabel;


//Typhoon Advisory
@property (strong, nonatomic) IBOutlet UILabel *dateTodayLabel;
@property (strong, nonatomic) IBOutlet UITextView *typhoonAdvisoryTextView;


//Current Typhoon Information
@property (strong, nonatomic) IBOutlet UIImageView *earthPlaceholderImageView;
@property (strong, nonatomic) IBOutlet UIImageView *currentWeatherIcon;
@property (strong, nonatomic) IBOutlet UITableView *typhoonInformationTableView;

@property (strong, nonatomic) NSMutableArray *typhoonInfoArray;

@property (strong, nonatomic) NSMutableArray *typhoonInfoLabels;
@property (strong, nonatomic) NSMutableArray *typhoonInfoIcons;
@property (strong, nonatomic) NSMutableArray *typhoonInfoValues;
@property (strong, nonatomic) NSMutableArray *typhoonNames;


//Geolocation
@property (strong, nonatomic) CLLocationManager *cllocationManager;
@property CLLocationCoordinate2D location;

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) NSString *geolocation;


//Plot Location
@property MKCoordinateRegion region;
@property MKCoordinateSpan span;
@property MyAnnotation *annotation;


//Share Sheet
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

//Social Networks - disabled for now
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;


//Earth image zoom
@property (strong, nonatomic) UIView *earthDetailView;
@property (strong, nonatomic) UIImageView *earthImageView;
@property (strong, nonatomic) UIView *backgroundView;


@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;


//Share Sheet
- (IBAction)share:(id)sender;




//Social Networks - disabled for now
//- (IBAction)tweet:(id)sender;
//- (IBAction)facebook:(id)sender;




@end
