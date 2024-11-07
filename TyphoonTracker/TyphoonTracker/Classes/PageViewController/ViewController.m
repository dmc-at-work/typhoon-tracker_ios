//
//  ViewController.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/28/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize pageViewController;
@synthesize pageViewControllerArray;


- (void)viewDidLoad
{
  NSLog(@"Page View Controller");
  
  [super viewDidLoad];
  
  pageViewController            = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
  pageViewController.dataSource = self;
  
  
  //Initialize array of ALL pageViewController viewControllers
  //MainView
  MainViewController *mainViewController = (MainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MainViewPage"];
  
  //WeatherDetail
  WeatherDetailViewController *weatherDetailViewController = (WeatherDetailViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"WeatherDetailPage"];
  
  //EarthVideo
  EarthVideoViewController *earthVideoViewController = (EarthVideoViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"EarthVideoPage"];

  //Typhoon Checklist
  TyphoonChecklistViewController *typhoonChecklistViewController = (TyphoonChecklistViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"TyphoonChecklistPage"];
  
  //Emergency Numbers
  EmergencyNumbersViewController *emergencyNumbersViewController = (EmergencyNumbersViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"EmergencyNumbersPage"];
  
  //About
  AboutPageViewController *aboutPageViewController = (AboutPageViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AboutPage"];
  
  
  pageViewControllerArray = @[  mainViewController
                              , weatherDetailViewController
                              , earthVideoViewController
                              , typhoonChecklistViewController
                              , emergencyNumbersViewController
                              , aboutPageViewController];
  
  
  //Initialize starting viewController
  MainViewController *startingViewController = (MainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MainViewPage"];
  NSArray *viewControllers = @[startingViewController];
  
  [pageViewController setViewControllers:viewControllers
                               direction:UIPageViewControllerNavigationDirectionForward
                                animated:NO
                              completion:nil];
  
  
  //Change the size of page view controller - iPhone or iPad
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 27); //-30
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 70);
  }
  
  [self addChildViewController:pageViewController];
  [self.view addSubview:pageViewController.view];
  [pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


#pragma mark - Page View Controller methods
- (IBAction)goToMain:(id)sender
{
  MainViewController *mainViewController = (MainViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MainViewPage"];
  
  NSArray *viewControllers = @[mainViewController];
  
  [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}


-(UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
  if (([pageViewControllerArray count] == 0)
      || (index >= [pageViewControllerArray count]))
  {
    return nil;
  }
  
  if([[pageViewControllerArray objectAtIndex:index] isKindOfClass:[MainViewController class]])
  {
    MainViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewPage"];
    
    controller.pageIndex = index;
    return controller;
  }
  else if([[pageViewControllerArray objectAtIndex:index] isKindOfClass:[WeatherDetailViewController class]])
  {
    WeatherDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"WeatherDetailPage"];
    
    controller.pageIndex = index;
    return controller;
  }
  else if([[pageViewControllerArray objectAtIndex:index] isKindOfClass:[EarthVideoViewController class]])
  {
    EarthVideoViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EarthVideoPage"];
    
    controller.pageIndex = index;
    return controller;
  }
  else if([[pageViewControllerArray objectAtIndex:index] isKindOfClass:[TyphoonChecklistViewController class]])
  {
    TyphoonChecklistViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TyphoonChecklistPage"];
    
    controller.pageIndex = index;
    return controller;
  }
  else if([[pageViewControllerArray objectAtIndex:index] isKindOfClass:[EmergencyNumbersViewController class]])
  {
    EmergencyNumbersViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EmergencyNumbersPage"];
    
    controller.pageIndex = index;
    return controller;
  }
  else if([[pageViewControllerArray objectAtIndex:index] isKindOfClass:[AboutPageViewController class]])
  {
    AboutPageViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutPage"];
    
    controller.pageIndex = index;
    return controller;
  }
  
  return nil;
}


#pragma mark - Page View Controller Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
  NSUInteger index;
  
  //Main
  if([viewController isKindOfClass:[MainViewController class]])
  {
    index = ((MainViewController *) viewController).pageIndex;
  }
  //Weather Detail
  else if([viewController isKindOfClass:[WeatherDetailViewController class]])
  {
    index = ((WeatherDetailViewController *) viewController).pageIndex;
  }
  //Earth Video
  else if([viewController isKindOfClass:[EarthVideoViewController class]])
  {
    index = ((EarthVideoViewController *) viewController).pageIndex;
  }
  //Typhoon Checklist
  else if([viewController isKindOfClass:[TyphoonChecklistViewController class]])
  {
    index = ((TyphoonChecklistViewController *) viewController).pageIndex;
  }
  //Emergency Numbers
  else if([viewController isKindOfClass:[EmergencyNumbersViewController class]])
  {
    index = ((EmergencyNumbersViewController *) viewController).pageIndex;
  }
  //About Page
  else if([viewController isKindOfClass:[AboutPageViewController class]])
  {
    index = ((AboutPageViewController *) viewController).pageIndex;
  }
  
  
  if ((index == 0) || (index == NSNotFound))
  {
    return nil;
  }
  
  index--;
  return [self viewControllerAtIndex:index];
}


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
  NSUInteger index;
  
  //Main
  if([viewController isKindOfClass:[MainViewController class]])
  {
    index = ((MainViewController*) viewController).pageIndex;
  }
  //Weather Detail
  else if([viewController isKindOfClass:[WeatherDetailViewController class]])
  {
    index = ((WeatherDetailViewController*) viewController).pageIndex;
  }
  //Earth Video
  else if([viewController isKindOfClass:[EarthVideoViewController class]])
  {
    index = ((EarthVideoViewController*) viewController).pageIndex;
  }
  //Typhoon Checklist
  else if([viewController isKindOfClass:[TyphoonChecklistViewController class]])
  {
    index = ((TyphoonChecklistViewController*) viewController).pageIndex;
  }
  //Emergency Numbers
  else if([viewController isKindOfClass:[EmergencyNumbersViewController class]])
  {
    index = ((EmergencyNumbersViewController*) viewController).pageIndex;
  }
  //About Page
  else if([viewController isKindOfClass:[AboutPageViewController class]])
  {
    index = ((AboutPageViewController*) viewController).pageIndex;
  }
  
  
  if (index == NSNotFound)
  {
    return nil;
  }
   
  index++;
  if (index == [pageViewControllerArray count])
  {
    return nil;
  }
   
  return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
  return [pageViewControllerArray count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
  return 0;
}


@end
