//
//  USComponentsViewController.m
//  UniSys
//
//  Created by Emiliano Bivachi on 01/02/14.
//  Copyright (c) 2014 Emiliano Bivachi. All rights reserved.
//

#import "USComponentsViewController.h"
#import "USModelComponentViewController.h"
#import "USBinaryParametersViewController.h"
#import "ComponentCell.h"
#import "USCoreDataController.h"
#import "Component.h"
#import "Component+UniSys.h"

@interface USComponentsViewController () <UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@end

@implementation USComponentsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)createSearchBar
{
    if (self.tableView && !self.tableView.tableHeaderView) {
        self.searchBar = [[UISearchBar alloc] init];
        self.searchBar.frame = CGRectMake(0, 0, 0, 38);
        self.tableView.tableHeaderView = self.searchBar;
        self.searchBar.placeholder = @"Search component by name or formula";
        self.searchBar.showsCancelButton = YES;
        self.searchBar.delegate = self;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSearchBar];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneSetup:(id)sender {
    [self.delegate finishSetupWithCaseFile:self.caseFile];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if ([[self.fetchedResultsController sections]count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        rows = [sectionInfo numberOfObjects];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Component Cell";
    ComponentCell *cell = (ComponentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Component *comp = [self.fetchedResultsController
                                      objectAtIndexPath:indexPath];
    cell.nameLabel.text = comp.name;
    cell.formulaLabel.text = comp.formula;
    cell.accessoryType = UITableViewCellAccessoryNone;
    for (int i=0; i<self.caseFile.componentCount; i++) {
        if ([comp isEqual:self.caseFile.components[i]]) {
            cell.checked = YES;
            break;
        }
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ComponentCell *cell = (ComponentCell *)[tableView cellForRowAtIndexPath:indexPath];
    Component *comp = [self.fetchedResultsController
                       objectAtIndexPath:indexPath];
    if (cell.checked) {
        [self.caseFile deleteComponent:comp];
    } else {
        [self.caseFile addComponent:comp];
    }
    cell.checked = !cell.checked;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"Fluid Packages Segue"]) {
        UITabBarController *tabBar = [segue destinationViewController];
        USModelComponentViewController *mcvc = tabBar.viewControllers[0];
        mcvc.caseFile = self.caseFile;
        USBinaryParametersViewController *bpvc = tabBar.viewControllers[1];
        bpvc.caseFile = self.caseFile;
    }
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return  _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Component"];
    NSArray *sortDescriptor = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    
    fetchRequest.sortDescriptors = sortDescriptor;
    
    NSManagedObjectContext *moc = [[USCoreDataController sharedInstance] backgroundManagedObjectContext];
    NSFetchedResultsController *aFetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:moc
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    aFetchedResultController.delegate = nil;
    self.fetchedResultsController = aFetchedResultController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
}

- (void)updateSearch:(NSString *)searchText {
    NSPredicate *predicate = nil;
    if (![searchText isEqualToString:@""]) {
        NSPredicate *name = [NSPredicate predicateWithFormat:@"name contains[c] %@",searchText];
        NSPredicate *formula = [NSPredicate predicateWithFormat:@"formula contains[c] %@",searchText];
        predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[name,formula]];
    }
    
    self.fetchedResultsController.fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
}

#pragma mark - Search Bar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self updateSearch:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


@end
