//
//  Component.m
//  UniSys
//
//  Created by Emiliano Bivachi on 11/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "Component.h"

@interface Component ()

@property (nonatomic, readwrite) double Tc;
@property (nonatomic, readwrite) double Pc;
@property (nonatomic, readwrite) double Vc;
@property (nonatomic, readwrite) double Zc;
@property (nonatomic, readwrite) double w;

@end

@implementation Component

- (instancetype)init {
    self = [super init];
    if (self) {
        self.Tc = -1;
        self.Pc = -1;
        self.Vc = -1;
        self.Zc = -1;
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
