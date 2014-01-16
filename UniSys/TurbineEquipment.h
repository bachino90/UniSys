//
//  TurbineEquipment.h
//  UniSys
//
//  Created by Emiliano Bivachi on 13/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "BaseEquipment.h"
#import "RealFluid.h"

@interface TurbineEquipment : BaseEquipment

@property (nonatomic) double isoEntropyPerformance;

@property (nonatomic, readonly) RealFluid *inletFluid;
@property (nonatomic, readonly) RealFluid *outletFluid;

@end
