//
//  BaseEquipment.h
//  UniSys
//
//  Created by Emiliano Bivachi on 13/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseEquipment : NSObject
@property (nonatomic, readonly) NSInteger maxFlowInletStreams;
@property (nonatomic, readonly) NSInteger minFlowInletStreams;
@property (nonatomic, readonly) NSInteger maxFlowOutletStreams;
@property (nonatomic, readonly) NSInteger minFlowOutletStreams;

@property (nonatomic, strong) NSArray *inletStreams;
@property (nonatomic, strong) NSArray *outletStreams;

@property (nonatomic) double heatStream;
@property (nonatomic) double workStream;

- (void)performMassEnergyBalance;

@end
