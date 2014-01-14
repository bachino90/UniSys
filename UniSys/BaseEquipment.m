//
//  BaseEquipment.m
//  UniSys
//
//  Created by Emiliano Bivachi on 13/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "BaseEquipment.h"

@interface BaseEquipment ()
@property (nonatomic, readonly) BOOL isThereHeatStream;
@property (nonatomic, readonly) BOOL isThereWorkStream;
@end

@implementation BaseEquipment

- (instancetype)init {
    self = [super init];
    if (self) {
        self.heatStream = 0;
        self.workStream = 0;
    }
    return self;
}

- (NSInteger)maxFlowInletStreams {
    return -1;
}

- (NSInteger)minFlowInletStreams {
    return -1;
}

- (NSInteger)maxFlowOutletStreams {
    return -1;
}

- (NSInteger)minFlowOutletStreams {
    return -1;
}

- (BOOL)isThereHeatStream {
    return NO;
}

- (BOOL)isThereWorkStream {
    return NO;
}

- (BOOL)checkDegreeOfFreedom {
    if (self.inletStreams || self.outletStreams) {
        return YES;
    } else {
        return NO;
    }
}

- (void)performMassEnergyBalance {
    if (![self checkDegreeOfFreedom]) {
        return ;
    }
    
    if (self.outletStreams) {
        self.inletStreams = self.outletStreams;
    } else if (self.inletStreams) {
        self.outletStreams = self.inletStreams;
    }
}

@end
