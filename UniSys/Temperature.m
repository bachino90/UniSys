//
//  Temperature.m
//  UniSys
//
//  Created by Emiliano Bivachi on 10/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "Temperature.h"

@interface Temperature ()
@property (nonatomic) double temperature;
@end

@implementation Temperature
- (instancetype)init {
    self = [super init];
    if (self) {
        self.temperature = -274;
    }
    return self;
}

- (instancetype)initWithValue:(double)temp {
    self = [super init];
    if (self) {
        self.temperature = temp;
    }
    return self;
}

- (instancetype)initWithValue:(double)temp andUnit:(TemperatureUnit)unit {
    self = [super init];
    if (self) {
        self.temperature = temp;
        switch (unit) {
            case cUnit:
                self.temperature = temp + 273.15;
                break;
            case fUnit:
                self.temperature = (temp + 459.67) * 5/9;
                break;
            case kUnit:
                self.temperature = self.temperature;
                break;
            case rUnit:
                self.temperature = temp * 5/9;
                break;
            case romerUnit:
                self.temperature = ((temp - 7.5) * 40/21)+273.15;
                break;
            case newtonUnit:
                self.temperature = (temp * 100/33) + 273.15;
                break;
            case delisleUnit:
                self.temperature = 373.14 - (temp * 2/3);
                break;
            default:
                break;
        }
    }
    return self;
}

- (double)valueForUnit:(TemperatureUnit)unit {
    double value = -1;
    switch (unit) {
        case cUnit:
            value = self.temperature - 273.15;
            break;
        case fUnit:
            value = ((self.temperature * 9/5) - 459.67);
            break;
        case kUnit:
            value = self.temperature;
            break;
        case rUnit:
            value = self.temperature * 9/5;
            break;
        case romerUnit:
            value = ((self.temperature - 273.15) * 21/40) + 7.5;
            break;
        case newtonUnit:
            value = (self.temperature - 273.15) * 33/100;
            break;
        case delisleUnit:
            value = (373.15 - self.temperature) * 3/2;
            break;
        default:
            break;
    }
    return value;
}

- (double)C {
    return (self.temperature - 273.15);
}

- (double)F {
    return ((self.temperature * 9/5) - 459.67);
}

- (double)R {
    return (self.temperature * 9/5);
}

- (double)K {
    return self.temperature;
}
@end
