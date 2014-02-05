//
//  USNewProjectViewController.h
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseFile.h"

@protocol USNewProjectViewControllerDelegate <NSObject>
- (void)openNewCaseFile;
- (void)openCaseFile:(CaseFile *)caseFile;
- (void)cancelNew;
@end

@interface USNewProjectViewController : UIViewController

@property (nonatomic, weak) id <USNewProjectViewControllerDelegate> delegate;

@end
