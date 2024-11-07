//
//  CustomAnnotationView.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 7/28/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
  
  if (self)
  {
    // Set the frame size to the appropriate values.
    CGRect myFrame      = self.frame;
    myFrame.size.width  = 40;
    myFrame.size.height = 40;
    self.frame          = myFrame;
    
    self.contentMode    = UIViewContentModeScaleAspectFill;
    self.centerOffset   = CGPointMake(1, 1);
    self.canShowCallout = YES;
    
    // The opaque property is YES by default. Setting it to
    // NO allows map content to show through any unrendered
    // parts of your view.
    self.opaque = NO;
  }
  
  return self;
}


@end
