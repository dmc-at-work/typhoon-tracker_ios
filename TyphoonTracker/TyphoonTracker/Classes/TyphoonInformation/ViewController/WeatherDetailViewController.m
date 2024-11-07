//
//  WeatherDetailViewController.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/28/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "WeatherDetailViewController.h"

@interface WeatherDetailViewController ()

@end

@implementation WeatherDetailViewController

@synthesize pageIndex;

@synthesize weatherDetailLabel;
@synthesize selectedTyphoonField;

@synthesize typhoonTrackImageView;
@synthesize weatherDetailTableView;

@synthesize typhoonNamesArray;
@synthesize typhoonTrackMapsArray;
@synthesize typhoonInfoJSONArray;

//typhoon selection picker
@synthesize pickerView;
@synthesize typhoonSelectionPicker;
@synthesize selectedTyphoonIndex;

@synthesize weatherDetailLabels;
@synthesize weatherDetailValues;

@synthesize URL;
@synthesize httpResponseCode;

@synthesize activityIndicator;


//Track Map Zoom
@synthesize trackMapDetailView;
@synthesize trackMapImageView;
@synthesize backgroundView;



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
  NSLog(@"Weather Detail.");
  
  [super viewDidLoad];
  
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
  
  
  //Init font appearance
  [self setFontAppearance];

  
  //Display Typhoon Info
  [self getWeatherDetailInfo];
  [self setInitialWeatherDetailDisplay];
  
  
  //Typhoon selection picker
  selectedTyphoonField.delegate = self;
  
  //Zoom Track map
  UITapGestureRecognizer *tapZoom = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(zoomTrackMap)];
  [self.view addGestureRecognizer:tapZoom];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
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
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    weatherDetailLabel.font   = [UIFont fontWithName:@"Gotham-Book" size:13.0];
    selectedTyphoonField.font = [UIFont fontWithName:@"Gotham-Bold" size:15.0];
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    weatherDetailLabel.font   = [UIFont fontWithName:@"Gotham-Book" size:20.0];
    selectedTyphoonField.font = [UIFont fontWithName:@"Gotham-Bold" size:16.0];
  }
  
  selectedTyphoonField.textColor = [UIColor colorWithRed:0/255.0
                                                   green:122/255.0
                                                    blue:255/255.0
                                                   alpha:1.0];
}


#pragma mark - Get Weather Detail Info
-(void) getWeatherDetailInfo
{
  NSLog(@"getWeatherDetailInfo");
  
  //Initialise weather detail table labels
  weatherDetailLabels = [[NSMutableArray alloc] initWithObjects:
                           @"Birth"
                         , @"Death (Latest)"
                         , @"Lifetime"
                         , @"Minimum Pressure"
                         , @"Maximum Wind"
                         , @"Largest Radius\n of Storm Wind"
                         , @"Largest Diameter\n of Storm Wind"
                         , @"Largest Radius\n of Gale Wind"
                         , @"Largest Diameter\n of Gale Wind"
                         , @"Length of Movement"
                         , @"Average Speed"
                         , @"Wind Flux"
                         , @"Accumulated Cyclone\n Energy"
                         , @"Power Dissipation\n Index"
                         , nil];
  
  
  //Data display containers
  NSMutableDictionary *infoJSON = [[NSMutableDictionary alloc] init];
  NSArray *infoValues           = [[NSArray alloc] init];
  
  //Parse track map display - if there is active typhoon, display updated. If no active typhoon, display from cache
  typhoonTrackMapsArray   = [[NSMutableArray alloc] init];
  NSArray *allTrackMaps   = [[NSMutableArray alloc] init];
  allTrackMaps            = [[NSUserDefaults standardUserDefaults] valueForKey:@"bestTrackMap"];
  
  NSInteger trackMapCount = [allTrackMaps count];
  for(int i = 0; i < trackMapCount; i++)
  {
    UIImage *trackImage = [UIImage imageWithData:[allTrackMaps objectAtIndex:i]];
    
    [typhoonTrackMapsArray addObject:trackImage];
  }
  
  
  //Check if there are active typhoon/s
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"isThereActiveTyphoon"])
  {
    NSLog(@"isThereActiveTyphoon-true");
    
    //Parse typhoon names display
    typhoonNamesArray = [[NSMutableArray alloc] init];
    typhoonNamesArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"typhoonNames"]];
    
    
    //Get and parse typhoon info detail display
    typhoonInfoJSONArray = [[NSMutableArray alloc] init];
    typhoonInfoJSONArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"typhoonInfoJSONArray"];
    NSLog(@"typhoonInfoJSONArray: %@", typhoonInfoJSONArray);
    
    //array of array of typhoon info
    weatherDetailValues = [[NSMutableArray alloc] init];
    
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
      
      [weatherDetailValues addObject:infoValues];
    }
  }
  else
  {
    NSLog(@"No active typhoon advisories.");
    
    /*
    UIAlertView *activeAlert = [[UIAlertView alloc] initWithTitle:@"No Active Typhoon"
                                                          message:@"There are currently no typhoon advisories."
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"OK", nil];
    [activeAlert show];
     //*/
    
    
    //Initialise array of array of typhoon info
    weatherDetailValues = [[NSMutableArray alloc] init];
    
    //Placeholder display if there are no typhoons
    infoValues = [[NSArray alloc] initWithObjects:
                    @" - "
                  , @" - "
                  , @" - "
                  , @" - "
                  , @" - "
                  , @" - "
                  , @" - "
                  , @" - "
                  , @" - "
                  , @" - "
                  , @" - "
                  , @" - "
                  , @" - "
                  , @" - "
                  , nil];
    
    [weatherDetailValues addObject:infoValues];
    
    typhoonNamesArray = [[NSMutableArray alloc] initWithObjects:
                          @"No active typhoon."
                         , nil];
  }
  
  
  NSLog(@"weatherDetailLabels: %@", weatherDetailLabels.description);
  NSLog(@"weatherDetailValues: %@", weatherDetailValues.description);
  NSLog(@"typhoonTrackMapsArray: %d", (int)typhoonTrackMapsArray.count);
  NSLog(@"typhoonNamesArray: %@", typhoonNamesArray.description);
}


#pragma mark - Init weather info display
-(void) setInitialWeatherDetailDisplay
{
  //Always provide one typhoon info display, a placeholder will be displayed if there are no active typhoons
  selectedTyphoonIndex        = 0;
  selectedTyphoonField.text   = [typhoonNamesArray objectAtIndex:selectedTyphoonIndex];
  
  //Setting of typhoon track map image
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"isThereActiveTyphoon"])
  {
    typhoonTrackImageView.image = [typhoonTrackMapsArray objectAtIndex:selectedTyphoonIndex];
  }
  else
  {
    //placeholder image if there is no typhoon
    typhoonTrackImageView.image = [UIImage imageNamed:@"dt_typhoon_track_no_typhoon.png"];
  }
}


#pragma mark - Typhoon Selection picker
#pragma mark - selectedTyphoonField actions
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
  NSLog(@"textFieldDidBeginEditing");
  
  if(selectedTyphoonField.isEditing)
  {
    [textField resignFirstResponder];
    
    
    //Picker [Done] button
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObject:@"Pick"]];
    doneButton.momentary           = YES;
    doneButton.tintColor           = [UIColor darkGrayColor];
    
    [doneButton addTarget:self
                   action:@selector(getSelectedTyphoonInfo)
         forControlEvents:UIControlEventValueChanged];
    
    
    //Picker [Cancel] button
    UISegmentedControl *cancelPickerButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
    cancelPickerButton.momentary           = YES;
    cancelPickerButton.tintColor           = [UIColor darkGrayColor];
    
    [cancelPickerButton addTarget:self
                           action:@selector(dismissPickerView)
                 forControlEvents:UIControlEventValueChanged];
    
    
    //Picker label
    UILabel *pickerViewLabel        = [[UILabel alloc] init];
    pickerViewLabel.textColor       = [UIColor darkGrayColor];
    pickerViewLabel.backgroundColor = [UIColor clearColor];
    pickerViewLabel.text            = @"Select typhoon to\n    view details";
    pickerViewLabel.numberOfLines   = 0;

    
    //Update picker size depending on device
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
      pickerView               = [[UIView alloc] initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 300)];
      doneButton.frame         = CGRectMake(260, 10.0f, 50.0f, 30.0f);
      cancelPickerButton.frame = CGRectMake(10, 10.0f, 50.0f, 30.0f);
      pickerViewLabel.frame    = CGRectMake(100, 0.0, 320.0, 80);
      pickerViewLabel.font     = [UIFont fontWithName:@"Gotham-Book" size:14.0];
    }
    else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
      pickerView               = [[UIView alloc] initWithFrame:CGRectMake(200, 350, 400, 400)];
      doneButton.frame         = CGRectMake(340, 10.0f, 50.0f, 30.0f);
      cancelPickerButton.frame = CGRectMake(10, 10.0f, 50.0f, 30.0f);
      pickerViewLabel.frame    = CGRectMake(130, 0.0, 400.0, 80);
      pickerViewLabel.font     = [UIFont fontWithName:@"Gotham-Book" size:16.0];
    }
    
    //UIView to contain the pickerViews
    [pickerView setBackgroundColor:[UIColor colorWithRed:224/255.0
                                                   green:224/255.0
                                                    blue:224/255.0
                                                   alpha:1.0]];
    
    typhoonSelectionPicker                         = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 25, pickerView.frame.size.width, 0)];
    typhoonSelectionPicker.showsSelectionIndicator = YES;
    typhoonSelectionPicker.dataSource              = self;
    typhoonSelectionPicker.delegate                = self;
    
    
    [pickerView addSubview:typhoonSelectionPicker];
    [pickerView addSubview:pickerViewLabel];
    [pickerView addSubview:cancelPickerButton];
    [pickerView addSubview:doneButton];
    
    
    [self.view addSubview:pickerView];
  }
}


#pragma mark - Implementing the Picker View
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
  
  UILabel *label        = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, typhoonSelectionPicker.frame.size.width, 44)];
  label.backgroundColor = [UIColor clearColor];
  label.textColor       = [UIColor blackColor];
  label.font            = [UIFont fontWithName:@"Gotham-Book" size:16.0];
  label.textAlignment   = NSTextAlignmentCenter;
  label.text            = [typhoonNamesArray objectAtIndex:row];
  
  return label;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return [typhoonNamesArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return [typhoonNamesArray objectAtIndex:row];
}


#pragma mark - Cancel button in pickerView implementation
-(void) dismissPickerView
{
  [pickerView removeFromSuperview];
}


#pragma mark - Get selected typhoon info display
-(void) getSelectedTyphoonInfo
{
  [self dismissPickerView];
  
  selectedTyphoonIndex        = [typhoonSelectionPicker selectedRowInComponent:0];
  selectedTyphoonField.text   = [typhoonNamesArray objectAtIndex:selectedTyphoonIndex];
  
  //Setting of typhoon track map image
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"isThereActiveTyphoon"])
  {
    typhoonTrackImageView.image = [typhoonTrackMapsArray objectAtIndex:selectedTyphoonIndex];
  }
  else
  {
    //placeholder image if there is no typhoon
    typhoonTrackImageView.image = [UIImage imageNamed:@"dt_typhoon_track_no_typhoon.png"];
  }
  
  [weatherDetailTableView reloadData];
}


#pragma mark - Table view data source implementation
- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *myTitle = @"";
  
  return myTitle;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  int section = 1;
  
  return section;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  int count = [weatherDetailLabels count];
  //NSLog(@"row-count: %d", [weatherDetailLabels count]);
  
  return count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"weatherDetailCell";
  UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                          forIndexPath:indexPath];
  
  //Get info for selected typhoon
  NSMutableArray *typhoonInfo = [[NSMutableArray alloc] init];
  typhoonInfo                 = [weatherDetailValues objectAtIndex:selectedTyphoonIndex];
  
  cell.detailTextLabel.text = [typhoonInfo objectAtIndex:indexPath.row];
  cell.textLabel.text       = [weatherDetailLabels objectAtIndex:indexPath.row];
  
  cell.textLabel.numberOfLines       = 0;
  cell.detailTextLabel.numberOfLines = 0;
  cell.textLabel.textColor           = [UIColor colorWithRed:0/255.0
                                                       green:122/255.0
                                                        blue:255/255.0
                                                       alpha:1.0];
  cell.detailTextLabel.textColor     = [UIColor darkGrayColor];
  
  //Update font size depending on device
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    cell.textLabel.font       = [UIFont fontWithName:@"Gotham-Book" size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Gotham-Bold" size:16];
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    cell.textLabel.font       = [UIFont fontWithName:@"Gotham-Book" size:20];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Gotham-Bold" size:22];
  }

  return  cell;
}


//Change the Height of the Cell [Default is 45]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  int height;
  
  //Update font size depending on device
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    height = 80;
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    height = 115;
  }
  
  return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  //Remove excess separators at the end of the tableView
  return 0.01f;
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
  else
  {
    NSLog(@"NOK.");
  }
}


#pragma mark - Tap to zoom Earth image
-(void) zoomTrackMap
{
  NSLog(@"zoomTrackMap");
  [self dismissEventView];
  
  trackMapDetailView               = [[UIView alloc] init];
  trackMapImageView                = [[UIImageView alloc] init];
  UIScrollView *trackMapScrollView = [[UIScrollView alloc] init];
  
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    trackMapDetailView.frame = CGRectMake(10, 60, 300, 300); //300x222
    trackMapImageView.frame  = CGRectMake(0, 0, 300, 300);
    trackMapScrollView.frame = CGRectMake(0, 0, 300, 300);
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    trackMapDetailView.frame = CGRectMake(80, 150, 600, 600); //600x444
    trackMapImageView.frame  = CGRectMake(0, 0, 600, 600);
    trackMapScrollView.frame = CGRectMake(0, 0, 600, 600);
  }
  
  //View container
  trackMapDetailView.backgroundColor = [UIColor clearColor];
  
  trackMapImageView.image       = typhoonTrackImageView.image;
  trackMapImageView.contentMode = UIViewContentModeScaleAspectFill; //UIViewContentModeScaleAspectFit;
  
  //ScrollView for pinch-to-zoom
  trackMapScrollView.delegate         = self;
  trackMapScrollView.minimumZoomScale = 1.0;
  trackMapScrollView.maximumZoomScale = 5.0;
  [trackMapScrollView addSubview:trackMapImageView];
  
  //Add scrollView in eventView
  [trackMapDetailView addSubview:trackMapScrollView];
  
  
  //Add background color in whole view
  backgroundView                 = [[UIView alloc] init];
  backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
  
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  }
  
  //Button Controls
  UIButton *closeButton = [[UIButton alloc] init];
  [closeButton setBackgroundImage:[UIImage imageNamed:@"ic_close.png"] forState:UIControlStateNormal];
  [closeButton addTarget:self
                  action:@selector(dismissEventView)
        forControlEvents:UIControlEventTouchUpInside];
  
  
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    closeButton.frame = CGRectMake(280, 20, 32, 32);
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    closeButton.frame = CGRectMake(660, 100, 32, 32);
  }
  
  [backgroundView addSubview:closeButton];
  
  [self.view addSubview:backgroundView];
  [self.view addSubview:trackMapDetailView];
}


#pragma mark - Delegate method for pinch-to-zoom in UIScrollView
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return self.trackMapImageView;
}

#pragma mark - Dismissing Zoomed-in Events view
-(void) dismissEventView
{
  [backgroundView removeFromSuperview];
  [trackMapDetailView removeFromSuperview];
}


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
