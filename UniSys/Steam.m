//
//  Steam.m
//  UniSys
//
//  Created by Emiliano Bivachi on 05/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "Steam.h"
#import "Property.h"

@interface Steam ()

@property (nonatomic, readwrite) SteamState state;
@property (nonatomic, readwrite) double molarWeight;

@property (nonatomic, readwrite) NSArray *properties;

@property (nonatomic, readwrite) NSArray *liquidComposition;
@property (nonatomic, readwrite) NSArray *vapourComposition;
@property (nonatomic, readwrite) NSArray *kValues;

// Global
@property (nonatomic, readwrite) double z;
@property (nonatomic, readwrite) double molarEnthalpy;
@property (nonatomic, readwrite) double molarEntropy;

@property (nonatomic, readwrite) double molarDensity;
@property (nonatomic, readwrite) double massDensity;

@property (nonatomic, readwrite) double viscosity;

// Vapour Phase
@property (nonatomic, readwrite) double v_z;
@property (nonatomic, readwrite) double v_molarEnthalpy;
@property (nonatomic, readwrite) double v_molarEntropy;

@property (nonatomic, readwrite) double v_molarDensity;
@property (nonatomic, readwrite) double v_massDensity;

@property (nonatomic, readwrite) double v_viscosity;

// Liquid Phase
@property (nonatomic, readwrite) double l_z;
@property (nonatomic, readwrite) double l_molarEnthalpy;
@property (nonatomic, readwrite) double l_molarEntropy;

@property (nonatomic, readwrite) double l_molarDensity;
@property (nonatomic, readwrite) double l_massDensity;

@property (nonatomic, readwrite) double l_viscosity;

@end

@implementation Steam

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name andComponents:(NSArray *)components {
    self = [self initWithName:name];
    if (self) {
        self.components = components;
    }
    return self;
}

- (NSArray *)properties {
    if (_properties != nil) {
        return _properties;
    }
    Property *entalphy = [[Property alloc]initWithName:@"Enthalpy"];
    Property *entropy = [[Property alloc]initWithName:@"Entropy"];
    Property *molarWeight = [[Property alloc]initWithName:@"Molar Weight"];
    Property *zFactor = [[Property alloc]initWithName:@"z Factor"];
    Property *molarDensity = [[Property alloc]initWithName:@"Molar Density"];
    Property *massDensity = [[Property alloc]initWithName:@"Mass Density"];
    Property *viscosity = [[Property alloc]initWithName:@"Viscosity"];
    
    _properties = @[entalphy, entropy, molarWeight, zFactor, molarDensity, massDensity, viscosity];
    return _properties;
}

- (NSArray *)liquidComposition {
    if (_liquidComposition) {
        return _liquidComposition;
    }
    NSMutableArray *mut = [NSMutableArray arrayWithCapacity:self.components.count];
    for (int i=0; i<self.components.count; i++) {
        mut[i]=@"";
    }
    _liquidComposition = [mut copy];
    return _liquidComposition;
}

- (NSArray *)vapourComposition {
    if (_vapourComposition) {
        return _vapourComposition;
    }
    NSMutableArray *mut = [NSMutableArray arrayWithCapacity:self.components.count];
    for (int i=0; i<self.components.count; i++) {
        mut[i]=@"";
    }
    _vapourComposition = [mut copy];
    return _vapourComposition;
}

- (NSArray *)kValues {
    if (_kValues) {
        return _kValues;
    }
    NSMutableArray *mut = [NSMutableArray arrayWithCapacity:self.components.count];
    for (int i=0; i<self.components.count; i++) {
        mut[i]=@"";
    }
    _kValues = [mut copy];
    return _kValues;
}

@end
