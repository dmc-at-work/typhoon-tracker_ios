//
//  WeatherDetailViewController.h
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/28/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "URLConfigurationManager.h"
#import "RESTMethodManager.h"

#import "TyphoonInfoManager.h"

#import "TyphoonTrackImageCell.h"
#import "TyphoonTrackImageCelliPad.h"


@interface WeatherDetailViewController : UIViewController<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate>
{
  URLConfigurationManager *urlConfigurationManager;
  RESTMethodManager *restMethodManager;
  
  TyphoonInfoManager *typhoonInfoManager;
}


@property NSUInteger pageIndex;

@property (strong, nonatomic) IBOutlet UILabel *weatherDetailLabel;
@property (strong, nonatomic) IBOutlet UITextField *selectedTyphoonField;

@property (strong, nonatomic) IBOutlet UIImageView *typhoonTrackImageView;

@property (strong, nonatomic) IBOutlet UITableView *weatherDetailTableView;

@property (strong, nonatomic) NSMutableArray *typhoonNamesArray;
@property (strong, nonatomic) NSMutableArray *typhoonTrackMapsArray;
@property (strong, nonatomic) NSMutableArray *typhoonInfoJSONArray;

//Typhoon Selection Picker
@property (strong, nonatomic) UIView *pickerView;
@property (strong, nonatomic) UIPickerView *typhoonSelectionPicker;
@property NSInteger selectedTyphoonIndex;


@property (strong, nonatomic) NSMutableArray *weatherDetailLabels;
@property (strong, nonatomic) NSMutableArray *weatherDetailValues;

@property (strong, nonatomic) NSString *URL;
@property int httpResponseCode;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;


//Track map zoom
@property (strong, nonatomic) UIView *trackMapDetailView;
@property (strong, nonatomic) UIImageView *trackMapImageView;
@property (strong, nonatomic) UIView *backgroundView;


@end
