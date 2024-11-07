//
//  AppDelegate.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/28/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "AppDelegate.h"
#import "LoaderViewController.h"


@implementation AppDelegate

@synthesize internetActive;
@synthesize hostActive;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSLog(@"Typhoon Tracker. Dungeon Innovations.");
  
  //Change font and appearance of UINavigationBar title
  [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                         [UIColor blackColor], NSForegroundColorAttributeName,
                                                         [UIFont fontWithName:@"Gotham-Book" size:18.0], NSFontAttributeName, nil]];
   
  //Change font of UIBarButtonItems
  [[UIBarButtonItem appearance] setTitleTextAttributes:
    [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor whiteColor], NSForegroundColorAttributeName,
     [UIFont fontWithName:@"Gotham-Book" size:12.0], NSFontAttributeName, nil]
                                              forState:UIControlStateNormal];
   
  //Remove UINavigationBar line shadow
  [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
  
  //Remove text in Back Buttons
  [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                       forBarMetrics:UIBarMetricsDefault];
  
  
  //PageControl customization
  UIPageControl *pageControl                = [UIPageControl appearance];
  pageControl.pageIndicatorTintColor        = [UIColor lightGrayColor];
  pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
  pageControl.backgroundColor               = [UIColor whiteColor];
  
  
  //Cancel Local Notifications
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
  
  
  /* Initialize data display >> Done in LoaderViewControler
  typhoonInfoManager = [[TyphoonInfoManager alloc] init];
  [typhoonInfoManager getSatelliteImage];
  
  //After first run, check for TyphoonInfo immediately
  [typhoonInfoManager getTyphoonInfo];
  //*/
  
  
  /*
  //Checking for Font names
  for (NSString* family in [UIFont familyNames])
  {
    NSLog(@"%@", family);
   
    for (NSString* name in [UIFont fontNamesForFamilyName: family])
    {
      NSLog(@"  %@", name);
    }
  }
  //*/
  
  /*
  //Notification badge settings authorisation
  if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
  {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
    
    [application registerUserNotificationSettings:settings];
  }
  else
  {
    //iOS 7 or earlier
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    
    [application registerForRemoteNotificationTypes:myTypes];
  }
  
  //Clear Notifications app badge
  [application setApplicationIconBadgeNumber:0];
  
  
  
  //Background fetch and notifications
  //NSTimeInterval hourlyFetchInterval = 3600; //timeinterval is in seconds set to 1 hour interval
  [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
  //*/
  
  
  //Override point for customization after application launch.
  return YES;
}

/*
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
  NSLog(@"performFetchWithCompletionHandler");
  
  //Get Typhoon Info
  typhoonInfoManager   = [[TyphoonInfoManager alloc] init];
  NSMutableArray *info = [[NSMutableArray alloc] init];
  info                 = [typhoonInfoManager getTyphoonInfo];
  
  NSMutableArray *typhoonNamesArray    = [[NSMutableArray alloc] init];
  TyphoonInfoObject *typhoonInfoObject = [TyphoonInfoObject new];
  NSInteger count                      = [info count];
  
  //Parse typhoon objects and get typhoon name for display
  for(int i = 0; i < count; i++)
  {
    typhoonInfoObject = [info objectAtIndex:i];
    
    [typhoonNamesArray addObject:typhoonInfoObject.typhoonName];
  }
  
  if([self connected])
  {
    //Typhoon advisory
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isThereActiveTyphoon"] == true
       && typhoonNamesArray.count > 0)
    {
      NSInteger count = [typhoonNamesArray count];
      
      for(int i = 0; i < count; i++)
      {
        // Set up Local Notifications
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        NSDate *fireDate                       = [NSDate date];
        NSString *typhoonName                  = [typhoonNamesArray objectAtIndex:i];
        
        localNotification.fireDate    = fireDate;
        localNotification.soundName   = UILocalNotificationDefaultSoundName;
        localNotification.alertAction = @"Typhoon Tracker";
        localNotification.alertBody   = [NSString stringWithFormat:
                                         @"Typhoon alert for %@"
                                         , typhoonName];
        
        localNotification.repeatInterval = kCFCalendarUnitDay;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
      }
      
      [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"Fetch completed");
  }
  else
  {
    NSLog(@"Offline. No background fetch.");
  }
}
//*/


- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - Check device network status
-(BOOL) connected
{
  Reachability *reachability  = [Reachability reachabilityForInternetConnection];
  NetworkStatus networkStatus = [reachability currentReachabilityStatus];
  
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


@end
