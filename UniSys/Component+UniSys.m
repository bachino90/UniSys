//
//  Component+UniSys.m
//  UniSys
//
//  Created by Emiliano Bivachi on 31/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "Component+UniSys.h"

@implementation Component (UniSys)
/*
@synthesize cubic_a;
@synthesize cubic_a_const;
@synthesize cubic_b;
@synthesize cubic_c;
@synthesize cubic_c_const;
@synthesize cubic_dadt;
@synthesize cubic_k;
@synthesize cubic_PRSV_ki;
@synthesize composition;
@synthesize phi;
@synthesize zra;
*/


- (BOOL)isTheSame:(id)object {
    if ([object isKindOfClass:[Component class]]) {
        Component *other = (Component *)object;
        if ([other.name isEqualToString:self.name] &&
            [other.formula isEqualToString:self.formula]) {
            return YES;
        } else
            return NO;
    } else
        return NO;
}


@end
