//
//  Property.h
//  UniSys
//
//  Created by Emiliano Bivachi on 07/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Property : NSObject

- (instancetype)initWithName:(NSString *)name;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *globalValue;
@property (nonatomic, strong) NSString *liquidValue;
@property (nonatomic, strong) NSString *vapourValue;

@end
