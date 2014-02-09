//
//  Steam.h
//  UniSys
//
//  Created by Emiliano Bivachi on 05/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LiquidState,
    VapourState,
    EquilibriaState
} SteamState;

@interface Steam : NSObject

- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name andComponents:(NSArray *)components;

/**********************************
 ***** Variables Manipulables *****
 **********************************/
@property (nonatomic) double vapourFraction;
@property (nonatomic) double temperature;
@property (nonatomic) double pressure;
@property (nonatomic) double molarFlow;
@property (nonatomic) double massFlow;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *components;

/*********************************
 ***** Variables Calculadas ******
 *********************************/
@property (nonatomic, readonly) SteamState state;
@property (nonatomic, readonly) double molarWeight;

@property (nonatomic, readonly) NSArray *properties;

@property (nonatomic, readonly) NSArray *liquidComposition;
@property (nonatomic, readonly) NSArray *vapourComposition;
@property (nonatomic, readonly) NSArray *kValues;

// Global
@property (nonatomic, readonly) double z;
@property (nonatomic, readonly) double molarEnthalpy;
@property (nonatomic, readonly) double molarEntropy;

@property (nonatomic, readonly) double molarDensity;
@property (nonatomic, readonly) double massDensity;

@property (nonatomic, readonly) double viscosity;

// Vapour Phase
@property (nonatomic, readonly) double v_z;
@property (nonatomic, readonly) double v_molarEnthalpy;
@property (nonatomic, readonly) double v_molarEntropy;

@property (nonatomic, readonly) double v_molarDensity;
@property (nonatomic, readonly) double v_massDensity;

@property (nonatomic, readonly) double v_viscosity;

// Liquid Phase
@property (nonatomic, readonly) double l_z;
@property (nonatomic, readonly) double l_molarEnthalpy;
@property (nonatomic, readonly) double l_molarEntropy;

@property (nonatomic, readonly) double l_molarDensity;
@property (nonatomic, readonly) double l_massDensity;

@property (nonatomic, readonly) double l_viscosity;

@end
