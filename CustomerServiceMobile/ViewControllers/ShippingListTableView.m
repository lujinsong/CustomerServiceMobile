

#import "ShippingListTableView.h"
#import "ShippingList.h"
#import "ShippingListCellView.h"
#import "SharedConstants.h"
#import "SDUserPreference.h"

@implementation ShippingListTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


#pragma NSFetchResultControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    
    
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self cellForRowAtIndexPath:indexPath] atIndexPath:indexPath tableView:self];
            break;
        case NSFetchedResultsChangeMove:
            [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
            
    }
}



#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    id sectionInfo = [[[self.availableDelegate fetchedAvailableResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AvailableListCell";
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath tableView:tableView];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    ShippingList *t = nil;
    t = (ShippingList*)[[self.availableDelegate fetchedAvailableResultsController] objectAtIndexPath:indexPath];

    
    ShippingListCellView* listcell = (ShippingListCellView*)cell;
    if ([t.ldmnd_stat_id isEqualToString:kShippingTypePickStatID]) {
        listcell.imgPicker.hidden = NO;
    }
    else
    {
        listcell.imgPicker.hidden = YES;
    }
    listcell.lblBin.text = t.fr_bin_code_id;
    if([kShippingDocTypeID10 isEqualToString:t.doc_type_id])
    {
        listcell.lblDestination.text = t.to_company_id;
    }
    else
    {
        listcell.lblDestination.text = t.to_warehouse_id;
    }
    
    listcell.lblDueDate.text = [[SDUserPreference sharedUserPreference].dateFormatter stringFromDate:t.due_date];
    
    listcell.lblOriginalDocID.text = t.orig_doc_id;
    listcell.lblPartNumber.text = t.bpart_id;
    listcell.lblPriority.text = t.priority;
}



-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self showDetail:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

-(void)showDetail:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ShippingList* obj = nil;
    obj = (ShippingList*)[[self.availableDelegate fetchedAvailableResultsController] objectAtIndexPath:indexPath];  
    [self.availableDelegate setSelectedShippingList:obj];
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetail:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

@end
