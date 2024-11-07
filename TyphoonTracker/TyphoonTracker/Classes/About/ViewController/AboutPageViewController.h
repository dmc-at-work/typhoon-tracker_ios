//
//  AboutPageViewController.h
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/28/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "SWRevealViewController.h"


@interface AboutPageViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property NSUInteger pageIndex;

@property (strong, nonatomic) IBOutlet UIImageView *aboutImageView;
@property (strong, nonatomic) IBOutlet UITextView *aboutTextView;


- (IBAction)sendEmail:(id)sender;

- (IBAction)displayResources:(id)sender;


@end
 