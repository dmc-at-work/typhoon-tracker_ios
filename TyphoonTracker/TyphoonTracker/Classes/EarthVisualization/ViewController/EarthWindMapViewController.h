//
//  EarthWindMapViewController.h
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 8/14/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Reachability.h"


@interface EarthWindMapViewController : UIViewController
{
  Reachability *internetReachable;
  Reachability *hostReachable;
}

//PageViewController
@property NSUInteger pageIndex;

//Check Network Status
@property BOOL internetActive;
@property BOOL hostActive;

- (BOOL)connected;

-(void) checkNetworkStatus:(NSNotification *)notice;


@property (strong, nonatomic) IBOutlet UIWebView *earthWindMapWebView;

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;


@end
