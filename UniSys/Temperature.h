//
//  Temperature.h
//  UniSys
//
//  Created by Emiliano Bivachi on 10/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    cUnit,
    fUnit,
    kUnit,
    rUnit,
    romerUnit,
    newtonUnit,
    delisleUnit
}TemperatureUnit;

@interface Temperature : NSObject

/* Default unit : K */
- (instancetype)initWithValue:(double)tem;
- (instancetype)initWithValue:(double)tem andUnit:(TemperatureUnit)unit;

- (double)valueForUnit:(TemperatureUnit)unit;

@property (nonatomic, readonly) double C;
@property (nonatomic, readonly) double F;
@property (nonatomic, readonly) double R;
@property (nonatomic, readonly) double K;

@end
