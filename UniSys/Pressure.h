//
//  Pressure.h
//  UniSys
//
//  Created by Emiliano Bivachi on 10/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    atmUnit,
    paUnit,
    kpaUnit,
    psiUnit
}PressureUnit;

@interface Pressure : NSObject

/* Default unit : ATM */
- (instancetype)initWithValue:(double)press;
- (instancetype)initWithValue:(double)press andUnit:(PressureUnit)unit;

- (double)valueForUnit:(PressureUnit)unit;

@property (nonatomic, readonly) double psi;
@property (nonatomic, readonly) double kPa;
@property (nonatomic, readonly) double atm;

@end
