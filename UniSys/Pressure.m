//
//  Pressure.m
//  UniSys
//
//  Created by Emiliano Bivachi on 10/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "Pressure.h"

@interface Pressure ()
@property (nonatomic) double pressure;
@end

@implementation Pressure

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pressure = -1;
    }
    return self;
}

- (instancetype)initWithValue:(double)press {
    self = [super init];
    if (self) {
        self.pressure = press;
    }
    return self;
}

- (instancetype)initWithValue:(double)press andUnit:(PressureUnit)unit {
    self = [super init];
    if (self) {
        self.pressure = press;
    }
    return self;
}

- (double)valueForUnit:(PressureUnit)unit {
    double value = -1;
    switch (unit) {
        case atmUnit:
            
            break;
        case paUnit:
            
            break;
        case kpaUnit:
            
            break;
        case psiUnit:
            
            break;
        default:
            break;
    }
    return value;
}

- (double)psi {
    return self.pressure;
}

- (double)atm {
    return self.pressure;
}

- (double)kPa {
    return self.pressure;
}

@end
