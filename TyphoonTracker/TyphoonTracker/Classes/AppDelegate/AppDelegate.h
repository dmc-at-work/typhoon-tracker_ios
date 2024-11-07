//
//  AppDelegate.h
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/28/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Reachability.h"

#import "TyphoonInfoManager.h"
#import "TyphoonInfoObject.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
  Reachability *internetReachable;
  Reachability *hostReachable;
  
  TyphoonInfoManager *typhoonInfoManager;
}

@property (strong, nonatomic) UIWindow *window;

//Check Network Status
@property BOOL internetActive;
@property BOOL hostActive;

- (BOOL)connected;

-(void) checkNetworkStatus:(NSNotification *)notice;


@end
