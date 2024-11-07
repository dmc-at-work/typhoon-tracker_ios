//
//  ViewController.h
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/28/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

//PageController
#import "MainViewController.h"
#import "WeatherDetailViewController.h"
#import "EarthVideoViewController.h"
#import "TyphoonChecklistViewController.h"
#import "EmergencyNumbersViewController.h"
#import "AboutPageViewController.h"


/* Disabled 2014 09 16
#import "EarthWindMapViewController.h"
 //*/


@interface ViewController : UIViewController<UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageViewControllerArray;

- (IBAction)goToMain:(id)sender;


@end
