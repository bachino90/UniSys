//
//  RealGas.h
//  UniSys
//
//  Created by Emiliano Bivachi on 10/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RealGas : NSObject 

- (instancetype)initWithComponents:(NSArray *)comp isLiquid:(BOOL)isLiquid;
- (instancetype)initWithComponents:(NSArray *)comp;

@property (nonatomic) double pressure;    //   Pa
@property (nonatomic) double temperature; //   K
@property (nonatomic) double volumen;     //   m3/mol
@property (nonatomic, strong) NSArray *components;
@property (nonatomic) double *composition;
@property (nonatomic, readonly) double *componentLnPhi;

@property (nonatomic, readonly) double z;
@property (nonatomic, readonly) double enthalpy;
@property (nonatomic, readonly) double entropy;

@property (nonatomic, readonly) double lnPhi;

- (void)checkDegreeOfFreedom;

@end
