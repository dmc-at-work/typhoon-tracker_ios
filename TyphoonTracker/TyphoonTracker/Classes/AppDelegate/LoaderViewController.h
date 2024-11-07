//
//  LoaderViewController.h
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 8/13/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Reachability.h"

#import "TyphoonInfoManager.h"
#import "TyphoonFacts.h"


@interface LoaderViewController : UIViewController
{
  Reachability *internetReachable;
  Reachability *hostReachable;
  
  TyphoonInfoManager *typhoonInfoManager;
  
  TyphoonFacts *typhoonFacts;
}

//Check Network Status
@property BOOL internetActive;
@property BOOL hostActive;

- (BOOL)connected;

-(void) checkNetworkStatus:(NSNotification *)notice;


@property (strong, nonatomic) IBOutlet UIImageView *loaderImageView;
@property (strong, nonatomic) IBOutlet UILabel *loadingText;

//Facts
@property (strong, nonatomic) IBOutlet UILabel *typhoonFactLabel;
@property (strong, nonatomic) IBOutlet UITextView *typhoonFactTextView;

@property (strong, nonatomic) IBOutlet UIButton *goToMainButton;

- (IBAction)goToMain:(id)sender;


@end
