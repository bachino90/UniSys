//
//  Property.m
//  UniSys
//
//  Created by Emiliano Bivachi on 07/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "Property.h"

@implementation Property

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.unit = @"-";
        self.globalValue = @"";
        self.liquidValue = @"";
        self.vapourValue = @"";
    }
    return self;
}

@end
