//
//  USCompositionSettingViewController.m
//  UniSys
//
//  Created by Emiliano Bivachi on 05/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "USCompositionSettingViewController.h"
#import "USSteamTabBarController.h"
#import "Steam.h"
#import "Component.h"
#import "CompositionCell.h"

@interface USCompositionSettingViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *typeFractionBtn;
@property (weak, nonatomic) IBOutlet UITableView *compositionTableView;

@property (strong, nonatomic) Steam *steam;

@end

@implementation USCompositionSettingViewController

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
    USSteamTabBarController *tabController = (USSteamTabBarController *)self.tabBarController;
    self.steam = tabController.steam;
    [self setNavBarTitle:tabController.steam.name];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)normalizeComposition:(UIButton *)sender {
}

- (IBAction)equalizeComposition:(UIButton *)sender {
}

- (IBAction)eraseComposition:(id)sender {
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.steam.components.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CompositionCell";
    CompositionCell *cell = (CompositionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Component *comp = self.steam.components[indexPath.row];
    
    cell.componentName.text = comp.name;
    cell.globalComposition.text = [NSString stringWithFormat:@"%g", comp.composition];
    cell.liquidComposition.text = self.steam.liquidComposition[indexPath.row];
    cell.vapourComposition.text = self.steam.vapourComposition[indexPath.row];
    cell.kValue.text = self.steam.kValues[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0;
}

@end
