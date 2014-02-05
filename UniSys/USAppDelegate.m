//
//  USAppDelegate.m
//  UniSys
//
//  Created by Emiliano Bivachi on 10/01/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "USAppDelegate.h"
#import "USCoreDataController.h"
#import "Component.h"

@implementation USAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    /*
    NSManagedObjectContext *moc = [[USCoreDataController sharedInstance] masterManagedObjectContext];
    Component *metano = [NSEntityDescription insertNewObjectForEntityForName:@"Component" inManagedObjectContext:moc];
    metano.name = @"Metano";
    metano.formula = @"CH4";
    metano.tc = 190.56;
    metano.pc = 4599000.0;
    metano.vc = 98.6;
    metano.zc = 0.286;
    metano.w = 0.011;
    Component *etano = [NSEntityDescription insertNewObjectForEntityForName:@"Component" inManagedObjectContext:moc];
    etano.name = @"Etano";
    etano.tc = 305.3;
    etano.pc = 4872000.0;
    etano.vc = 145.5;
    etano.zc = 0.279;
    etano.w = 0.1;
    Component *propano = [NSEntityDescription insertNewObjectForEntityForName:@"Component" inManagedObjectContext:moc];
    propano.name = @"Propano";
    propano.tc = 369.83;
    propano.pc = 4248000.0;
    propano.vc = 200.0;
    propano.zc = 0.276;
    propano.w = 0.152;
    Component *butano = [NSEntityDescription insertNewObjectForEntityForName:@"Component" inManagedObjectContext:moc];
    butano.name = @"Butano";
    butano.tc = 425.1;
    butano.pc = 3796000.0;
    butano.vc = 255.0;
    butano.zc = 0.274;
    butano.w = 0.2;
    Component *pentano = [NSEntityDescription insertNewObjectForEntityForName:@"Component" inManagedObjectContext:moc];
    pentano.name = @"Pentano";
    pentano.tc = 469.7;
    pentano.pc = 3370000.0;
    pentano.vc = 313.0;
    pentano.zc = 0.270;
    pentano.w = 0.252;
    Component *hexano = [NSEntityDescription insertNewObjectForEntityForName:@"Component" inManagedObjectContext:moc];
    hexano.name = @"Hexano";
    hexano.tc = 507.6;
    hexano.pc = 3025000.0;
    hexano.vc = 371.0;
    hexano.zc = 0.266;
    hexano.w = 0.301;
    Component *heptano = [NSEntityDescription insertNewObjectForEntityForName:@"Component" inManagedObjectContext:moc];
    heptano.name = @"Heptano";
    heptano.tc = 540.2;
    heptano.pc = 2740000.0;
    heptano.vc = 428.0;
    heptano.zc = 0.261;
    heptano.w = 0.350;
    Component *octano = [NSEntityDescription insertNewObjectForEntityForName:@"Component" inManagedObjectContext:moc];
    octano.name = @"Octano";
    octano.tc = 568.7;
    octano.pc = 2490000.0;
    octano.vc = 486.0;
    octano.zc = 0.256;
    octano.w = 0.4;
    Component *nonano = [NSEntityDescription insertNewObjectForEntityForName:@"Component" inManagedObjectContext:moc];
    nonano.name = @"Nonano";
    nonano.tc = 594.6;
    nonano.pc = 2290000.0;
    nonano.vc = 544.0;
    nonano.zc = 0.252;
    nonano.w = 0.444;
    Component *decano = [NSEntityDescription insertNewObjectForEntityForName:@"Component" inManagedObjectContext:moc];
    decano.name = @"Decano";
    decano.tc = 617.7;
    decano.pc = 2110000.0;
    decano.vc = 600.0;
    decano.zc = 0.247;
    decano.w = 0.492;
    
    [[USCoreDataController sharedInstance] saveMasterContext];
    */
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
