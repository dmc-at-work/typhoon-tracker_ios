//
//  EmergencyNumbersViewController.h
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 10/13/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EmergencyNumberObject.h"


@interface EmergencyNumbersViewController : UIViewController

@property NSUInteger pageIndex;

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UITableView *emergencyNumbersTableView;
//@property (strong, nonatomic) IBOutlet UISearchBar *emergencyNumbersSearchBar;

@property (strong, nonatomic) NSMutableArray *allNumbers;
@property (strong, nonatomic) NSMutableArray *allEmergencyNumberObjects;
//@property (nonatomic, retain) NSArray *searchResults;

//Philippines
@property (strong, nonatomic) NSArray *phNumbers;

//Bangladesh
@property (strong, nonatomic) NSArray *bdNumbers;

//China
@property (strong, nonatomic) NSArray *cnNumbers;

//Hong Kong
@property (strong, nonatomic) NSArray *hkNumbers;

//India
@property (strong, nonatomic) NSArray *inNumbers;

//Indonesia
@property (strong, nonatomic) NSArray *idNumbers;

//Japan
@property (strong, nonatomic) NSArray *jpNumbers;

//Malaysia
@property (strong, nonatomic) NSArray *myNumbers;

//Myanmar
@property (strong, nonatomic) NSArray *mmNumbers;

//North Korea
@property (strong, nonatomic) NSArray *kpNumbers;

//Singapore
@property (strong, nonatomic) NSArray *sgNumbers;

//South Korea
@property (strong, nonatomic) NSArray *krNumbers;

//Taiwan
@property (strong, nonatomic) NSArray *twNumbers;

//Thailand
@property (strong, nonatomic) NSArray *thNumbers;

//Vietnam
@property (strong, nonatomic) NSArray *vnNumbers;


@end
