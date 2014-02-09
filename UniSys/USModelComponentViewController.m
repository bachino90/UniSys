//
//  USModelComponentViewController.m
//  UniSys
//
//  Created by Emiliano Bivachi on 04/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "USModelComponentViewController.h"
#import "FluidModel.h"

@interface USModelComponentViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *modelTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeModelSegmentedControl;
@property (strong, nonatomic) NSArray *models;
@end

@implementation USModelComponentViewController

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
    self.models = [FluidModel allModels];
    self.typeModelSegmentedControl.selectedSegmentIndex = 0;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)filterModels:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.models = [FluidModel allModels];
    } else if (sender.selectedSegmentIndex == 1) {
        self.models = [FluidModel eosModels];
    } else if (sender.selectedSegmentIndex == 2) {
        self.models = [FluidModel activityModels];
    }
    [self.modelTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Model Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    FluidModel *model = self.models[indexPath.row];
    cell.textLabel.text = model.name;
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (self.actualProject.model == model.type) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    FluidModel *model = self.models[indexPath.row];
    
    self.actualProject.model = model.type;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self.modelTableView reloadData];
}

@end
