//
//  TyphoonChecklistViewController.h
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/29/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TyphoonChecklistViewController : UIViewController

@property NSUInteger pageIndex;

@property (strong, nonatomic) IBOutlet UITableView *checklistTableView;

//Preparations
@property (strong, nonatomic) NSArray *preparationEntries;

//Supplies and Survival Kit
@property (strong, nonatomic) NSArray *suppliesEntries;



@end
