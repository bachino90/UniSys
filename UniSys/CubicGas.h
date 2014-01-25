//
//  CubicGas.h
//  UniSys
//
//  Created by Emiliano Bivachi on 18/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "IdealGas.h"

@interface CubicGas : IdealGas

- (instancetype)initWithType:(FluidModelType)type andComponents:(NSArray *)comp isLiquid:(BOOL)isLiquid;
- (instancetype)initWithType:(FluidModelType)type andComponents:(NSArray *)comp;
- (instancetype)initWithComponents:(NSArray *)comp isLiquid:(BOOL)isLiquid;
- (instancetype)initWithComponents:(NSArray *)comp;

@property (nonatomic, readonly) FluidModelType type;
@property (nonatomic, readonly) NSString *eosName;

@property (nonatomic, readonly) double *DLnPhiDP;
@property (nonatomic, readonly) double *DLnPhiDT;

- (void)setBinaryParameters:(double **)kij;

@end
