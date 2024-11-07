//
//  EarthVideoViewController.h
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/29/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface EarthVideoViewController : UIViewController

@property NSUInteger pageIndex;

@property (strong, nonatomic) IBOutlet UIImageView *earthPlaceholderImageView;
@property (strong, nonatomic) IBOutlet UIButton *playVideoButton;

@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;
@property (strong, nonatomic) IBOutlet UILabel *satelliteVideoLabel;


- (IBAction)playEarthVideo:(id)sender;



@end
