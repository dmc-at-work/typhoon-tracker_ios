//
//  AboutPageViewController.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/28/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "AboutPageViewController.h"

@interface AboutPageViewController ()

@end

@implementation AboutPageViewController

@synthesize pageIndex;

@synthesize aboutImageView;
@synthesize aboutTextView;


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
  NSLog(@"About Page.");
  
  [super viewDidLoad];
  
  //Update font size depending on view
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    aboutTextView.font = [UIFont fontWithName:@"Gotham-Book" size:14.0];
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    aboutTextView.font = [UIFont fontWithName:@"Gotham-Book" size:25.0];
  }
  
  //Display About text
  NSString *aboutPageText = [[NSString alloc] initWithFormat:
                             @"TYPHOON TRACKER \n"
                             @"%@ \n"
                             @"\n\n"
                             @"Copyright © 2014 \n"
                             @"Dungeon Innovations\n"
                             @"\n"
                             @"www.dungeoninnovations.com\n"
                             @"info@dungeoninnovations.com\n"
                             , [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
  
  aboutTextView.text = aboutPageText;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


#pragma mark - Send Email Inquiry
- (IBAction)sendEmail:(id)sender
{
  NSArray *emailRecepient = [[NSArray alloc] initWithObjects:
                               @"info@dungeoninnovations.com"
                             , nil];
  
  NSArray *ccRecepient = [[NSArray alloc] initWithObjects:
                            @"dmc@dungeoninnovations.com"
                          , @"mac@dungeoninnovations.com"
                          , @"mro@dungeoninnovations.com"
                          , nil];
  
  if([MFMailComposeViewController canSendMail])
  {
    MFMailComposeViewController *emailComposer = [[MFMailComposeViewController alloc] init];
    
    emailComposer.mailComposeDelegate = self;
    
    [emailComposer setSubject:@"Typhoon Tracker Inquiry - iOS"];
    [emailComposer setToRecipients:emailRecepient];
    [emailComposer setCcRecipients:ccRecepient];
    [emailComposer setMessageBody:@"Your message..." isHTML:NO];
    
    [emailComposer.navigationBar setBarStyle:UIBarStyleDefault];
    [emailComposer.navigationBar setTintColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0]];
    
    
    [self presentViewController:emailComposer animated:YES completion:nil];
  }
  else
  {
    UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"Email"
                                                         message:@"Cannot send inquiry. Please make sure you have an email account configured in Settings."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    
    [emailAlert show];
  }
}


#pragma mark - MFMailComposer methods
- (void)mailComposeController:(MFMailComposeViewController *) controller
          didFinishWithResult:(MFMailComposeResult) result
                        error:(NSError *) error
{
  switch (result)
  {
    case MFMailComposeResultCancelled:
      NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
      break;
    case MFMailComposeResultSaved:
      NSLog(@"Mail saved: you saved the email message in the drafts folder.");
      break;
    case MFMailComposeResultSent:
    {
      NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
      
      UIAlertView *reservationAlert = [[UIAlertView alloc] initWithTitle:@"Inquiry"
                                                                 message:@"Your message was sent."
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil, nil];
      
      [reservationAlert show];
      
    }
      break;
    case MFMailComposeResultFailed:
      NSLog(@"Mail failed: the email message was not saved or queued, due to an error. Please try again later.");
      break;
    default:
      NSLog(@"Mail not sent.");
      break;
  }
  
  [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Display Resources
- (IBAction)displayResources:(id)sender
{
  NSString *generalDisclaimer = [[NSString alloc] initWithFormat:
                                 @"While we strive to provide accurate and timely information, there may be inadvertent technical/factual inaccuracies and typographical errors on this app. Please send us an email if you see one.\n"
                                 @"Decisions based on information contained on this app are the sole responsibility of the user, and in exchange for using this the visitor agrees to hold us and our affiliates harmless against any claims for damages arising from any decisions that the visitor makes based on such information.\n\n"];
  
  NSString *resourcesDisplay = [[NSString alloc] initWithFormat:
                                @"REFERENCES \n"
                                @"Digital Typhoon: http://agora.ex.nii.ac.jp/digital-typhoon/\n"
                                @"Red Cross: http://www.redcross.org/prepare/disaster/hurricane"
                                @"Facts:\n"
                                @"http://www.sciencekids.co.nz/sciencefacts/weather/hurricane.html\n"
                                @"http://www.ifrc.org/en/what-we-do/disaster-management/about-disasters/definition-of-hazard/tropical-storms-hurricanes-typhoons-and-cyclones/\n"
                                @"http://www.livescience.com/31751-amazing-hurricane-facts.html\n"
                                @"http://www.aoml.noaa.gov/hrd/tcfaq/tcfaqHED.html\n"];
  
  NSString *infoDisplay = [[NSString alloc] initWithFormat:
                           @"%@ %@"
                           , generalDisclaimer
                           , resourcesDisplay];
  
  UIAlertView *info = [[UIAlertView alloc] initWithTitle:@"TYPHOON TRACKER"
                                                      message:infoDisplay
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK", nil];
  [info show];
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
