//
//  Component.m
//  UniSys
//
//  Created by Emiliano Bivachi on 11/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "Component.h"

@interface Component ()

@property (nonatomic, readwrite) double tc;
@property (nonatomic, readwrite) double pc;
@property (nonatomic, readwrite) double vc;
@property (nonatomic, readwrite) double zc;
@property (nonatomic, readwrite) double w;
@property (nonatomic, strong, readwrite) NSDictionary *cpIdealCoeff;

@end

@implementation Component

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tc = -1;
        self.pc = -1;
        self.vc = -1;
        self.zc = -1;
        self.w = -1;
    }
    return self;
}

- (instancetype)initWithID:(NSInteger)id {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        if ([name isEqualToString:@"metano"]) {
            self.tc = 190.56;
            self.pc = 4599000;
            self.vc = 98.6;
            self.zc = 0.286;
            self.w = 0.011;
            
        } else { //propano
            self.tc = 369.83;
            self.pc = 4248000;
            self.vc = 200.0;
            self.zc = 0.276;
            self.w = 0.152;
        }        
    }
    return self;
}

- (instancetype)initWithNomenclature:(NSString *)nom {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
