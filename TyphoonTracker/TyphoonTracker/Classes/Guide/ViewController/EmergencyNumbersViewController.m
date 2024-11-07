//
//  EmergencyNumbersViewController.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 10/13/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "EmergencyNumbersViewController.h"

@interface EmergencyNumbersViewController ()

@end

@implementation EmergencyNumbersViewController

@synthesize pageIndex;

@synthesize headerLabel;
@synthesize emergencyNumbersTableView;
//@synthesize emergencyNumbersSearchBar;

@synthesize allNumbers;
@synthesize allEmergencyNumberObjects;
//@synthesize searchResults;

@synthesize phNumbers;

@synthesize bdNumbers;

@synthesize cnNumbers;

@synthesize hkNumbers;

@synthesize inNumbers;

@synthesize idNumbers;

@synthesize jpNumbers;

@synthesize myNumbers;

@synthesize mmNumbers;

@synthesize kpNumbers;

@synthesize sgNumbers;

@synthesize krNumbers;

@synthesize twNumbers;

@synthesize thNumbers;

@synthesize vnNumbers;


- (void)viewDidLoad
{
  NSLog(@"Emergency Numbers");
  
  [super viewDidLoad];
  
  //Format header label
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    headerLabel.font = [UIFont fontWithName:@"Gotham-Bold" size:14];
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    headerLabel.font = [UIFont fontWithName:@"Gotham-Bold" size:20];
  }

  
  //Initialise display
  allEmergencyNumberObjects = [[NSMutableArray alloc] init];
  
  [self initEmergencyNumbers];
  
  //searchResults = [[NSArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


#pragma mark - Initialise emergency numbers
-(void) initEmergencyNumbers
{
  NSLog(@"initEmergencyNumbers");
  
  //PHILIPPINES
  phNumbers = [[NSArray alloc] initWithObjects:
               [EmergencyNumberObject country:@"Philippines"
                                         name:@"Philippine National\nRed Cross"
                                       number:@"143\n+632 527 0000\n(02) 527 8535"]
               
               , [EmergencyNumberObject country:@"Philippines"
                                           name:@"NDRRMC"
                                         number:@"+632 911 1406\n+632 911 5061\n+632 912 2665"]
               
               , [EmergencyNumberObject country:@"Philippines"
                                           name:@"PNP"
                                         number:@"117"]
               , nil];
  
  
  //BANGLADESH
  bdNumbers = [[NSArray alloc] initWithObjects:
               [EmergencyNumberObject country:@"Bangladesh"
                                           name:@"CARITAS - Bangladesh"
                                         number:@"8315405-09"]
               
               , [EmergencyNumberObject country:@"Bangladesh"
                                             name:@"Dhaka Metropolitan\nPolice"
                                           number:@"999"]
               
               , [EmergencyNumberObject country:@"Bangladesh"
                                             name:@"Rapid Action\nBatallion HQ"
                                           number:@"+880-2-8961105"]
               , nil];
  
  
  //CHINA
  cnNumbers = [[NSArray alloc] initWithObjects:
               [EmergencyNumberObject country:@"China"
                                         name:@"Police"
                                       number:@"110"]
               
               , [EmergencyNumberObject country:@"China"
                                           name:@"Fire Service"
                                         number:@"119"]
               
               , [EmergencyNumberObject country:@"China"
                                           name:@"Ambulance"
                                         number:@"120"]
               , nil];
  
  
  //HONG KONG
  hkNumbers = [[NSArray alloc] initWithObjects:
               [EmergencyNumberObject country:@"Hong Kong"
                                         name:@"All Emergencies"
                                       number:@"999"]
               
               , [EmergencyNumberObject country:@"Hong Kong"
                                           name:@"Hong Kong\nRed Cross"
                                         number:@"2802 0021"]
               
               , [EmergencyNumberObject country:@"Hong Kong"
                                           name:@"Hong Kong\nObservatory"
                                         number:@"+852 1878 200"]
               , nil];
  
  
  //INDIA
  inNumbers = [[NSArray alloc] initWithObjects:
               [EmergencyNumberObject country:@"India"
                                         name:@"Ambulance"
                                       number:@"102"]
               
               , [EmergencyNumberObject country:@"India"
                                           name:@"Police"
                                         number:@"100"]
               
               , nil];
  
  
  //INDONESIA
  idNumbers  = [[NSArray alloc] initWithObjects:
                [EmergencyNumberObject country:@"Indonesia"
                                          name:@"General Emergency"
                                        number:@"110"]
                
                , [EmergencyNumberObject country:@"Indonesia"
                                            name:@"Ambulance and Rescue"
                                          number:@"118"]
                
                , nil];
  
  
  //JAPAN
  jpNumbers = [[NSArray alloc] initWithObjects:
               [EmergencyNumberObject country:@"Japan"
                                         name:@"Police"
                                       number:@"110"]
               
               , [EmergencyNumberObject country:@"Japan"
                                           name:@"Ambulance / Fire"
                                         number:@"119"]
               
               , nil];
  
  
  //MALAYSIA
  myNumbers = [[NSArray alloc] initWithObjects:
               [EmergencyNumberObject country:@"Malaysia"
                                         name:@"Police"
                                       number:@"999"]
               
               , [EmergencyNumberObject country:@"Malaysia"
                                           name:@"Fire & Rescue"
                                         number:@"994"]
               
               , nil];
  
  
  //MYANMAR
  mmNumbers = [[NSArray alloc] initWithObjects:
               [EmergencyNumberObject country:@"Myanmar"
                                         name:@"Hospital Emergency"
                                       number:@"191"]
               
               , [EmergencyNumberObject country:@"Myanmar"
                                           name:@"Red Cross"
                                         number:@"383684"]
               
               , [EmergencyNumberObject country:@"Myanmar"
                                           name:@"Weather Enquiry"
                                         number:@"660176"]
               
               , nil];
  
  
  //NORTH KOREA
  kpNumbers = [[NSArray alloc] initWithObjects:
               [EmergencyNumberObject country:@"North Korea"
                                         name:@"Emergency"
                                       number:@"119/112"]
               
               , nil];
  
  
  //SINGAPORE
  sgNumbers = [[NSArray alloc] initWithObjects:
               [EmergencyNumberObject country:@"Singapore"
                                         name:@"Police"
                                       number:@"999"]
               
               , [EmergencyNumberObject country:@"Singapore"
                                           name:@"Floods /\nDrain Obstructions"
                                         number:@"1800 284 6600"]
               
               , nil];
  
  
  //SOUTH KOREA
  krNumbers = [[NSArray alloc] initWithObjects:
               [EmergencyNumberObject country:@"South Korea"
                                         name:@"Fire, Emergency\nand Ambulance"
                                       number:@"119"]
               
               , [EmergencyNumberObject country:@"South Korea"
                                           name:@"International\nEmergency Rescue"
                                         number:@"02 790 7561"]
               
               , [EmergencyNumberObject country:@"South Korea"
                                           name:@"Medical Emergency"
                                         number:@"1339"]
               
               , nil];
  
  
  //TAIWAN
  twNumbers = [[NSArray alloc] initWithObjects:
               [EmergencyNumberObject country:@"Taiwan"
                                         name:@"Fire / Ambulance"
                                       number:@"119"]
               
               , [EmergencyNumberObject country:@"Taiwan"
                                           name:@"Weather"
                                         number:@"166"]
               
               , [EmergencyNumberObject country:@"Taiwan"
                                           name:@"Police"
                                         number:@"110"]
               
               , nil];
  
  
  //THAILAND
  thNumbers = [[NSArray alloc] initWithObjects:
               [EmergencyNumberObject country:@"Thailand"
                                         name:@"General Emergency Call"
                                       number:@"191"]
               
               , [EmergencyNumberObject country:@"Thailand"
                                           name:@"Ambulance and Rescue"
                                         number:@"1554"]
               
               , [EmergencyNumberObject country:@"Thailand"
                                           name:@"National Disaster\nWarning Centre"
                                         number:@"1860"]
               
               , nil];
  
  
  //VIETNAM
  vnNumbers = [[NSArray alloc] initWithObjects:
               [EmergencyNumberObject country:@"Vietnam"
                                         name:@"Police"
                                       number:@"113"]
               
               , [EmergencyNumberObject country:@"Vietnam"
                                           name:@"Ambulance"
                                         number:@"115"]
               
               , [EmergencyNumberObject country:@"Vietnam"
                                           name:@"Weather"
                                         number:@"1080"]
               
               , nil];
  
  
  //Consolidate all array
  allNumbers = [[NSMutableArray alloc] initWithObjects:
                  phNumbers
                , bdNumbers
                , cnNumbers
                , hkNumbers
                , inNumbers
                , idNumbers
                , jpNumbers
                , myNumbers
                , mmNumbers
                , kpNumbers
                , sgNumbers
                , krNumbers
                , twNumbers
                , thNumbers
                , vnNumbers
                , nil];
  //15 total
  
  [allEmergencyNumberObjects addObjectsFromArray:phNumbers];
  [allEmergencyNumberObjects addObjectsFromArray:bdNumbers];
  [allEmergencyNumberObjects addObjectsFromArray:cnNumbers];
  [allEmergencyNumberObjects addObjectsFromArray:hkNumbers];
  [allEmergencyNumberObjects addObjectsFromArray:inNumbers];
  [allEmergencyNumberObjects addObjectsFromArray:idNumbers];
  [allEmergencyNumberObjects addObjectsFromArray:jpNumbers];
  [allEmergencyNumberObjects addObjectsFromArray:myNumbers];
  [allEmergencyNumberObjects addObjectsFromArray:mmNumbers];
  [allEmergencyNumberObjects addObjectsFromArray:kpNumbers];
  [allEmergencyNumberObjects addObjectsFromArray:sgNumbers];
  [allEmergencyNumberObjects addObjectsFromArray:krNumbers];
  [allEmergencyNumberObjects addObjectsFromArray:twNumbers];
  [allEmergencyNumberObjects addObjectsFromArray:thNumbers];
  [allEmergencyNumberObjects addObjectsFromArray:vnNumbers];
}


/*
#pragma mark - Search Bar methods
#pragma mark - Search filter using Predicate
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
  NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:
                                  @"SELF.country contains[cd] %@"
                                  , searchText];
  
  searchResults = [allEmergencyNumberObjects filteredArrayUsingPredicate:resultPredicate];
}


#pragma mark - Search Display Controller methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
  [self filterContentForSearchText:searchString
                             scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                    objectAtIndex:[self.searchDisplayController.searchBar
                                                   selectedScopeButtonIndex]]];
  
  return YES;
}
//*/


#pragma mark - Table view data source implementation
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
  return [allNumbers count];
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *title = @"";
  
  if(section == 0)
  {
    title = [[NSString alloc] initWithFormat:@"PHILIPPINES"];
  }
  else if(section == 1)
  {
    title = [[NSString alloc] initWithFormat:@"BANGLADESH"];
  }
  else if(section == 2)
  {
    title = [[NSString alloc] initWithFormat:@"CHINA"];
  }
  else if(section == 3)
  {
    title = [[NSString alloc] initWithFormat:@"HONG KONG"];
  }
  else if(section == 4)
  {
    title = [[NSString alloc] initWithFormat:@"INDIA"];
  }
  else if(section == 5)
  {
    title = [[NSString alloc] initWithFormat:@"INDONESIA"];
  }
  else if(section == 6)
  {
    title = [[NSString alloc] initWithFormat:@"JAPAN"];
  }
  else if(section == 7)
  {
    title = [[NSString alloc] initWithFormat:@"MALAYSIA"];
  }
  else if(section == 8)
  {
    title = [[NSString alloc] initWithFormat:@"MYANMAR"];
  }
  else if(section == 9)
  {
    title = [[NSString alloc] initWithFormat:@"NORTH KOREA"];
  }
  else if(section == 10)
  {
    title = [[NSString alloc] initWithFormat:@"SINGAPORE"];
  }
  else if(section == 11)
  {
    title = [[NSString alloc] initWithFormat:@"SOUTH KOREA"];
  }
  else if(section == 12)
  {
    title = [[NSString alloc] initWithFormat:@"TAIWAN"];
  }
  else if(section == 13)
  {
    title = [[NSString alloc] initWithFormat:@"THAILAND"];
  }
  else if(section == 14)
  {
    title = [[NSString alloc] initWithFormat:@"VIETNAM"];
  }
  
  return title;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIView *tempView;
  UILabel *tempLabel;
  NSString *title;
  
  if(section == 0)
  {
    title = [[NSString alloc] initWithFormat:@"PHILIPPINES"];
  }
  else if(section == 1)
  {
    title = [[NSString alloc] initWithFormat:@"BANGLADESH"];
  }
  else if(section == 2)
  {
    title = [[NSString alloc] initWithFormat:@"CHINA"];
  }
  else if(section == 3)
  {
    title = [[NSString alloc] initWithFormat:@"HONG KONG"];
  }
  else if(section == 4)
  {
    title = [[NSString alloc] initWithFormat:@"INDIA"];
  }
  else if(section == 5)
  {
    title = [[NSString alloc] initWithFormat:@"INDONESIA"];
  }
  else if(section == 6)
  {
    title = [[NSString alloc] initWithFormat:@"JAPAN"];
  }
  else if(section == 7)
  {
    title = [[NSString alloc] initWithFormat:@"MALAYSIA"];
  }
  else if(section == 8)
  {
    title = [[NSString alloc] initWithFormat:@"MYANMAR"];
  }
  else if(section == 9)
  {
    title = [[NSString alloc] initWithFormat:@"NORTH KOREA"];
  }
  else if(section == 10)
  {
    title = [[NSString alloc] initWithFormat:@"SINGAPORE"];
  }
  else if(section == 11)
  {
    title = [[NSString alloc] initWithFormat:@"SOUTH KOREA"];
  }
  else if(section == 12)
  {
    title = [[NSString alloc] initWithFormat:@"TAIWAN"];
  }
  else if(section == 13)
  {
    title = [[NSString alloc] initWithFormat:@"THAILAND"];
  }
  else if(section == 14)
  {
    title = [[NSString alloc] initWithFormat:@"VIETNAM"];
  }
  
  //Formatting depending on device
  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
  {
    if(section == 0)
    {
      tempView  = [[UIView alloc]initWithFrame:CGRectMake(15, -7, 320, 200)]; //20
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
      tempView  = [[UIView alloc]initWithFrame:CGRectMake(15, -10, 720, 200)];
      tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, -10, 700, 100)];
    }
    else
    {
      tempView  = [[UIView alloc]initWithFrame:CGRectMake(15, -28, 720, 200)];
      tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, -28, 700, 100)];
    }
  }
  
  tempView.backgroundColor  = [UIColor clearColor];
  tempLabel.backgroundColor = [UIColor clearColor];
  tempLabel.textColor       = [UIColor blackColor];
  tempLabel.numberOfLines   = 0;
  tempLabel.text            = title;
  
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
  NSInteger row   = 0;
  NSInteger count = [allNumbers count];
    
  for(int i = 0; i < count; i++)
  {
    if(section == i)
    {
      NSArray *tempArray = [allNumbers objectAtIndex:i];
      row                = [tempArray count];
      
      return row;
    }
  }
  
  return row;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"emergencyNumberCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                          forIndexPath:indexPath];
  
  NSUInteger count = [allNumbers count];
  
  for(int i = 0; i < count; i++)
  {
    if(indexPath.section == i)
    {
      NSArray *tempArray                      = [allNumbers objectAtIndex:i];
      EmergencyNumberObject *tempNumberObject = [tempArray objectAtIndex:indexPath.row];
      
      cell.textLabel.text       = tempNumberObject.name;
      cell.detailTextLabel.text = tempNumberObject.number;
    }
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
    height = 75;
  }
  else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
  {
    height = 100;
  }
  
  return height;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
