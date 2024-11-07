//
//  TyphoonTrackImageCelliPad.m
//  TyphoonTracker
//
//  Created by Mary Rose Oh on 8/1/14.
//  Copyright (c) 2014 Dungeon Innovations. All rights reserved.
//

#import "TyphoonTrackImageCelliPad.h"

@implementation TyphoonTrackImageCelliPad

@synthesize typhoonTrackMapImage = _typhoonTrackMapImage;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
