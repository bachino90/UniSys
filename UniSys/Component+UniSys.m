//
//  Component+UniSys.m
//  UniSys
//
//  Created by Emiliano Bivachi on 31/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "Component+UniSys.h"
#import "USCoreDataController.h"

@implementation Component (UniSys)
/*
@synthesize cubic_a;
@synthesize cubic_a_const;
@synthesize cubic_b;
@synthesize cubic_c;
@synthesize cubic_c_const;
@synthesize cubic_dadt;
@synthesize cubic_k;
@synthesize cubic_PRSV_ki;
@synthesize composition;
@synthesize phi;
@synthesize zra;
*/


- (BOOL)isTheSame:(id)object {
    if ([object isKindOfClass:[Component class]]) {
        Component *other = (Component *)object;
        if ([other.name isEqualToString:self.name] &&
            [other.formula isEqualToString:self.formula]) {
            return YES;
        } else
            return NO;
    } else
        return NO;
}

+ (Component *)componentWithName:(NSString *)name {
    NSManagedObjectContext *moc = [[USCoreDataController sharedInstance]masterManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Component"];
    NSArray *sortDescriptor = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    
    fetchRequest.sortDescriptors = sortDescriptor;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@",name];
    fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:fetchRequest error:&error];
    if (error || result.count < 1) {
        return nil;
    }
    
    return [result firstObject];
}


@end
