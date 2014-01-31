//
//  Component.m
//  UniSys
//
//  Created by Emiliano Bivachi on 11/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "Component1.h"

@interface Component1 ()

@property (nonatomic, readwrite) double tc;
@property (nonatomic, readwrite) double pc;
@property (nonatomic, readwrite) double vc;
@property (nonatomic, readwrite) double zc;
@property (nonatomic, readwrite) double w;
@property (nonatomic, strong, readwrite) NSDictionary *cpIdealCoeff;

@end

@implementation Component1

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
            self.pc = 4599000.0;
            self.vc = 98.6;
            self.zc = 0.286;
            self.w = 0.011;
            
        } else if ([name isEqualToString:@"etano"]) { //propano
            self.tc = 305.3;
            self.pc = 4872000.0;
            self.vc = 145.5;
            self.zc = 0.279;
            self.w = 0.1;
        } else if ([name isEqualToString:@"propano"]) { //propano
            self.tc = 369.83;
            self.pc = 4248000.0;
            self.vc = 200.0;
            self.zc = 0.276;
            self.w = 0.152;
        } else if ([name isEqualToString:@"butano"]) { //propano
            self.tc = 425.1;
            self.pc = 3796000.0;
            self.vc = 255.0;
            self.zc = 0.274;
            self.w = 0.2;
        } else if ([name isEqualToString:@"pentano"]) { //propano
            self.tc = 469.7;
            self.pc = 3370000.0;
            self.vc = 313.0;
            self.zc = 0.270;
            self.w = 0.252;
        } else if ([name isEqualToString:@"hexano"]) { //propano
            self.tc = 507.6;
            self.pc = 3025000.0;
            self.vc = 371.0;
            self.zc = 0.266;
            self.w = 0.301;
        } else if ([name isEqualToString:@"heptano"]) { //propano
            self.tc = 540.2;
            self.pc = 2740000.0;
            self.vc = 428.0;
            self.zc = 0.261;
            self.w = 0.350;
        } else if ([name isEqualToString:@"octano"]) { //propano
            self.tc = 568.7;
            self.pc = 2490000.0;
            self.vc = 486.0;
            self.zc = 0.256;
            self.w = 0.4;
        } else if ([name isEqualToString:@"nonano"]) { //propano
            self.tc = 594.6;
            self.pc = 2290000.0;
            self.vc = 544.0;
            self.zc = 0.252;
            self.w = 0.444;
        } else if ([name isEqualToString:@"decano"]) { //propano
            self.tc = 617.7;
            self.pc = 2110000.0;
            self.vc = 600.0;
            self.zc = 0.247;
            self.w = 0.492;
        } else if ([name isEqualToString:@"argon"]) { //propano
            self.tc = 150.86;
            self.pc = 4898000.0;
            self.vc = 74.6;
            self.zc = 0.291;
            self.w = -0.004;
        } else if ([name isEqualToString:@"nitrogeno"]) { //propano
            self.tc = 126.2;
            self.pc = 3400000.0;
            self.vc = 89.2;
            self.zc = 0.289;
            self.w = 0.038;
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
