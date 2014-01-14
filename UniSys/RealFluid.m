//
//  RealFluid.m
//  UniSys
//
//  Created by Emiliano Bivachi on 12/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "RealFluid.h"
#import "RealGas.h"
#import "Component.h"

@implementation RealFluid
- (BOOL)isDeterminated {
    return (self.molarFlow > 0 && self.temperature > 0 && (self.pressure > 0 || self.volumen > 0));
}
@end
