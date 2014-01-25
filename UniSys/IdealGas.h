//
//  IdealGas.h
//  UniSys
//
//  Created by Emiliano Bivachi on 18/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdealGas : NSObject {
    @protected
    double _z;
    
    double _enthalpy;
    double _entropy;
    
    double _idealEnthalpy;
    double _idealEntropy;
    
    double *_componentLnPhi;
    
    BOOL _isLiquid;
}

- (instancetype)initWithComponents:(NSArray *)comp isLiquid:(BOOL)isLiquid;
- (instancetype)initWithComponents:(NSArray *)comp;

@property (nonatomic) double pressure;    //   Pa
@property (nonatomic) double temperature; //   K

@property (nonatomic, strong) NSArray *components;
@property (nonatomic) double *composition;

@property (nonatomic, readonly) double z;
@property (nonatomic, readonly) double volumen;     //   m3/mol

@property (nonatomic, readonly) double idealEnthalpy;
@property (nonatomic, readonly) double idealEntropy;

@property (nonatomic, readonly) double enthalpy;
@property (nonatomic, readonly) double entropy;

@property (nonatomic, readonly) double *componentLnPhi;

- (void)checkDegreeOfFreedom;
- (void)calcIdealProperties;

@end
