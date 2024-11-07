//
//  MainViewController.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/28/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "MainViewController.h"
#import "WeatherDetailViewController.h"

#import "Reachability.h"


@interface MainViewController ()

@end

@implementation MainViewController

//Network Status
@synthesize internetActive;
@synthesize hostActive;

//PageViewController
@synthesize pageIndex;


@synthesize mainPageScrollView;
@synthesize typhoonTrackerLabel;


//Typhoon Advisory
@synthesize dateTodayLabel;
@synthesize typhoonAdvisoryTextView;


//Current Typhoon Information
@synthesize earthPlaceholderImageView;
@synthesize currentWeatherIcon;
@synthesize typhoonInformationTableView;

@synthesize typhoonInfoArray;

@synthesize typhoonInfoLabels;
@synthesize typhoonInfoIcons;
@synthesize typhoonInfoValues;
@synthesize typhoonNames;


//Geolocation
@synthesize cllocationManager;
@synthesize location;

@synthesize geocoder;
@synthesize placemark;
@synthesize geolocation;


//Plot Location
@synthesize region;
@synthesize span;
@synthesize annotation;


//Social Networks
@synthesize shareButton;
@synthesize twitterButton;
@synthesize facebookButton;

//Earth Zoom
@synthesize earthDetailView;
@synthesize earthImageView;
@synthesize backgroundView;


@synthesize URL;
@synthesize httpResponseCode;

@synthesize activityIndicator;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}


- (void)viewDidLoad
{
  NSLog(@"Main View.");
  
  [super viewDidLoad];
  
  /*
  //Init date label
  NSDate *date                   = [[NSDate alloc] init];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  NSString *dateString           = [[NSString alloc] init];
  
  [dateFormatter setDateFormat:@"MMMM dd, yyyy 'at' HH:mm"];
  dateString          = [dateFormatter stringFromDate:date];
   //*/
  
  //Display date from API
  NSString *pubDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastUpdated"];
  dateTodayLabel.text = [[NSString alloc] initWithFormat:@"Advisory as of: %@", pubDate];
  
  
  //activityIndicator
  activityIndicator = [[UIActivityIndicatorView alloc]
                       initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
  
  activityIndicator.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0);
  [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
  [self.view addSubview:activityIndicator];
  [self.view bringSubviewToFront:activityIndicator];
  
  
  //Initializations
  urlConfigurationManager = [URLConfigurationManager alloc];
  restMethodManager       = [RESTMethodManager alloc];
  
  
  //Font appearance
  [self setFontAppearance];
  
  
  //Network Status - check for internet connection
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(checkNetworkStatus:)
                                               name:kReachabilityChangedNotification
                                             object:nil];
  
  internetReachable = [Reachability reachabilityForInternetConnection];
  [internetReachable startNotifier];
  
  //Check if a pathway to a random host exists
  hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
  [hostReachable startNotifier];
  
  
  //Typhoon info display initializations
  [self initTyphoonInfoTableViewLabelsIcons];
  [self initEarthSatelliteImage];
  
  
  if([self connected])
  {
    [self getTyphoonAdvisory];
  }
  else
  {
    //Load display from cache for offline access
    [self getTyphoonInfoFromCache];
    
    
    NSString *message = [[NSString alloc] initWithFormat:
                         @"Please connect to the Internet to get the updated information. Thank you."];
    
    UIAlertView *connectionAlert = [[UIAlertView alloc] initWithTitle:message
                                                              message:@""
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"OK", nil];
    [connectionAlert show];
    
    /* Old approach -
    NSMutableArray *typhoonInfoContent = [[NSMutableArray alloc] initWithObjects:
                                            @"-"
                                          , @"-"
                                          , @"-"
                                          , @"-"
                                          , @"-"
                                          , @"-"
                                          , nil];
    
    typhoonInfoValues = [[NSMutableArray alloc] initWithObjects:
                           typhoonInfoContent
                         , nil];
     //*/
  }
  
  //iADS
  //Make self the delegate of the ad banner.
  self.adBanner.delegate = self;
  
  //Initially hide the ad banner.
  self.adBanner.alpha = 0.0;
  
  
  //Zoom Earth image
  UITapGestureRecognizer *tapZoom = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(zoomEarthImage)];
  [self.view addGestureRecognizer:tapZoom];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


#pragma mark - Set typhoonInfo tableView labels and icons
-(void) initTyphoonInfoTableViewLabelsIcons
{
  //Set info labels to display
  typhoonInfoLabels = [[NSMutableArray alloc] initWithObjects:
                         @"Location (See next page for map)"
                       , @"Average Speed"
                       , @"Maximum Wind"
                       , @"Pressure"
                       , @"Intensity"
                       , @"PH Signal Classification"
                       , nil];
  
  //Set info icons
  typhoonInfoIcons = [[NSMutableArray alloc] initWithObjects:
                        @"ti_location.png"
                      , @"ti_speed.png"
                      , @"ti_wind.png"
                      , @"ti_pressure.png"
                      , @"ti_intensity.png"
                      , @"ti_signal.png"
                      , nil];
}


#pragma mark - Initialize Earth Satellite image
-(void) initEarthSatelliteImage
{
  //Set Earth - Satellite Image
  UIImage *satelliteImage = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"satelliteImageData"]];
  
  earthPlaceholderImageView.image = satelliteImage;
}


#pragma mark - Get Typhoon Advisory information from API
-(void) getTyphoonAdvisory
{
  typhoonInfoManager = [TyphoonInfoManager alloc];
  
  //Check if there are active typhoon/s
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"isThereActiveTyphoon"])
  {
    currentWeatherIcon.image = [UIImage imageNamed:@"w_stormy.png"];
    
    //Get TyphoonInfo from API
    typhoonInfoArray = [[NSMutableArray alloc] init];
    typhoonInfoArray = [typhoonInfoManager getTyphoonInfo];
    
    TyphoonInfoObject *typhoonInfoObject = [[TyphoonInfoObject alloc] init];
    typhoonNames                         = [[NSMutableArray alloc] init];
    typhoonInfoValues                    = [[NSMutableArray alloc] init];
    NSArray *typhoonInfoContent          = [[NSArray alloc] init];
    NSMutableArray *bestrackMapArray     = [[NSMutableArray alloc] init];
    
    //Parse typhoon objects and get the data for display
    for(int i = 0; i < [typhoonInfoArray count]; i++)
    {
      typhoonInfoObject = [typhoonInfoArray objectAtIndex:i];
      
      //Typhoon Name/s
      [typhoonNames addObject:typhoonInfoObject.typhoonName];
      
      NSLog(@"typhoonInfoObject.typhoonReferenceDirection: %@", typhoonInfoObject.typhoonReferenceDirection);
      NSLog(@"typhoonInfoObject.averageSpeed: %@", typhoonInfoObject.averageSpeed);
      NSLog(@"typhoonInfoObject.maxWind: %@", typhoonInfoObject.maxWind);
      NSLog(@"typhoonInfoObject.pressure: %@", typhoonInfoObject.pressure);
      NSLog(@"typhoonInfoObject.intensityStrength: %@", typhoonInfoObject.intensityStrength);
      NSLog(@"typhoonInfoObject.signalStrength: %@", typhoonInfoObject.signalStrength);
      
      //Typhoon data
      NSString *typhoonPosition = [[NSString alloc] initWithFormat:
                                    @"%@ %@ of Philippines"
                                   , typhoonInfoObject.typhoonReferenceDirection
                                   , typhoonInfoObject.typhoonPosition];
      
      typhoonInfoContent = [[NSArray alloc] initWithObjects:
                              typhoonPosition
                            , typhoonInfoObject.averageSpeed
                            , typhoonInfoObject.maxWind
                            , typhoonInfoObject.pressure
                            , typhoonInfoObject.intensityStrength
                            , typhoonInfoObject.signalStrength
                            , nil];
      
      [typhoonInfoValues addObject:typhoonInfoContent];
      
      //Best Track Map image data cache
      [bestrackMapArray addObject:typhoonInfoObject.bestTrackMapImageData];
    }
    
    //Save Typhoon Names array in NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:typhoonNames forKey:@"typhoonNames"];
    
    //Save Best Track Map image cache in NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:bestrackMapArray forKey:@"bestTrackMap"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //Typhoon Name/s display formatting (singular or plural display)
    NSString *typhoonNameDisplayString = [[NSString alloc] init];
    
    if(typhoonNames.count > 1)
    {
      typhoonNameDisplayString = [[NSString alloc] initWithFormat:
                                    @"Active Typhoons: %@"
                                  , [typhoonNames componentsJoinedByString:@", "]];
      
    }
    else
    {
      typhoonNameDisplayString = [[NSString alloc] initWithFormat:
                                    @"Active Typhoon: %@"
                                  , [typhoonNames componentsJoinedByString:@" "]];
    }
    
    typhoonAdvisoryTextView.text = typhoonNameDisplayString;
  }
  //No active typhoons
  else
  {
    typhoonAdvisoryTextView.text = @"There are no active typhoons at this time.";
    currentWeatherIcon.image     = [UIImage imageNamed:@"w_cloudy.png"];
    
    NSMutableArray *typhoonInfoContent = [[NSMutableArray alloc] initWithObjects:
                                            @"-"
                                          , @"-"
                                          , @"-"
                                          , @"-"
                                          , @"-"
                                          , @"-"
                                          , nil];
    
    typhoonInfoValues = [[NSMutableArray alloc] initWithObjects:
                           typhoonInfoContent
                         , nil];
  }
}


#pragma mark - Load info from cache for offline access
-(void) getTyphoonInfoFromCache
{
  NSLog(@"getTyphoonInfoFromCache");
  
  //Data display containers
  NSMutableDictionary *infoJSON = [[NSMutableDictionary alloc] init];
  NSArray *infoValues           = [[NSArray alloc] init];
  
  //Check if there are active typhoon/s
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"isThereActiveTyphoon"])
  {
    //Parse typhoon names display
    typhoonNames      = [[NSMutableArray alloc] init];
    typhoonInfoValues = [[NSMutableArray alloc] init];
    typhoonNames      = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"typhoonNames"]];
    
    TyphoonInfoObject *typhoonInfoObject = [[TyphoonInfoObject alloc] init];
    typhoonInfoManager                   = [TyphoonInfoManager new];
    
    //Get and parse typhoon info detail display
    NSMutableArray *typhoonInfoJSONArray = [[NSMutableArray alloc] init];
    typhoonInfoJSONArray                 = [[NSUserDefaults standardUserDefaults] valueForKey:@"typhoonInfoJSONArray"];
    
    for(int i = 0; i < [typhoonInfoJSONArray count]; i++)
    {
      infoJSON = [[NSMutableDictionary alloc] init];
      infoJSON = [typhoonInfoJSONArray objectAtIndex:i];
      
      infoValues = [[NSArray alloc] initWithObjects:
                      [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"birth"]
                    , [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"death"]
                    , [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"lifeTime"]
                    , [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"minPressure"]
                    , [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"maxWind"]
                    , [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"largeStormWindRadius"]
                    , [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"largeStormWindDiameter"]
                    , [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"largeGaleWindRadius"]
                    , [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"largeGaleWindDiameter"]
                    , [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"lengthOfMovement"]
                    , [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"avgSpeed"]
                    , [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"windFlux"]
                    , [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"accumulatedCycloneEnergy"]
                    , [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"powerDissipationIndex"]
                    , nil];
      
      typhoonInfoObject.averageSpeed = [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"avgSpeed"];
      typhoonInfoObject.maxWind      = [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"maxWind"];
      typhoonInfoObject.pressure     = [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"summary"] valueForKey:@"pressure"];
      
      //Parse to get coordinate numbers
      typhoonInfoObject.typhoonPosition    = [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"summary"] valueForKey:@"position"];
      
      CLLocationCoordinate2D coordinates   = [typhoonInfoManager parseLatitudeLongitude:typhoonInfoObject.typhoonPosition];
      CLLocation *typhoonCoordinates       = [[CLLocation alloc] initWithLatitude:coordinates.latitude
                                                                        longitude:coordinates.longitude];
      typhoonInfoObject.typhoonCoordinates = typhoonCoordinates;
      typhoonInfoObject.averageSpeed       = [[[infoJSON valueForKey:@"typhoon"] valueForKey:@"detailed"] valueForKey:@"avgSpeed"];
      
      
      //Derived Data - Intensity Strength & PH Signal Strength
      float windKnots                     = [typhoonInfoManager parseNumber:typhoonInfoObject.maxWind];
      typhoonInfoObject.intensityStrength = [typhoonInfoManager getTyphoonIntensityStrength:windKnots];
      
      typhoonInfoObject.signalStrength    = [[NSString alloc] initWithFormat:
                                             @"%@"
                                             , [typhoonInfoManager getTyphoonSignalStrength:windKnots]];
      
      
      //Derived Data - Typhoon Reference Direction
      typhoonInfoObject.typhoonReferenceDirection = [typhoonInfoManager getTyphoonReferenceDirection:typhoonInfoObject.typhoonCoordinates];
      
      
      //Typhoon data local display
      NSString *typhoonPosition = [[NSString alloc] initWithFormat:
                                   @"%@ %@ of Philippines"
                                   , typhoonInfoObject.typhoonReferenceDirection
                                   , typhoonInfoObject.typhoonPosition];
      
      NSArray *typhoonInfoContent = [[NSArray alloc] initWithObjects:
                                       typhoonPosition
                                     , typhoonInfoObject.averageSpeed
                                     , typhoonInfoObject.maxWind
                                     , typhoonInfoObject.pressure
                                     , typhoonInfoObject.intensityStrength
                                     , typhoonInfoObject.signalStrength
                                     , nil];
      
      NSLog(@"typhoonInfoContent-Local: %@", typhoonInfoContent.description);
      
      [typhoonInfoValues addObject:typhoonInfoContent];
    }
    
    //Typhoon Name/s display formatting (singular or plural display)
    NSString *typhoonNameDisplayString = [[NSString alloc] init];
    
    if(typhoonNames.count > 1)
    {
      typhoonNameDisplayString = [[NSString alloc] initWithFormat:
                                  @"Active Typhoons: %@"
                                  , [typhoonNames componentsJoinedByString:@", "]];
      
    }
    else
    {
      typhoonNameDisplayString = [[NSString alloc] initWithFormat:
                                  @"Active Typhoon: %@"
                                  , [typhoonNames componentsJoinedByString:@" "]];
    }
    
    typhoonAdvisoryTextView.text = typhoonNameDisplayString;
  }
  else
  {
    NSLog(@"No active typhoon advisories.");
    
    typhoonAdvisoryTextView.text = @"There are no active typhoons at this time.";
    currentWeatherIcon.image     = [UIImage imageNamed:@"w_cloudy.png"];
    
    NSMutableArray *typhoonInfoContent = [[NSMutableArray alloc] initWithObjects:
                                            @"-"
                                          , @"-"
                                          , @"-"
                                          , @"-"
                                          , @"-"
                                          , @"-"
                                          , nil];
    
    typhoonInfoValues = [[NSMutableArray alloc] initWithObjects:
                         typhoonInfoContent
                         , nil];
  }
}


#pragma mark - Table view data source implementation
-(NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return [typhoonInfoValues count];
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = @"";
  
  //Display Typhoon names as section headers
  for(int i = 0; i < [typhoonNames count]; i++)
  {
    if(section == i)
    {
      myTitle = [[NSString alloc] initWithFormat:
                   @"International Name: %@"
                 , [typhoonNames objectAtIndex:i]];
      
      return myTitle;
    }
  }
  
  return myTitle;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIView *tempView;
  UILabel *tempLabel;
  NSString *sectionTitle;
  
  for(int i = 0; i < [typhoonNames count]; i++)
  {
    if(section == i)
    {
      sectionTitle = [[NSString alloc] initWithFormat:
                        @"Typhoon: %@"
                      , [typhoonNames objectAtIndex:i]];
    }
  }
  
  //Formatting depending on device
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    if(section == 0)
    {
      tempView  = [[UIView alloc]initWithFrame:CGRectMake(20, -7, 320, 200)];
      tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, -7, 300, 100)];
    }
    else
    {
      tempView  = [[UIView alloc]initWithFrame:CGRectMake(20, -25, 320, 200)];
      tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, -25, 300, 100)];
    }
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    if(section == 0)
    {
      tempView  = [[UIView alloc]initWithFrame:CGRectMake(20, -7, 720, 200)];
      tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, -7, 700, 100)];
    }
    else
    {
      tempView  = [[UIView alloc]initWithFrame:CGRectMake(20, -25, 720, 200)];
      tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, -25, 700, 100)];
    }
  }
  
  tempView.backgroundColor  = [UIColor clearColor];
  tempLabel.backgroundColor = [UIColor clearColor];
  tempLabel.textColor       = [UIColor blackColor];
  tempLabel.numberOfLines   = 0;
  tempLabel.text            = sectionTitle;
  
  //Update font size depending on view
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    tempLabel.font = [UIFont fontWithName:@"Gotham-Bold" size:14];
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    tempLabel.font = [UIFont fontWithName:@"Gotham-Bold" size:20];
  }
  
  [tempView addSubview:tempLabel];
  
  return tempView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //Return the number of rows in the section
  return [typhoonInfoLabels count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"typhoonDetailCell";
  UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                    forIndexPath:indexPath];
  
  NSArray *typhoonDetailDisplay;
  
  for(int i = 0; i < [typhoonInfoValues count]; i++)
  {
    if(indexPath.section == i)
    {
      typhoonDetailDisplay = [typhoonInfoValues objectAtIndex:i];
      cell.textLabel.text  = [typhoonDetailDisplay objectAtIndex:indexPath.row];
    }
  }
  
  //configure the cell
  cell.textLabel.numberOfLines   = 0;
  cell.textLabel.textColor       = [UIColor darkGrayColor];
  cell.textLabel.backgroundColor = [UIColor clearColor];
  
  cell.detailTextLabel.text            = [typhoonInfoLabels objectAtIndex:indexPath.row];
  cell.detailTextLabel.textColor       = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];
  cell.detailTextLabel.numberOfLines   = 0;
  cell.detailTextLabel.backgroundColor = [UIColor clearColor];
  
  cell.imageView.image = [UIImage imageNamed:[typhoonInfoIcons objectAtIndex:indexPath.row]];
  
  
  //Update font size depending on device
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    cell.textLabel.font       = [UIFont fontWithName:@"Gotham-Bold" size:17]; //Gotham-Book-15
    cell.detailTextLabel.font = [UIFont fontWithName:@"Gotham-Book" size:15]; //Gotham-Bold-17
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    cell.textLabel.font       = [UIFont fontWithName:@"Gotham-Bold" size:23]; //19
    cell.detailTextLabel.font = [UIFont fontWithName:@"Gotham-Book" size:20]; //22
  }
  
  return cell;
}


//Change the Height of the Cell [Default is 45]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  int height;
  
  //Update row height depending on device
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    height = 85;
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    height = 115;
  }
  
  return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  //Removes the excess separators at the end of the tableView
  return 0.01f;
}


#pragma mark - Social Networks
#pragma mark - Share sheet
- (IBAction)share:(id)sender
{
  NSString *shareText = [[NSString alloc] initWithFormat:
                           @"Advisory for %@\n"
                           @"#TyphoonTracker #DungeonInn\n"
                           @"Check on the App Store : https://itunes.apple.com/us/app/typhoon-tracker/id905686541?ls=1&mt=8"
                           , typhoonAdvisoryTextView.text];
  
  NSArray *objectsToShare = @[shareText, earthPlaceholderImageView.image];
  
  UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare
                                                                           applicationActivities:nil];
  
  NSArray *excludeActivities = @[UIActivityTypeAssignToContact,
                                 UIActivityTypeSaveToCameraRoll,
                                 UIActivityTypeAddToReadingList,
                                 UIActivityTypePostToVimeo];
  
  activityVC.excludedActivityTypes = excludeActivities;
  
  
  //Popover or sheet display checking
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:activityVC];
    CGRect popoverFrame                    = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0);
    
    [popoverController presentPopoverFromRect:popoverFrame
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    //activityVC.popoverPresentationController.sourceView = self.view;
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    [self presentViewController:activityVC animated:YES completion:nil];
  }
}


/* Disabled - using share UIActivityViewController
#pragma mark - Twitter post
- (IBAction)tweet:(id)sender
{
  NSLog(@"Tweet tweet");
  
  if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
  {
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    NSString *tweetMessage = [[NSString alloc] initWithFormat:
                                @"%@\n"
                                @"#TyphoonTracker #DungeonInn"
                              , typhoonAdvisoryTextView.text];
                              
    UIImage *tweetImage = earthPlaceholderImageView.image;
    
    [tweetSheet addImage:tweetImage];
    [tweetSheet setInitialText:tweetMessage];
    
    [self presentViewController:tweetSheet animated:YES completion:nil];
  }
  else
  {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Send Tweet"
                                                        message:@"Make sure your device has an internet connection and you have at least one Twitter account configured in Settings."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
  }
}


#pragma mark - Facebook post
- (IBAction)facebook:(id)sender
{
  NSLog(@"Facebook");
  
  if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
  {
    SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    NSString *fbMessage = [[NSString alloc] initWithFormat:
                             @"Advisory for %@\n"
                             @"#TyphoonTracker #DungeonInn"
                           , typhoonAdvisoryTextView.text];
    
    UIImage *fbImage = earthPlaceholderImageView.image;
    NSURL *urlString = [NSURL URLWithString:@"www.dungeoninnovations.com"];
    
    [fbSheet addImage:fbImage];
    [fbSheet setInitialText:fbMessage];
    [fbSheet addURL:urlString];
    
    [self presentViewController:fbSheet animated:YES completion:nil];
  }
  else
  {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Post To Facebook"
                                                        message:@"Make sure your device has an internet connection and you have at least one Facebook account configured in Settings."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
  }
}
//*/

#pragma mark - Tap to zoom Earth image
-(void) zoomEarthImage
{
  NSLog(@"zoomEarthImage");
  [self dismissEventView];
  
  earthDetailView               = [[UIView alloc] init];
  earthImageView                = [[UIImageView alloc] init];
  UIScrollView *earthScrollView = [[UIScrollView alloc] init];
  
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    earthDetailView.frame = CGRectMake(10, 60, 300, 300);
    earthImageView.frame  = CGRectMake(0, 0, 300, 300);
    earthScrollView.frame = CGRectMake(0, 0, 300, 300);
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    earthDetailView.frame = CGRectMake(80, 150, 600, 600);
    earthImageView.frame  = CGRectMake(0, 0, 600, 600);
    earthScrollView.frame = CGRectMake(0, 0, 600, 600);
  }
  
  //View container
  earthDetailView.backgroundColor = [UIColor clearColor];
  
  earthImageView.image       = earthPlaceholderImageView.image;
  earthImageView.contentMode = UIViewContentModeScaleAspectFit;
  
  //ScrollView for pinch-to-zoom
  earthScrollView.delegate         = self;
  earthScrollView.minimumZoomScale = 1.0;
  earthScrollView.maximumZoomScale = 5.0;
  [earthScrollView addSubview:earthImageView];
  
  //Add scrollView in eventView
  [earthDetailView addSubview:earthScrollView];
  
  
  //Add background color in whole view
  backgroundView                 = [[UIView alloc] init];
  backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
  
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height - 50));
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height - 66));
  }
  
  //Button Controls
  UIButton *closeButton = [[UIButton alloc] init];
  [closeButton setBackgroundImage:[UIImage imageNamed:@"ic_close.png"] forState:UIControlStateNormal];
  [closeButton addTarget:self
                  action:@selector(dismissEventView)
        forControlEvents:UIControlEventTouchUpInside];
  
  
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    closeButton.frame = CGRectMake(280, 20, 32, 32); //25
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    closeButton.frame = CGRectMake(660, 100, 32, 32);
  }
  
  [backgroundView addSubview:closeButton];
  
  [self.view addSubview:backgroundView];
  [self.view addSubview:earthDetailView];
}


#pragma mark - Delegate method for pinch-to-zoom in UIScrollView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return self.earthImageView;
}

#pragma mark - Dismissing Zoomed-in Events view
-(void) dismissEventView
{
  [backgroundView removeFromSuperview];
  [earthDetailView removeFromSuperview];
}


#pragma mark - Connection methods
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
  httpResponseCode = (int)[httpResponse statusCode];
  
  [activityIndicator stopAnimating];
  
  if((httpResponseCode == 200) || (httpResponseCode == 201))
  {
    NSLog(@"OK.");
  }
  else //(httpResponseCode >= 400)
  {
    NSLog(@"NOK.");
  }
}


#pragma mark - iADS
#pragma mark - AdBannerViewDelegate method implementation
-(void)bannerViewWillLoadAd:(ADBannerView *)banner
{
  NSLog(@"Ad Banner will load ad.");
}


-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
  NSLog(@"Ad Banner did load ad.");
  
  // Show the ad banner.
  [UIView animateWithDuration:0.5 animations:^{
    self.adBanner.alpha = 1.0;
  }];
}


-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
  NSLog(@"Ad Banner action is about to begin.");
  
  return YES;
}


-(void)bannerViewActionDidFinish:(ADBannerView *)banner
{
  NSLog(@"Ad Banner action did finish");
  
}


-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
  NSLog(@"Unable to show ads. Error: %@", [error localizedDescription]);
  
  // Hide the ad banner.
  [UIView animateWithDuration:0.5 animations:^{
    self.adBanner.alpha = 0.0;
  }];
}



#pragma mark - Geolocate Typhoon given the latitude and longitude
-(NSString *) geolocateTyphoon : (CLLocation *) coordinates
{
  NSLog(@"geolocateTyphoon.coordinates.latitude: %f", coordinates.coordinate.latitude);
  NSLog(@"geolocateTyphoon.coordinates.longitude: %f", coordinates.coordinate.longitude);
  
  geocoder = [[CLGeocoder alloc] init];
  
  [geocoder reverseGeocodeLocation:coordinates completionHandler:^(NSArray *placemarks, NSError *error)
   {
     NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
     if (error == nil && [placemarks count] > 0)
     {
       placemark   = [placemarks lastObject];
       geolocation = [NSString stringWithFormat:
                        @"%@, %@"
                      , placemark.administrativeArea
                      , placemark.country];
     }
     else
     {
       NSLog(@"%@", error.debugDescription);
     }
   } ];
  
  NSLog(@"geolocateTyphoon-geoLocation: %@", geolocation);
  
  return geolocation;
}


#pragma mark - Get current location
-(void) getLocation
{
  NSLog(@"getLocation");
  
  cllocationManager.delegate        = self;
  cllocationManager.desiredAccuracy = kCLLocationAccuracyBest;
  //locationManager.distanceFilter = kCLDistanceFilterNone;
  
  [cllocationManager startUpdatingLocation];
  
  location.longitude = cllocationManager.location.coordinate.longitude;
  location.latitude  = cllocationManager.location.coordinate.latitude;
  
  NSLog(@"location.latitude: %f", location.latitude);
  NSLog(@"location.longitude: %f", location.longitude);
}

#pragma mark - geoLocation
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
  NSLog(@"didUpdateToLocation: %@", newLocation);
  CLLocation *currentLocation = newLocation;
  
  // Stop Location Manager
  [cllocationManager stopUpdatingLocation];
  
  NSLog(@"Resolving the Address.");
  [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
   {
     NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
     if (error == nil && [placemarks count] > 0)
     {
       placemark   = [placemarks lastObject];
       geolocation = [NSString stringWithFormat:
                      @"%@, %@ %@, %@, %@"
                      , placemark.thoroughfare
                      , placemark.postalCode
                      , placemark.locality
                      , placemark.administrativeArea
                      , placemark.country];
       
       NSLog(@"didUpdateToLocation-geoLocation: %@", geolocation);
       
       self.navigationItem.title = [[NSString alloc] initWithFormat:
                                    @"%@, %@"
                                    , placemark.administrativeArea
                                    , placemark.country];
     }
     else
     {
       NSLog(@"%@", error.debugDescription);
     }
   } ];
}


#pragma mark - CLLocationManager error handler
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
  NSLog(@"didFailWithError: %@", error);
  
  UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                       message:@"We cannot get your current location. Please make sure that you have an Internet connection and Location services is enabled in your device."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
  [errorAlert show];
}


#pragma mark - Check device network status
-(BOOL) connected
{
  Reachability *reachability  = [Reachability reachabilityForInternetConnection];
  NetworkStatus networkStatus = [reachability currentReachabilityStatus];
  
  NSLog(@"networkStatus: %d", networkStatus);
  return networkStatus != NotReachable;
}


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
  
  NSLog(@"checkNetworkStatus-internetActive: %d", internetActive);
}


-(void) viewWillDisappear:(BOOL)animated
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Adjust scroller height depending on number of elements in view
-(void) setScrollerSize
{
  float scrollViewHeight = 0.0f;
  for (UIView *view in mainPageScrollView.subviews)
  {
    scrollViewHeight += (view.frame.size.height);
  }
  
  scrollViewHeight += 30;
  [mainPageScrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];
}


#pragma mark - Activity Indicator startAnimating
-(void) startActivityIndicator
{
  activityIndicator.hidden = NO;
  [activityIndicator startAnimating];
}


#pragma mark - Set text appearance
-(void) setFontAppearance
{
  //Update font size depending on view
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    typhoonTrackerLabel.font     = [UIFont fontWithName:@"Gotham-Bold" size:16.0];
    dateTodayLabel.font          = [UIFont fontWithName:@"Gotham-Book" size:12.0];
    typhoonAdvisoryTextView.font = [UIFont fontWithName:@"Gotham-Book" size:14.0];
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    typhoonTrackerLabel.font     = [UIFont fontWithName:@"Gotham-Bold" size:23.0];
    dateTodayLabel.font          = [UIFont fontWithName:@"Gotham-Book" size:20.0];
    typhoonAdvisoryTextView.font = [UIFont fontWithName:@"Gotham-Book" size:20.0];
  }
}


/*
#pragma mark - Plot location
-(void) plotLocation
{
  //Set latitude and longitude delta for the map
  span.latitudeDelta  = 100.0f;
  span.longitudeDelta = 100.0f;
  
  region = MKCoordinateRegionMake(location, span);
  //[mapView setRegion:region animated:YES];
  
  //Annotate coordinate location in map
  annotation          = [[MyAnnotation alloc] initWithCoordinate:location];
  //annotation.title    = @"Current Location";
  //annotation.subtitle = geoLocation;
  
  //[mapView addAnnotation:annotation];
  //[mapView selectAnnotation:annotation animated:YES];
}


#pragma mark - Delegate method - Replace pin image with custom image
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)theAnnotation
{
  NSLog(@"mapView - viewForAnnotation");
  //[map removeAnnotation:theAnnotation];
  
  if ([theAnnotation isKindOfClass:[MyAnnotation class]])
  {
    NSString *annotationIdentifier       = @"CustomAnnotationIdentifier";
    CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    annotationView.canShowCallout = YES;
    
    if(annotationView)
    {
      annotationView.annotation = annotation;
    }
    else
    {
      annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                        reuseIdentifier:annotationIdentifier];
      
      //TEMP IMAGE - replace
      annotationView.image = [UIImage imageNamed:@"ic_about.png"];
    }
    return annotationView;
  }
  else
  {
    return nil;
  }
}
//*/



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
