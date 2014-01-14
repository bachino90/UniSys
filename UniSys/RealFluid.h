//
//  RealFluid.h
//  UniSys
//
//  Created by Emiliano Bivachi on 12/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    liquidState,
    equilibriumState,
    gasState
}FluidState;

@interface RealFluid : NSObject

@property (nonatomic) double pressure;
@property (nonatomic) double temperature;
@property (nonatomic) double volumen;
@property (nonatomic) double molarFlow;
@property (nonatomic, strong) NSArray *composition;

@property (nonatomic, readonly) double massFlow;
@property (nonatomic, strong, readonly) NSArray *liquidComposition;
@property (nonatomic, strong, readonly) NSArray *gasComposition;

@property (nonatomic, readonly) double molarEntropy;
@property (nonatomic, readonly) double molarEnthalpy;

@property (nonatomic, readonly) BOOL isDeterminated;

@end
