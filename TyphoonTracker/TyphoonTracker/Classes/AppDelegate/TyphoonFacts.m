//
//  TyphoonFacts.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 10/8/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "TyphoonFacts.h"

@implementation TyphoonFacts

@synthesize typhoonFactsArray;


#pragma mark Initialise list
-(void) initTyphoonFacts
{
  typhoonFactsArray = [[NSMutableArray alloc] initWithObjects:
                         @"Weather in the eye of a hurricane is usually calm."
                       
                       , @"The eye of a hurricane can be anywhere from 2 miles (3.2 kilometres) in diameter to over 200 miles (320 kilometres) but they are usually around 30 miles (48 kilometres)."
                       
                       , @"The winds around the eye of a hurricane are usually the strongest."
                       
                       , @"Hurricanes develop over warm water and use it as an energy source."
                       
                       , @"While they are essentially the same thing, the different names usually indicate where the storm took place. Tropical storms that form in the Atlantic or Northeast Pacific (near the United States) are called hurricanes, those that form near in the Northwest Pacific (near Japan) are called typhoons and those that form in the South Pacific or Indian oceans are called cyclones."
                       
                       , @"Tropical storms, cyclones, hurricanes and typhoons, although named differently, describe the same disaster type. These disaster types refer to a large scale closed circulation system in the atmosphere which combines low pressure and strong winds that rotate counter clockwise in the northern hemisphere and clockwise in the southern hemisphere."
                       
                       , @"A tropical cyclone is a non-frontal storm system that is characterised by a low pressure center, spiral rain bands and strong winds."
                       
                       , @"A tropical cyclone usually originates over tropical or subtropical waters and rotates clockwise in the southern hemisphere and counter-clockwise in the northern hemisphere."
                       
                       , @"'Super-typhoon' is a term utilized by the U.S. Joint Typhoon Warning Center for typhoons that reach maximum sustained 1-minute surface winds of at least 65 m/s (130 kt, 150 mph). This is the equivalent of a strong Saffir-Simpson category 4 or category 5 hurricane in the Atlantic basin or a category 5 severe tropical cyclone in the Australian basin."
                       
                       , @"'Major hurricane' is a term utilized by the National Hurricane Center for hurricanes that reach maximum sustained 1-minute surface winds of at least 50 m/s (96 kt, 111 mph). This is the equivalent of category 3, 4 and 5 on the Saffir-Simpson scale."
                       
                       , @"'Intense hurricane' is an unofficial term , but is often used in the scientific literature. It is the same as 'major hurricane'."
                       
                       , @"What is a Tropical Disturbance?\n"
                         @"It is a discrete tropical weather system of apparently organized convection - generally 200 to 600 km (100 to 300 nmi) in diameter - originating in the tropics or subtropics, having a nonfrontal migratory character, and maintaining its identity for 24 hours or more."
                       
                       , @"Disturbances associated with perturbations in the wind field and progressing through the tropics from east to west are also known as easterly waves."
                       
                       , @"What is a Tropical Depression?\n"
                         @"A tropical cyclone in which the maximum sustained wind speed (using the U.S. 1 minute average standard) is up to 33 kt (38 mph, 17 m/s). Depressions have a closed circulation."
                       
                       , @"What is a Tropical Storm?\n"
                         @"A tropical cyclone in which the maximum sustained surface wind speed (using the U.S. 1 minute average standard) ranges from 34 kt (39 mph,17.5 m/s) to 63 kt (73 mph, 32.5 m/s). The convection in tropical storms is usually more concentrated near the center with outer rainfall organizing into distinct bands."
                       
                       , @"What is a Hurricane?\n"
                       @"When winds in a tropical cyclone equal or exceed 64 kt (74 mph, 33 m/s) it is called a hurricane (in the Atlantic and eastern and central Pacific Oceans). Hurricanes are further designated by categories on the Saffir-Simpson scale. Hurricanes in categories 3, 4, 5 are known as Major Hurricanes or Intense Hurricanes."
                       
                       , @"The Saffir-Simpson Hurricane Wind Scale is a 1 to 5 rating based on a hurricane's sustained wind speed. This scale estimates potential property damage. The scale was formulated in 1969 by Herbert Saffir, a consulting engineer, and Dr. Bob Simpson, director of the National Hurricane Center."
                       
                       , @"The 'eye' is a roughly circular area of comparatively light winds and fair weather found at the center of a severe tropical cyclone. Although the winds are calm at the axis of rotation, strong winds may extend well into the eye. There is little or no precipitation and sometimes blue sky or stars can be seen."
                       
                       , @"The eye of the typhoon is the region of lowest surface pressure and warmest temperatures aloft. Eyes range in size from 8 km [5 mi] to over 200 km [120 mi] across, but most are approximately 30-60 km [20-40 mi] in diameter."
                       
                       , @"The eye of the typhoon is surrounded by the 'eyewall', the roughly circular ring of deep convection which is the area of highest surface winds in the tropical cyclone. The eye is composed of air that is slowly sinking and the eyewall has a net upward flow as a result of many moderate - occasionally strong - updrafts and downdrafts."
                       
                       , @"The eye of the typhoon's warm temperatures are due to compressional warming of the subsiding air. Most soundings taken within the eye show a low-level layer which is relatively moist, with an inversion above - suggesting that the sinking in the eye typically does not reach the ocean surface, but instead only gets to around 1-3 km [ 1-2 mi] of the surface."
                       
                       , @"UTC stands for Universal Time Coordinated, what used to be called Greenwich Mean Time (GMT) and Zulu Time (Z). This is the time at the Prime Meridian (0° Longitude) given in hours and minutes on a 24 hour clock. For example, 1350 UTC is 13 hours and 50 minutes after midnight or 1:50 PM at the Prime Meridian."
                       
                       , @"The Greenwich Royal Observatory at Greenwich, England (at 0° Longitude) was where naval chronometers (clocks) were set, a critical instrument for calculating longitude. This is why GMT became the standard for world time. Meteorologists have used UTC or GMT times for over a century to ensure that observations taken around the globe are taken simultaneously."
                       
                       , @"Conversion guide:\n"
                         @"1 mile per hour = 0.869 international nautical mile per hour (knot)"
                       
                       , @"Conversion guide:\n"
                         @"1 mile per hour = 1.609 kilometers per hour"
                       
                       , @"Coversion guide:\n"
                         @"1 mile per hour = 0.4470 meter per second"
                       
                       , @"Conversion guide:\n"
                         @"1 knot = 1.852 kilometers per hour"
                       
                       , @"Conversion guide:\n"
                         @"1 knot = 0.5144 meter per second"
                       
                       , @"Conversion guide:\n"
                         @"1 meter per second = 3.6 kilometers per hour"
                       
                       , @"Conversion guide for pressures:\n"
                         @"1 inch of mercury = 25.4 mm of mercury = 33.86 millibars = 33.86 hectoPascals"
                       
                       , @"Conversion guide:\n"
                         @"1 foot = 0.3048 meter"
                       
                       , @"Conversion guide:\n"
                         @"1 international nautical mile = 1.1508 statute miles = 1.852 kilometers = .99933 U.S nautical mile (obsolete)\n"
                         @"1° latitude = 69.047 statute miles = 60 nautical miles = 111.12 kilometers\n"
                         @"For longitude the conversion is the same as latitude except the value is multiplied by the cosine of the latitude."
                       
                       , @"Tropical cyclones are named to provide ease of communication between forecasters and the general public regarding forecasts and warnings. The first use of a proper name for a tropical cyclone was by Clement Wragge, an Australian forecaster late in the 19th century. He first designated tropical cyclones by the letters of the Greek alphabet, then started using South Sea Island girls' names."
                       
                       , @"What is the origin of the word 'hurricane'?\n"
                         @"'HURRICANE' derived from 'Hurican', the Carib god of evil...\n"
                         @"It should be noted that the Carib god 'Hurican' was derived from the Mayan god 'Hurakan', one of their creator gods, who blew his breath across the Chaotic water and brought forth dry land and later destroyed the men of wood with a great storm and flood."
                       
                       , @"Why do tropical cyclones' winds rotate counter-clockwise (clockwise) in the Northern (Southern) Hemisphere?\n"
                         @"The reason is that the earth's rotation sets up an apparent force (called the Coriolis force) that pulls the winds to the right in the Northern Hemisphere (and to the left in the Southern Hemisphere)."
                       
                       , @"More rain falls in the inner portion of a hurricane around the eyewall and less in the outer rainbands."
                       
                       , @"How much energy does a hurricane release through cloud/rain formation?\n"
                         @"An average hurricane produces 1.5 cm/day (0.6 inches/day) of rain inside a circle of radius 665 km (360 n.mi). Converting this to a volume of rain gives 2.1 x 1016 cm3/day. A cubic cm of rain weighs 1 gm Using the latent heat of condensation, this amount of rain produced gives\n"
                         @"  5.2 x 1019 Joules/day or\n"
                         @"  6.0 x 1014 Watts.\n"
                         @"This is equivalent to 200 times the world-wide electrical generating capacity - an incredible amount of energy produced!"
                       
                       , @"How much energy does a hurricane release through total kinetic/wind energy generated?\n"
                         @"For a mature hurricane, the amount of kinetic energy generated is equal to that being dissipated due to friction. The dissipation rate per unit area is air density times the drag coefficient times the windspeed cubed. Assuming an average windspeed for the inner core of the hurricane and using 40 m/s (90 mph) winds on a scale of radius 60 km (40 n.mi.), one gets a wind dissipation rate (wind generation rate) of\n"
                         @"  1.3 x 1017 Joules/day or\n"
                         @"  1.5 x 1012 Watts.\n"
                         @"This is equivalent to about half the world-wide electrical generating capacity - also an amazing amount of energy being produced!"
                       
                       , @"Which tropical cyclone has produced the highest storm surge?\n"
                       @"The Bathurst Bay Hurricane, also known as Tropical Cyclone Mahina, struck Bathurst Bay, Australia in 1899. It produced a 13 meter (about 42 ft) surge, but other contemporary accounts place the surge at 14.6 meter (almost 48 ft). Fish and dolphins were reported found ontop of 15 m cliffs."
                       
                       , @"Only three Category 5 hurricanes (the highest category on the hurricane strength scale) have hit the United States since the beginning of the 20th century: the 1935 Florida Keys Labor Day Hurricane, Hurricane Camille in 1969, and Hurricane Andrew in 1992."
                       
                       , @"Hurricane Katrina is the costliest hurricane to have ever hit the United States, causing some $125 billion dollars worth of damage in New Orleans and across much of the Gulf Coast. It was a Category 5 storm at one point, but just Category 3 when it made landfall along the Louisiana-Mississippi border."
                       
                       , @"The most intense tropical cyclone in terms of the highest wind speeds measured was Tropical Cyclone Olivia, which struck Australia in 1996. It had wind speeds of 253 mph (407 kph) the fastest wind ever measured on the Earth's surface."
                       
                       , @"The smallest tropical cyclone on record is 1998's Tropical Storm Marco with gale force winds extending out only 12 miles (19 km)."
                       
                       , @"Since 1970, when worldwide satellite coverage began (and therefore tropical cyclones have been more reliably counted), China has been hit by more tropical cyclones than any other country, according to figures from the U.S. National Hurricane Center. (US ranks fifth.)"
                       
                       , @"The longest-traveling storm in the records was John in the East Pacific basin in 1994. It traveled about 7,165 miles (13,280 km)."
                       
                       , @"John was the longest-lasting storm on record, swirling for 31 days in August and September 1994. It formed first as a hurricane in the Northeast Pacific, then moved to the Northwest Pacific and was renamed as a typhoon."
                       
                       , @"Warm water is the fuel that drives a hurricane. Hurricanes require ocean water temperatures of at least 80 degrees Fahrenheit (27 degrees Celsius) to form. Above this temperature the atmosphere is unstable, and that allows deep convection, the overturning of air that allows a tropical storm to become a hurricane, to occur. Below that temperature, the atmosphere is too stable and not enough energy is introduced into the storm."
                       
                       , @"The deadliest and costliest hurricane to ever hit Hawaii (in modern times) was Hurricane Iniki, which struck on Sept. 12, 1992 and caused about $3 billion in damage adjusted for inflation. The storm killed four people and affected 14,000 homes, according to the Weather Channel."
                       
                       , @"What is the Dvorak technique and how is it used?\n"
                       @"The Dvorak technique is a methodology to get estimates of tropical cyclone intensity from satellite pictures. Vern Dvorak developed the scheme using a pattern recognition decision tree in the early 1970s."
                       
                       , @"How much lightning occurs in tropical cyclones?\n"
                         @"Surprisingly, not much lightning occurs in the inner core (within about 100 km or 60 mi) of the tropical cyclone center. Only around a dozen or less cloud-to-ground strikes per hour occur around the eyewall of the storm."
                       
                       , @"Meteorology is the scientific study of the atmosphere, focusing on weather processes and forecasting."
                       
                       , @"Humidity is the amount of water vapor in the air."
                       
                       , @"Atmospheric pressure is the force per unit area exerted on a surface by the weight of air above that surface in the atmosphere of Earth."
                       
                       , @"A gale is a very strong wind. The U.S. National Weather Service defines a gale as 34–47 knots (63–87 km/h, 17.5–24.2 m/s or 39–54 miles/hour) of sustained surface winds."
                       
                       , @"A Storm Surge is an abnormal rise in sea level accompanying a hurricane or other intense storm, whose height is the difference between the observed level of the sea surface and the level that would have occurred in the absence of the cyclone."
                       
                       , @"A Barometer is an instrument that measures atmospheric pressure."
                       
                       , @"The first daily weather forecast printed in The Times from London on August 1, 1861."
                       
                       , @"Precipitation is the process where water vapor condenses in the atmosphere to form water droplets that fall to the Earth as rain, sleet, snow, hail, etc."
                       
                       , @"Monsoon is traditionally defined as a seasonal reversing wind accompanied by corresponding changes in precipitation, but is now used to describe seasonal changes in atmospheric circulation and precipitation associated with the asymmetric heating of land and sea."
                       
                       , @"Hurricanes develop out of low pressure areas that form over warm ocean waters, with evaporating water from the ocean surface fueling the storm as condensation warms the surrounding air. Therefore, a storm's winds weaken when it moves from warm to cool or cold waters."
                       
                       , @"A hurricane dies when it no longer has a source of energy. A hurricane can die in a number of ways, but the primary reasons are cold water, no water and wind shear."
                       
                       , @"Hurricanes drastically deteriorate when they travel from water to land. A sudden lack of warm water drains the storm's energy supply."
                       
                       , @"Hurricane names are determined by the World Meteorological Organization headquartered in Geneva. The WMO is in charge of updating the six weather regions of the world (the United States is in region four, which consists of North America, Central America and the Caribbean)."
                       
                       , @"Originally, hurricanes were given the names of saints who were honored on the day they occurred, according to the National Oceanic and Atmospheric Administration. For example, Hurricane Santa Ana of 1825 hit on July 26, the day dedicated to Saint Anne."
                       
                       , @"The main parts of a hurricane are the rainbands, the eye and the eyewall. Air spirals in toward the center in a counter-clockwise pattern in the Northern Hemisphere (clockwise in the Southern Hemisphere) and out the top in the opposite direction. In the very center of the storm, air sinks, forming an 'eye' that is mostly cloud-free and extends 20 to 40 miles (32 to 64 km) in diameter."
                       
                       , nil];
}


#pragma mark - Return a random typhoon fact;
-(NSString *) getFact
{
  [self initTyphoonFacts];
  
  uint32_t randomIndex = arc4random_uniform([typhoonFactsArray count]);
  NSString *randomFact = [[NSString alloc] initWithString:[typhoonFactsArray objectAtIndex:randomIndex]];
  
  return randomFact;
}


@end
