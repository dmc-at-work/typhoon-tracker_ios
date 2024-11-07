//
//  EarthVideoViewController.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/29/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "EarthVideoViewController.h"

@interface EarthVideoViewController ()

@end

@implementation EarthVideoViewController

@synthesize pageIndex;

@synthesize earthPlaceholderImageView;
@synthesize playVideoButton;
@synthesize videoURL;
@synthesize moviePlayerController;

@synthesize satelliteVideoLabel;


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
  NSLog(@"Earth Video.");
  
  [super viewDidLoad];
  
  //Update font size depending on view
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    satelliteVideoLabel.font = [UIFont fontWithName:@"Gotham-Book" size:13.0];
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    satelliteVideoLabel.font = [UIFont fontWithName:@"Gotham-Book" size:20.0];
  }
  
  //Earth - Satellite Image
  UIImage *satelliteImage = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"satelliteImageData"]];
  earthPlaceholderImageView.image = satelliteImage;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


#pragma mark - Play Earth Video
- (IBAction) playEarthVideo:(id)sender
{
  videoURL = [NSURL URLWithString:
              @"http://di-typhoon-bucket.s3.amazonaws.com/feeds/animation/mp4/last-240h.mp4"];
  
  moviePlayerController = [[MPMoviePlayerController alloc] init];
  
  [moviePlayerController setContentURL:videoURL];
  [moviePlayerController.view setFrame:self.view.bounds]; 
  [self.view addSubview:moviePlayerController.view];
  
  //Dismiss video player after playing
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(videoPlayBackDidFinish:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:moviePlayerController];
  
  [moviePlayerController play];
}


#pragma mark - Dismiss video player after playing
- (void)videoPlayBackDidFinish:(NSNotification *)notification
{
  [[NSNotificationCenter defaultCenter]removeObserver:self
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
  
  [moviePlayerController stop];
  [moviePlayerController.view removeFromSuperview];
  moviePlayerController = nil;
  
  //Error handling
  NSDictionary *notificationUserInfo = [notification userInfo];
  NSNumber *resultValue              = [notificationUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
  
  MPMovieFinishReason reason = [resultValue intValue];
  if (reason == MPMovieFinishReasonPlaybackError)
  {
    NSError *mediaPlayerError = [notificationUserInfo objectForKey:@"error"];
    if (mediaPlayerError)
    {
      NSLog(@"Playback failed with error description: %@", [mediaPlayerError localizedDescription]);
    }
    else
    {
      NSLog(@"Playback failed without any given reason.");
    }
    
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"Cannot get satellite feed. Please connect to the internet."
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [error show];
  }
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
