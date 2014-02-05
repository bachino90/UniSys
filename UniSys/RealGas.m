//
//  RealGas.m
//  UniSys
//
//  Created by Emiliano Bivachi on 10/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "RealGas.h"
#import "Component.h"
#import "IdealGas.h"
#import "CubicGas.h"

@interface RealGas ()
@property (nonatomic, readwrite) FluidModelType modelType;

@property (nonatomic, strong) id fluid;

@end

@implementation RealGas

- (instancetype)initWithType:(FluidModelType)type andComponents:(NSArray *)comp isLiquid:(BOOL)isLiquid {
    self = [super init];
    if (self) {
        self.modelType = type;
        switch (type) {
            case Ideal:
                self.fluid = [[IdealGas alloc] initWithComponents:comp isLiquid:isLiquid];
            case PR:
            case PRSV:
            case PRTwu:
            case RK:
            case SRK:
            case SRKKabadiDanner:
            case SRKTwu:
                self.fluid = [[CubicGas alloc] initWithComponents:comp isLiquid:isLiquid];
                break;
                
            default:
                break;
        }
    }
    return self;
}

- (NSString *)modelName {
    return [self modelNameForType:self.modelType];
}

+ (NSString *)modelNameForType:(FluidModelType)type {
    NSString *name;
    switch (type) {
        case Ideal:
            name = @"Ideal gas";
            break;
        case PR:
            name = @"Peng Robinson";
            break;
        case PRSV:
            name = @"Stryjek and Vera";
            break;
        case PRTwu:
            name = @"PR Twu";
            break;
        case RK:
            name = @"Redlich Kwong";
            break;
        case SRK:
            name = @"Soave Redlich Kwong";
            break;
        case SRKTwu:
            name = @"SRK Twu";
            break;
        case SRKKabadiDanner:
            name = @"SRK Kabadi Danner";
            break;
        default:
            break;
    }
    return name;
}

+ (BOOL)isEOS:(FluidModelType)type {
    BOOL aux = NO;
    switch (type) {
        case Ideal:
        case PR:
        case PRSV:
        case PRTwu:
        case RK:
        case SRK:
        case SRKTwu:
        case SRKKabadiDanner:
            aux = YES;
            break;
        default:
            break;
    }
    return aux;
}

@end
