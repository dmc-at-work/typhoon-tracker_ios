//
//  LoaderViewController.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 8/13/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "LoaderViewController.h"
#import "ViewController.h"

@interface LoaderViewController ()

@end

@implementation LoaderViewController

@synthesize hostActive;
@synthesize internetActive;

@synthesize loaderImageView;
@synthesize loadingText;

@synthesize typhoonFactLabel;
@synthesize typhoonFactTextView;

@synthesize goToMainButton;


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
  NSLog(@"Loader View Controller");
  
  [super viewDidLoad];
  
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
  
  
  //Segue button
  goToMainButton.hidden = YES;
  
  //Typhoon facts
  typhoonFactLabel.textColor    = [UIColor blackColor];
  typhoonFactTextView.textColor = [UIColor darkGrayColor];
  
  typhoonFacts             = [[TyphoonFacts alloc] init];
  typhoonFactTextView.text = [typhoonFacts getFact];
  
  
  //Loader animation
  [self animateLoader];
  
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    typhoonFactLabel.font          = [UIFont fontWithName:@"Gotham-Bold" size:14.0];
    typhoonFactTextView.font       = [UIFont fontWithName:@"Gotham-Book" size:12.0];
    loadingText.font               = [UIFont fontWithName:@"Gotham-Book" size:12.0];
    goToMainButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Bold" size:14.0];
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    typhoonFactLabel.font          = [UIFont fontWithName:@"Gotham-Bold" size:23.0];
    typhoonFactTextView.font       = [UIFont fontWithName:@"Gotham-Book" size:20.0];
    loadingText.font               = [UIFont fontWithName:@"Gotham-Book" size:18.0];
    goToMainButton.titleLabel.font = [UIFont fontWithName:@"Gotham-Bold" size:23.0];
  }
}


#pragma mark - Check device network status
-(BOOL) connected
{
  Reachability *reachability  = [Reachability reachabilityForInternetConnection];
  NetworkStatus networkStatus = [reachability currentReachabilityStatus];
  
  NSLog(@"connected-networkStatus: %d", networkStatus);
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


#pragma mark - Data retrieval and page transition
-(void) viewDidAppear:(BOOL)animated
{
  if([self connected])
  {
    [self getSatelliteImage];
    
    //After first run, check for TyphoonInfo immediately to initialize isThereActiveTyphoon flag
    NSMutableArray *typhoonInfoResult = [typhoonInfoManager getTyphoonInfo];
    
    if (typhoonInfoResult)
    {
      //[self performSegueWithIdentifier:@"loaderToPageView" sender:self];
      loadingText.hidden    = YES;
      goToMainButton.hidden = NO;
    }
  }
  else
  {
    UIAlertView *connectionAlert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                              message:@"Please connect to the Internet to get the updated information. Thank you."
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil, nil];
    [connectionAlert show];
    
    
    //[self performSegueWithIdentifier:@"loaderToPageView" sender:self]; >> segue is in button
    loadingText.hidden    = YES;
    goToMainButton.hidden = NO;
  }
  
  loadingText.hidden    = YES;
  goToMainButton.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


#pragma mark - getSatelliteImage
-(void) getSatelliteImage
{
  //Initialize satellite image display and cache
  typhoonInfoManager = [[TyphoonInfoManager alloc] init];
  [typhoonInfoManager getSatelliteImage];
}


#pragma mark - Animate logo
-(void) animateLoader
{
  //Animation
  //loaderImageView.image = [UIImage animatedImageNamed:@"loader_" duration:1.0f]; //1.0f
  
  [loaderImageView setImage:[UIImage imageNamed:@"loader_1.png"]];
  
                                                              //angle, x, y, z
  CATransform3D rotationTransform = CATransform3DMakeRotation(-1.0f * M_PI, 0, 0, 1.0);
  
  CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
  
  rotationAnimation.toValue     = [NSValue valueWithCATransform3D:rotationTransform];
  rotationAnimation.cumulative  = YES;
  rotationAnimation.duration    = 800.0; //360
  rotationAnimation.repeatCount = 12;
  rotationAnimation.speed       = 100.00f;
  
  [loaderImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


#pragma mark - Go To Main
- (IBAction)goToMain:(id)sender
{
  ViewController *controller = (ViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
  
  [self presentViewController:controller animated:NO completion:nil];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([[segue identifier] isEqualToString:@"loaderToPageView"])
  {
    ViewController *controller = (ViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self presentViewController:controller animated:NO completion:nil];
  }
}


@end
