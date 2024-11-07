//
//  TyphoonChecklistViewController.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/29/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "TyphoonChecklistViewController.h"

@interface TyphoonChecklistViewController ()

@end

@implementation TyphoonChecklistViewController


@synthesize pageIndex;

@synthesize checklistTableView;

//Preparations
@synthesize preparationEntries;

//Supplies and Survival Kit
@synthesize suppliesEntries;


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
  NSLog(@"Typhoon Checklist.");
  
  [super viewDidLoad];
  
  [self initTyphoonChecklistEntries];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


#pragma mark - Define Emergency Information entries
-(void) initTyphoonChecklistEntries
{
  //Preparations
  preparationEntries = [[NSArray alloc] initWithObjects:
                          @"Check your disaster supplies. Replace or restock as needed and make sure your household has enough to support you for extended periods."
                        , @"Secure and bring in all outdoor items that can be picked up by the wind."
                        , @"Close your windows and doors."
                        , @"Turn your refrigerator and freezer to the coldest setting. Keep them closed as much as possible so that food will last longer if the power goes out."
                        , @"Unplug small appliances."
                        , @"Fill your vehicle and generator fuel tanks."
                        , @"Check and charge mobile phones, radios and other devices."
                        , @"Secure copies of important personal documents (birth certificates, passports, IDs, certificates)."
                        , @"Secure set of house / car keys."
                        , @"Obey evacuation orders. Avoid flooded roads and washed out bridges."
                        , nil];
  
  //Supplies & Survival Kit
  suppliesEntries = [[NSArray alloc] initWithObjects:
                       @"Water."
                     , @"Food. Easy to prepare, non-perishable."
                     , @"Flashlights."
                     , @"Extra batteries."
                     , @"First aid kit and medications"
                     , @"Multi-purpose tools, can and bottle opener."
                     , @"Mobile phone and chargers."
                     , @"Blankets, jackets, extra clothing and rain gear."
                     , @"Toiletries, sanitation and personal hygiene items."
                     , @"Extra cash."
                     , @"Share Typhoon Tracker app with friends."
                     , nil];
}


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  //Return the number of sections.
  return 2;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *title = @"";
  
  if(section == 0)
  {
    title = [[NSString alloc] initWithFormat:@"PREPARATIONS"];
  }
  else if(section == 1)
  {
    title = [[NSString alloc] initWithFormat:@"SUPPLIES AND SURVIVAL KIT CHECKLIST"];
  }
  
  return title;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIView *tempView;
  UILabel *tempLabel;
  NSString *sectionTitle;
  
  if(section == 0)
  {
    sectionTitle = [[NSString alloc] initWithFormat:@"PREPARATIONS"];
  }
  else if(section == 1)
  {
    sectionTitle = [[NSString alloc] initWithFormat:@"SUPPLIES AND SURVIVAL KIT CHECKLIST"];
  }
  
  //Formatting depending on device
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    if(section == 0)
    {
      tempView  = [[UIView alloc]initWithFrame:CGRectMake(15, -7, 320, 200)];
      tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, -7, 300, 100)];
    }
    else
    {
      tempView  = [[UIView alloc]initWithFrame:CGRectMake(15, -25, 320, 200)];
      tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, -25, 300, 100)];
    }
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    if(section == 0)
    {
      tempView  = [[UIView alloc]initWithFrame:CGRectMake(20, -7, 720, 200)];
      tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, -7, 700, 100)];
    }
    else
    {
      tempView  = [[UIView alloc]initWithFrame:CGRectMake(20, -25, 720, 200)];
      tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, -25, 700, 100)];
    }
  }
  
  tempView.backgroundColor  = [UIColor clearColor];
  tempLabel.backgroundColor = [UIColor clearColor];
  tempLabel.textColor       = [UIColor blackColor];
  tempLabel.numberOfLines   = 0;
  tempLabel.text            = sectionTitle;
  
  //Update font size depending on view
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    tempLabel.font = [UIFont fontWithName:@"Gotham-Bold" size:14];
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    tempLabel.font = [UIFont fontWithName:@"Gotham-Bold" size:20];
  }
  
  [tempView addSubview:tempLabel];
  
  return tempView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger row;
  
  //Preparations
  if(section == 0)
  {
    row = [preparationEntries count];
  }
  //Supplies
  else if(section == 1)
  {
    row = [suppliesEntries count];
  }
  
  return row;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"typhoonChecklistCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                          forIndexPath:indexPath];
  
  //Preparations
  if(indexPath.section == 0)
  {
    NSString *textLabel = [[NSString alloc] initWithFormat:
                           @"  %d"
                           , (indexPath.row + 1)];
    
    cell.textLabel.text       = textLabel;
    cell.detailTextLabel.text = [preparationEntries objectAtIndex:indexPath.row];
  }
  //Supplies
  else if(indexPath.section == 1)
  {
    NSString *textLabel = [[NSString alloc] initWithFormat:
                             @"  %d"
                           , (indexPath.row + 1)];
    
    cell.textLabel.text       = textLabel;
    cell.detailTextLabel.text = [suppliesEntries objectAtIndex:indexPath.row];
  }
  
  cell.textLabel.numberOfLines   = 0;
  cell.textLabel.textColor       = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];
  cell.textLabel.backgroundColor = [UIColor clearColor];
  
  cell.detailTextLabel.numberOfLines   = 0;
  cell.detailTextLabel.textColor       = [UIColor darkGrayColor];
  cell.detailTextLabel.backgroundColor = [UIColor clearColor];
  
  
  //Update font size depending on view
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    cell.textLabel.font       = [UIFont fontWithName:@"Gotham-Bold" size:14];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Gotham-Book" size:16];
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    cell.textLabel.font       = [UIFont fontWithName:@"Gotham-Bold" size:19];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Gotham-Book" size:21];
  }
  
  
  return cell;
}


//Change the Height of the Cell [Default is 45]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
  int height;
  
  //Update font size depending on view
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    height = 100;
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    height = 150;
  }
  
  return height;
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
