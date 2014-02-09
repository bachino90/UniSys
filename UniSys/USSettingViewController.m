//
//  USSettingViewController.m
//  UniSys
//
//  Created by Emiliano Bivachi on 05/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "USSettingViewController.h"

#define NAV_BAR_HEIGHT 20.0

@interface USSettingViewController ()
@property (nonatomic, weak) IBOutlet UINavigationBar *navBar;
@end

@implementation USSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneBtn:(id)sender {
    [self.delegate settingControllerFinishEditing:self];
}

- (void)setNavBarTitle:(NSString *)name {
    UINavigationItem *title = [[UINavigationItem alloc]initWithTitle:name];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtn:)];
    title.rightBarButtonItem = doneBtn;
    [self.navBar setItems:@[title]];;
}

@end
