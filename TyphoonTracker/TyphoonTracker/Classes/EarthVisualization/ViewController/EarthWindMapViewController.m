//
//  EarthWindMapViewController.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 8/14/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "EarthWindMapViewController.h"

@interface EarthWindMapViewController ()

@end

@implementation EarthWindMapViewController

@synthesize pageIndex;

@synthesize internetActive;
@synthesize hostActive;

@synthesize earthWindMapWebView;
@synthesize headerLabel;


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
  NSLog(@"earth.nullschool.net");
  
  [super viewDidLoad];
  
  [self initLabelFont];
  
  [self loadEarthWindMap];
  
  
  /*
  if([self connected])
  {
    [self loadEarthWindMap];
  }
  else
  {
    UIAlertView *connectionAlert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                              message:@"Cannot load page. Please try again later."
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"OK", nil];
    [connectionAlert show];
  }
   //*/
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


#pragma mark - Format font
-(void) initLabelFont
{
  //Update font size depending on view
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    headerLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13.0];
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    headerLabel.font = [UIFont fontWithName:@"Gotham-Book" size:20.0];
  }
}


#pragma mark - Load Earth Wind Map
-(void) loadEarthWindMap
{
  NSURL *earthURL = [NSURL URLWithString:@"http://earth.nullschool.net/#current/wind/surface/level/orthographic=-235.44,0.97,343"];
  NSURLRequest *request = [NSURLRequest requestWithURL:earthURL];
  
  [earthWindMapWebView loadRequest:request];
}

#pragma mark - Check device network status
-(BOOL) connected
{
  hostReachable               = [Reachability reachabilityWithHostName:@"http://earth.nullschool.net/"];
  NetworkStatus networkStatus = [hostReachable currentReachabilityStatus];
  
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
