//
//  CompositionCell.m
//  UniSys
//
//  Created by Emiliano Bivachi on 07/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "CompositionCell.h"

@implementation CompositionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
