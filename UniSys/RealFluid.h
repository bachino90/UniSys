//
//  RealFluid.h
//  UniSys
//
//  Created by Emiliano Bivachi on 12/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealGas.h"

typedef enum {
    liquidState,
    equilibriumState,
    gasState
}FluidState;

@interface RealFluid : NSObject

- (instancetype)initWithComponents:(NSArray *)comp;

@property (nonatomic) double pressure;
@property (nonatomic) double temperature;
@property (nonatomic) double volumen;
@property (nonatomic) double molarFlow;
@property (nonatomic) double vaporRatio;
@property (nonatomic, strong) NSArray *components;
@property (nonatomic, readonly) double *liquidComposition;
@property (nonatomic, readonly) double *gasComposition;

@property (nonatomic, readonly) double massFlow;
@property (nonatomic, strong, readonly) RealGas *liquid;
@property (nonatomic, strong, readonly) RealGas *gas;

@property (nonatomic, readonly) double molarEntropy;
@property (nonatomic, readonly) double molarEnthalpy;

@property (nonatomic, readonly) BOOL isDeterminated;

- (void)calcPropertiesPT;

@end
