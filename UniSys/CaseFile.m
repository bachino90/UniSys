//
//  CaseFile.m
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "CaseFile.h"
#import "Component+UniSys.h"

@implementation CaseFile

- (instancetype)init {
    self = [super init];
    if (self) {
        self.components = [[NSMutableArray alloc]init];
        self.model = PR;
        self.name = @"New Project";
    }
    return self;
}

- (NSInteger)componentCount {
    return self.components.count;
}

- (void)addComponent:(Component *)comp {
    for (int i=0; i<self.componentCount; i++) {
        if ([comp isTheSame:self.components[i]]) {
            return;
        }
    }
    
    [self.components addObject:comp];
}

- (void)deleteComponent:(Component *)comp {
    [self.components removeObject:comp];
}

@end
