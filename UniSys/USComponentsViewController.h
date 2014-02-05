//
//  USComponentsViewController.h
//  UniSys
//
//  Created by Emiliano Bivachi on 01/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseFile.h"

@protocol USComponentsViewControllerDelegate <NSObject>
- (void)finishSetupWithCaseFile:(CaseFile *)file;
@end

@interface USComponentsViewController : UITableViewController

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) CaseFile *caseFile;
@property (nonatomic, weak) id <USComponentsViewControllerDelegate> delegate;

@end
