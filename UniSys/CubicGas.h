//
//  CubicGas.h
//  UniSys
//
//  Created by Emiliano Bivachi on 18/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "IdealGas.h"

typedef enum {
    PengRobinsonEOS,
    VanDerWaalsEOS,
    WilsonEOS,
    RedlichKwongEOS,
    SoaveEOS,
    PenelouxEOS,
    PatelTejaEOS,
    StryjekVeraEOS
} CubicEOS;

@interface CubicGas : IdealGas

- (instancetype)initWithType:(CubicEOS)type andComponents:(NSArray *)comp isLiquid:(BOOL)isLiquid;
- (instancetype)initWithType:(CubicEOS)type andComponents:(NSArray *)comp;

@property (nonatomic, readonly) CubicEOS type;
@property (nonatomic, readonly) NSString *eosName;

@end
