

#import "ShippingViewController.h"
#import "AutoCompleteController.h"
#import "AutoCompleteDataHelper.h"
#import "Carrier.h"
#import "Warehouse.h"
#import "Company.h"
#import "MyRestkit.h"
#import "ShippingScanViewController.h"
#import "ShippingLineItem.h"
#import "ShipmentInstructions.h"

@interface ShippingViewController ()
@property (strong, nonatomic)NSArray* sortDescriptionArray;
-(NSArray*) getSortDescriptions;
-(void)fetchAvailableShippingList;
-(void)addShippingLineItem:(ShippingList*)shipplingList;
-(void)threadStartAnimating:(UIActivityIndicatorView *)indicator;
-(void)setDestinationEnable:(BOOL)isEnable;
-(void)hideKeyBoard;

-(void)fetch:(ShippingHeader*)datasource;
-(void)bind:(ShippingHeader*)datasource;
@end

@implementation ShippingViewController

@synthesize shippingHeader=_shippingHeader;
@synthesize isNew=_isNew;
@synthesize isPick=_isPick;
@synthesize selectedShippingList=_selectedShippingList;
@synthesize sortDescriptionArray=_sortDescriptionArray;
@synthesize lblToWarehouseID=_lblToWarehouseID;
@synthesize lblToCompanyID=_lblToCompanyID;

BOOL _isDelete;
NSString* _predicateTypeExpr;
NSString* _empty = @"";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    if(self.isPick)
    {
        self.navigationItem.title =  @"Pick Allocated Parts";
        _predicateTypeExpr = kPredicatePick;
    }
    else
    {
        self.navigationItem.title =  @"Ship Picked Parts";
        _predicateTypeExpr = kPredicateShip;
    }

    self.lblFromWarehouseID.text = [[SDUserPreference sharedUserPreference]DefaultWarehouseID];
    _isDelete = NO;
    if(self.isNew)
    {
        //create one
        NSManagedObjectContext* managedObjectContext = [[SDDataEngine sharedEngine] managedObjectContext];
        ShippingHeader* header = [NSEntityDescription insertNewObjectForEntityForName:kEntityShippingHeader inManagedObjectContext:managedObjectContext];
        if(_isPick)
            header.transaction_type = kShippingTypePick;
        else
            header.transaction_type = kShippingTypeShip;
        
        header.created_by = [SDRestKitEngine sharedEngine].username;
        header.created_date = [NSDate date];
        header.process_date = [NSDate date];
        header.process_status = kProcessStatusNew;
        header.no_of_packages = @"0";
        header.weight = @"0";
        header.fr_warehouse_id = self.lblFromWarehouseID.text;
        header.printer = [[SDUserPreference sharedUserPreference] Printer];
        _shippingHeader = header;
        _isDelete = YES;
        
        //save the shippingheader and get the ipad_id field populated
        [[SDDataEngine sharedEngine] save:_shippingHeader];
        
     
        _shippingHeader.ipad_id = [SDDataEngine ipadid:header.transaction_type primaryKey:[SDDataEngine getPKString:_shippingHeader] addRandomNumber:YES];
        
        //save again
        [[SDDataEngine sharedEngine] save:_shippingHeader];
        [self setDestinationEnable:YES];
    }
    else{
        if([self.shippingHeader.process_status isEqualToString:kProcessStatusCOMPLETED])
        {
            self.btnSubmit.hidden = YES;
            [self.view setUserInteractionEnabled:NO];
            [self.selectedTableView setUserInteractionEnabled:NO];
        }
               


        
    }
    
      

    //set up the delegate
    self.selectedTableView.deleteDelegate = self;
    self.selectedTableView.delegate = self.selectedTableView;
    self.selectedTableView.dataSource = self.selectedTableView;

    self.availableTableView.availableDelegate = self;
    self.availableTableView.delegate = self.availableTableView;
    self.availableTableView.dataSource = self.availableTableView;
    

    [self bind:_shippingHeader]; 
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(![_shippingHeader.process_status isEqualToString:kProcessStatusCOMPLETED])
    {
        if(_isDelete||[self.shippingHeader.shippingLineItems count]<=0)
        {
            [[SDDataEngine sharedEngine]delete:_shippingHeader];
        }
        else
        {
            [self fetch:_shippingHeader];
            [[SDDataEngine sharedEngine]save:_shippingHeader];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if([[segue identifier] isEqualToString:@"ShowScanSegue"])
    {
        ShippingScanViewController* controller = (ShippingScanViewController*)[segue destinationViewController];
        
        controller.isPick = self.isPick;
        controller.item = self.selectedShippingList;
        controller.delegate = self;
    }

}



#pragma Available List Fetch Controller

-(void)fetchAvailableShippingList
{
    //prepare predicate
    NSString* predicateFormat = nil;
    NSPredicate* predicate = nil;
    
    NSString* to_company = [SDUserPreference trim:self.lblToCompanyID.text];
    NSString* to_warehouse = [SDUserPreference trim:self.lblToWarehouseID.text];


    if(to_company!=nil&&![to_company isEqualToString:@""])
    {
        predicateFormat = [NSString stringWithFormat:kFetchTemplateAnd, _predicateTypeExpr, kFetchTemplateToCompany];
        predicate = [NSPredicate predicateWithFormat:predicateFormat,to_company];
    }
    else if(to_warehouse!=nil&&![to_warehouse isEqualToString:@""])
    {
        predicateFormat = [NSString stringWithFormat:kFetchTemplateAnd, _predicateTypeExpr, kFetchTemplateToWarehouse];
        predicate = [NSPredicate predicateWithFormat:predicateFormat,to_warehouse];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:_predicateTypeExpr];
    }
    [[self fetchedResultsController].fetchRequest setPredicate:predicate];

    
    //then do a database fetch
    NSError* error;
    if(![[self fetchedResultsController] performFetch:&error ])
    {
        NSLog(@"Unexpected Error when fetch Receiving(ShippingList) Transaction List.Unresolved Error %@ ; User Info:%@",error,[error userInfo]);
        exit(-1);
    }
    
    [[self availableTableView] reloadData];
    
}

-(NSFetchedResultsController *)fetchedResultsController
{
    if(_fetchedAvailableResultsController!=nil)
        return _fetchedAvailableResultsController;
    
    //create one
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:kEntityShippingList inManagedObjectContext:[SDDataEngine sharedEngine].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray* sortedArray = [self getSortDescriptions];
    
    [fetchRequest setSortDescriptors:sortedArray];
    
    [fetchRequest setFetchBatchSize:[[SDUserPreference sharedUserPreference] MaxRows]];
    
    _fetchedAvailableResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[SDDataEngine sharedEngine] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedAvailableResultsController.delegate = self.availableTableView;
    return _fetchedAvailableResultsController;
}





-(NSArray*) getSortDescriptions
{
    if(nil!=_sortDescriptionArray)
    {
        
        return _sortDescriptionArray;
    }
    
//     NSSortDescriptor *sortType = [[NSSortDescriptor alloc]initWithKey:@"ldmnd_stat_id" ascending:YES];
    
    NSSortDescriptor *sortDueDate = [[NSSortDescriptor alloc]initWithKey:@"due_date" ascending:YES];
    
   
    
    _sortDescriptionArray = @[sortDueDate];
    return _sortDescriptionArray;
}



#pragma ShippingLineItemDeleteDelegate,ShippingScanViewDelegate



-(void)setSelectedShippingList:(ShippingList*)selected
{
//    //check whether 
//    NSString* toCompanyID = [SDUserPreference trim:self.lblToCompanyID.text];
//    NSString* toWarehouseID = [SDUserPreference trim:self.lblToWarehouseID.text];
//    
//    if((toCompanyID==nil||[toCompanyID isEqualToString:_empty])&&(toWarehouseID==nil||[toWarehouseID isEqualToString:_empty]))
//    {
//        [SDDataEngine alert:kMessageSHippingNoDestinationValue title:nil template:nil delegate:self];
//        return;
//    }
    _selectedShippingList = selected;
    //call the ShippingScanViewController
    [self performSegueWithIdentifier:@"ShowScanSegue" sender:self];
    
}

-(void)deleteLineItem:(NSInteger)rowIndex
{
    if(nil!=self.shippingHeader&&![kProcessStatusCOMPLETED isEqualToString:self.shippingHeader.process_status]&&rowIndex<[self.shippingHeader.shippingLineItems count])
    {
        
        NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.shippingHeader.shippingLineItems];
        ShippingLineItem* lineItem = (ShippingLineItem*)[tempSet objectAtIndex:rowIndex];
        
        //remove it from the shipping list
        NSArray* shippinglists = [[SDDataEngine sharedEngine]data:kEntityShippingList predicateTemplate:kFetchTemplateServerID predicateValue:lineItem.server_id descriptors:nil];

        if ([shippinglists count]>0) {
            ShippingList* shippingList = [shippinglists objectAtIndex:0];
            if (nil!=shippingList) {
                shippingList.shipping_ipad_id = nil;
                [[SDDataEngine sharedEngine]save:shippingList];
            }
        }
        
        [tempSet removeObject:[tempSet objectAtIndex:rowIndex]];
        self.shippingHeader.shippingLineItems = tempSet;
        [self.shippingHeader didChangeValueForKey:@"shippingLineItems"];
        
        if([self.shippingHeader.shippingLineItems count]==0)
        {
            self.lblToCompanyID.text=@"";
            self.lblToWarehouseID.text=@"";
            [self setDestinationEnable:YES];
        }
        
        //save it
        [[SDDataEngine sharedEngine]save:self.shippingHeader];
        
        //refresh the lists
        [self fetchAvailableShippingList];
        
        if([self.shippingHeader.shippingLineItems count]>0)
            [self setDestinationEnable:NO];
        else
            [self setDestinationEnable:YES];
        
        [self.selectedTableView reloadData];
        
        
    }
}

-(void)addLineItem:(ShippingList *)lineItem status:(BOOL)status
{
    if(status)
    {
        //check whether to company id or to warehouse id has been selected.
//        NSString* empty = @"";
//        NSString* toCompanyID = [SDUserPreference trim:self.lblToCompanyID.text];
//        NSString* toWarehouseID = [SDUserPreference trim:self.lblToWarehouseID.text];
//        if([empty isEqualToString:toCompanyID]&&[empty isEqualToString:toWarehouseID])
//        {
//            //alert
//            [SDDataEngine alert:kMessageShippingDestination title:@"Attention" template:nil delegate:nil];
//            return;
//        }
        [self addShippingLineItem:lineItem];
        
        if([self.shippingHeader.shippingLineItems count]>0)
            [self setDestinationEnable:NO];
        else
            [self setDestinationEnable:YES];
    }
    
}

-(void)addShippingLineItem:(ShippingList*)shippingList
{
    if(nil!=shippingList&&nil!=self.shippingHeader)
    { 
     //create a new ShippingLineItem
        NSManagedObjectContext* managedObjectContext = [[SDDataEngine sharedEngine] managedObjectContext];
       ShippingLineItem* shippingLineItem = [NSEntityDescription insertNewObjectForEntityForName:kEntityShippingLineItem inManagedObjectContext:managedObjectContext];
        
        //populate it with shipplist item
        shippingLineItem.bpart_id = shippingList.bpart_id;
        shippingLineItem.demand_id = shippingList.demand_id;
        shippingLineItem.fr_inv_type_id = shippingList.fr_inv_type_id;
        shippingLineItem.item_id = shippingList.item_id;
        shippingLineItem.ldmnd_stat_id = shippingList.ldmnd_stat_id;
        shippingLineItem.orig_doc_id = shippingList.orig_doc_id;
        shippingLineItem.serial_no = shippingList.serial_no;
        shippingLineItem.server_id = shippingList.server_id;
        shippingLineItem.shipped_qty = shippingList.qty;
        shippingLineItem.priority = shippingList.priority;
        shippingLineItem.due_date = shippingList.due_date;
        shippingLineItem.doc_type_id = shippingList.doc_type_id;
        shippingLineItem.to_company_id = shippingList.to_company_id;
        shippingLineItem.to_warehouse_id = shippingList.to_warehouse_id;
        shippingLineItem.header = self.shippingHeader;

        
        //add to the set
        NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.shippingHeader.shippingLineItems];
        shippingLineItem.lineitemnumber = [NSString  stringWithFormat:@"%d",[tempSet count]+1];
        [tempSet addObject:shippingLineItem];
        
        self.shippingHeader.shippingLineItems = tempSet;
        [self.shippingHeader didChangeValueForKey:@"shippingLineItems"];
        
        
        
        //check whether there is only one item. if yes, use the doc_type_id and destination to populate the GUI
        if([self.shippingHeader.shippingLineItems count]==1)
        {
            [self setDestinationID:self.shippingHeader];
            [self bindGUIDestination:shippingList.doc_type_id toCompanyID:shippingList.to_company_id toWarehouseID:shippingList.to_warehouse_id];
            [self populateShipmentInstruction];
        }
        [[SDDataEngine sharedEngine]save:self.shippingHeader];
        
        //mark this shippinglist item
        shippingList.shipping_ipad_id = self.shippingHeader.ipad_id;
        [[SDDataEngine sharedEngine]save:shippingList];
        
  
        
        //refresh the lists
        [self fetchAvailableShippingList];
        [self.selectedTableView reloadData];
        
        //now you can not delete this shipheader item now.
        _isDelete = NO;
    }
    

}


- (IBAction)btnShipmentInstructions:(id)sender {
    [self populateShipmentInstruction];
    
}

-(void) populateShipmentInstruction
{
    NSString* dest = nil;
    NSString* toCompanyID = [SDUserPreference trim:self.lblToCompanyID.text];
    NSString* toWarehouseID = [SDUserPreference trim:self.lblToWarehouseID.text];
    
    if(!(toCompanyID==nil||[toCompanyID isEqualToString:_empty]))
    {
        dest = toCompanyID;
    }
    else
    {
        dest = toWarehouseID;
    }

    
   NSArray* instructions =  [[SDDataEngine sharedEngine] data:kEntityShipmentInstructions predicateTemplate:kPredicateShipmentInstruction predicateValue:dest descriptors:nil];
    NSMutableString* aString = [NSMutableString stringWithFormat:@"%@", @""];
    for (ShipmentInstructions* obj in instructions) {
        [aString appendFormat:@"%@\n",obj.ap_description];
    }
    self.txtShippingInstruction.text = aString;
}

#pragma Button Events

- (IBAction)btnToWarehouse:(id)sender {
    NSArray* availableToWarehouse = [[SDDataEngine sharedEngine] distinctValues:kEntityShippingList attributeName:@"to_warehouse_id" predicate:[NSPredicate predicateWithFormat:_predicateTypeExpr]];
    
    AutoCompleteDataHelper* helper = [[AutoCompleteDataHelper alloc] initWithEntityName:kEntityWarehouse
        withDisplayBlock:^(id object){
              return (NSString*)[object objectForKey:@"to_warehouse_id"];
       }
       withData:^(NSString *entityName) {
           return availableToWarehouse;
       }
       withBlock:^(BOOL status, id result){
             if(status==YES)
                self.lblToWarehouseID.text = (NSString*)[result objectForKey:@"to_warehouse_id"];
             else
                self.lblToWarehouseID.text = @"";
           [self textFieldShouldReturn:self.lblToWarehouseID];
             [self dismissViewControllerAnimated:YES completion:nil];
       }
                                      ];
    [helper addSortDescript:kSortAttributeWarehouse ascending:YES];
    //self.modalPresentationStyle = UIModalPresentationFormSheet;
    AutoCompleteController* pickViewController = [[AutoCompleteController alloc] init];
    pickViewController.autoCompleteDelegate = helper;
    pickViewController.autoCompleteTitle = @"Please select a warehouse";
    [self presentViewController:pickViewController animated:YES completion:nil];

    
}
- (IBAction)btnToCompany:(id)sender {
    
    NSArray* availableToCompany = [[SDDataEngine sharedEngine] distinctValues:kEntityShippingList attributeName:@"to_company_id" predicate:[NSPredicate predicateWithFormat:_predicateTypeExpr]];
    
    AutoCompleteDataHelper* helper = [[AutoCompleteDataHelper alloc] initWithEntityName:kEntityCompany
        withDisplayBlock:^(id object){
            return (NSString*)[object objectForKey:@"to_company_id"];
        }
        withData:^(NSString *entityName) {
            return availableToCompany;
        }
        withBlock:^(BOOL status, id result){
            if(status==YES)
                self.lblToCompanyID.text = (NSString*)[result objectForKey:@"to_company_id"];
            else
                self.lblToCompanyID.text = @"";
            [self textFieldShouldReturn:self.lblToCompanyID];
            [self dismissViewControllerAnimated:YES completion:nil];
       }
    ];

    AutoCompleteController* pickViewController = [[AutoCompleteController alloc] init];
    pickViewController.autoCompleteDelegate = helper;
    pickViewController.autoCompleteTitle = @"Please select a company";
    [self presentViewController:pickViewController animated:YES completion:nil];
    
}
- (IBAction)btnSubmitAction:(id)sender {
    //submit the shipping transactin back to server
    //first do the validation
    [self fetch:_shippingHeader];
    
    if(![self validateInput:_shippingHeader])
        return;
    

    
    //post it to the server. later on, this will be handled in the background
    ShippingTransactionController* transactionController = [SDRestKitEngine sharedShippingController];
    
    
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:self.activity_submit];
    sleep(5);
    BOOL isOK = [transactionController post:_shippingHeader];
    [self.activity_submit stopAnimating];
    if(!isOK)
    {
        
        if([transactionController.status isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            //alert
            [SDDataEngine alert:transactionController.message title:kAlertTitleSystemError template:nil delegate:nil];
        }
        else
        {
            //alert
            [SDDataEngine alert:kMessageDataControllerCallFailed title:kAlertTitleTransactionError template:nil delegate:nil];
        }
    }


    
    //save the InventoryHeader first
    [[SDDataEngine sharedEngine] save:_shippingHeader];
    
    //go back
    [self.navigationController popToRootViewControllerAnimated:YES];

    
    
}

-(void)threadStartAnimating:(UIActivityIndicatorView *)indicator
{
    [indicator startAnimating];
}

- (IBAction)btnCarrierID:(id)sender {
    AutoCompleteDataHelper* helper = [[AutoCompleteDataHelper alloc] initWithEntityName:kEntityCarrier
        withDisplayBlock:^(id object){
           Carrier* carrier = (Carrier*)object;
           NSString* display = [NSString stringWithFormat:@"%@", [carrier carrier_id]];
           return display;
        }
        withBlock:    ^(BOOL status, id result){
           if(status==YES)
              self.lblCarrierID.text = [(Carrier*)result carrier_id];
           else
              self.lblCarrierID.text = @"";
           [self textFieldShouldReturn:self.lblCarrierID];
           [self dismissViewControllerAnimated:YES completion:nil];
        }
    ];
    [helper addSortDescript:kSortAttributeCarrier ascending:YES];
    //self.modalPresentationStyle = UIModalPresentationFormSheet;
    AutoCompleteController* pickViewController = [[AutoCompleteController alloc] init];
    pickViewController.autoCompleteDelegate = helper;
    pickViewController.autoCompleteTitle = @"Please select a carrier";
    [self presentViewController:pickViewController animated:YES completion:nil];

    
}


#pragma UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    return;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{


    if(textField==self.lblToCompanyID||textField==self.lblToWarehouseID)
    {
        [self selectDestinationID:textField];
         
    }else
    {
        if(textField==self.lblCarrierID)
        {
            self.shippingHeader.carrier_id = [SDUserPreference trim:self.lblCarrierID.text];
            [self.txtCarrierRefNo becomeFirstResponder];

        }
        
       
        if(textField==self.txtCarrierRefNo)
        {
            self.shippingHeader.carrier_refno = [SDUserPreference trim:self.txtCarrierRefNo.text];
            [self.txtNoOfPackages becomeFirstResponder];

        }
        
        if(textField==self.txtNoOfPackages)
        {
            if(![self setNoOfPackages:NO])
               return NO;
            [self.txtWeight becomeFirstResponder];

        }
        
        if(textField==self.txtWeight)
        {
            if(![self setWeight:NO])
                return NO;
            [self hideKeyBoard];
        }
        
    }

    
    return YES;
}



-(BOOL)validateInput:(ShippingHeader*)datasource
{
    NSString* toCompanyID = datasource.to_company_id;
    NSString* toWarehouseID = datasource.to_warehouse_id;

    if((toCompanyID==nil||[toCompanyID isEqualToString:_empty])&&(toWarehouseID==nil||[toWarehouseID isEqualToString:_empty]))
    {
        [SDDataEngine alert:kMessageSHippingNoDestinationValue title:nil template:nil delegate:self];
        return NO;
    }
    
    
    
    if([datasource.shippingLineItems count]<=0)
    {
        [SDDataEngine alert:kMessageShippingNoLineItem title:@"Failed" template:nil delegate:nil];        
        return NO;
    }
    
    if (![datasource.transaction_type isEqualToString:kShippingTypePick]){
        if(![self setNoOfPackages:NO])
            return NO;
        
        if(![self setWeight:NO])
            return NO;
        
        if(datasource.carrier_id==nil||[datasource.carrier_id isEqualToString:@""])
        {
            [SDDataEngine alert:kMessageShippingCarrierIDRequired title:@"Failed" template:nil delegate:nil];
            return NO;
        }
        
        if(datasource.carrier_refno==nil||[datasource.carrier_refno isEqualToString:@""])
        {
            [SDDataEngine alert:kMessageShippingCarrierRefNoRequired title:@"Failed" template:nil delegate:nil];
            return NO;
        }
        
        if(datasource.ship_instructions==nil||[datasource.ship_instructions isEqualToString:@""])
        {
            [SDDataEngine alert:kMessageShippingInstructionsRequired title:@"Failed" template:nil delegate:nil];
            return NO;
        }

    }
    
       
    return YES;
}

-(void)fetch:(ShippingHeader*)datasource
{
     if(nil!=datasource)
     {
        datasource.to_company_id = [SDUserPreference trim:self.lblToCompanyID.text];
        datasource.to_warehouse_id = [SDUserPreference trim:self.lblToWarehouseID.text];
         if (![datasource.transaction_type isEqualToString:kShippingTypePick])
         {
             datasource.carrier_id = [SDUserPreference trim:self.lblCarrierID.text];
             datasource.carrier_refno = [SDUserPreference trim:self.txtCarrierRefNo.text];
             datasource.ship_instructions = [SDUserPreference trim:self.txtShippingInstruction.text];
             [self setNoOfPackages:YES];
             [self setWeight:YES];
         }
         [[SDDataEngine sharedEngine]save:datasource];
     }
}


-(void)bind:(ShippingHeader*)datasource
{
 
    self.lblFromWarehouseID.text = [[SDUserPreference sharedUserPreference]DefaultWarehouseID];
    
    if(nil!=datasource)
    {
        if([datasource.process_status isEqualToString:kProcessStatusCOMPLETED])
        {
            self.btnSubmit.hidden = YES;
            [self.view setUserInteractionEnabled:NO];
            [self.selectedTableView setUserInteractionEnabled:NO];
        }
        //populate the gui
        [self bindGUIDestination:self.shippingHeader.doc_type_id toCompanyID:self.shippingHeader.to_company_id toWarehouseID:self.shippingHeader.to_warehouse_id];
        
        if([self.shippingHeader.shippingLineItems count]>0)
            [self setDestinationEnable:NO];
        else
            [self setDestinationEnable:YES];
        
        if (![datasource.transaction_type isEqualToString:kShippingTypePick])
        {
            self.lblCarrierID.text = datasource.carrier_id;
            self.txtCarrierRefNo.text = datasource.carrier_refno;
            self.txtNoOfPackages.text = datasource.no_of_packages;
            self.txtWeight.text = datasource.weight;
            self.txtShippingInstruction.text = datasource.ship_instructions;
        }
        self.lblProcessStatus.text = datasource.process_status;
        self.lblProcessMessage.text = datasource.process_message;
        
        //no need to bind line item
        [self fetchAvailableShippingList];
        [self.selectedTableView reloadData];
    }
    
}

-(void)setDestinationEnable:(BOOL)isEnable
{
    self.btnToCompany.enabled = isEnable;
    self.btnToWarehouse.enabled = isEnable;
}

-(void) bindGUIDestination:(NSString*)docTypeID toCompanyID:(NSString*)toCompanyID toWarehouseID:(NSString*)toWarehouseID
{
    
    if ([docTypeID isEqualToString:kShippingDocTypeID10]) {
        self.lblToCompanyID.text = toCompanyID;
        self.lblToWarehouseID.text = @"";
    }
    else
    {
        self.lblToCompanyID.text = @"";
        self.lblToWarehouseID.text = toWarehouseID;
    }
    
    
    [self setDestinationEnable:NO];
    [self fetchAvailableShippingList];
}


-(void)setDestinationID:(ShippingHeader*)datasource
{
    if (nil!=datasource&&[datasource.shippingLineItems count]>0) {
        ShippingLineItem* lineitem = [datasource.shippingLineItems objectAtIndex:0];
        datasource.doc_type_id = lineitem.doc_type_id;
        datasource.to_warehouse_id = lineitem.to_warehouse_id;
        datasource.to_company_id = lineitem.to_company_id;
    }
}

-(void)selectDestinationID:(UITextField *)textField
{
    NSString* toCompanyID = [SDUserPreference trim:self.lblToCompanyID.text];
    NSString* toWarehouseID = [SDUserPreference trim:self.lblToWarehouseID.text];
    if(textField==self.lblToCompanyID)
    {
        if(![toWarehouseID isEqualToString:_empty])
        {
            self.lblToWarehouseID.text = _empty;
            
        }
        
    }
    else
    {
        if(![toCompanyID isEqualToString:_empty])
        {
            self.lblToCompanyID.text =_empty;
        }
    }
   
    
    [self fetchAvailableShippingList];

}



//yes - validated
-(BOOL)setNoOfPackages:(BOOL)isSuppressAlert
{
    NSString* noOfPackages = [SDUserPreference trim:self.txtNoOfPackages.text];
    
    int num = [noOfPackages intValue];
    if(num<=0)
    {
        if (!isSuppressAlert) {
            [SDDataEngine alert:kMessageNoOfPackages title:nil template:nil delegate:self];
        }
        
        return NO;
    }
    
    self.shippingHeader.no_of_packages = noOfPackages;
    [self.txtWeight becomeFirstResponder];
    return YES;
}

//yes - validated
-(BOOL)setWeight:(BOOL)isSuppressAlert
{
    NSString* weight = [SDUserPreference trim:self.txtWeight.text];
    
    float f = [weight floatValue];
    if(f<=0)
    {
        if(!isSuppressAlert)
            [SDDataEngine alert:kMessageWeight title:nil template:nil delegate:self];
        return NO;
    }
    self.shippingHeader.weight = weight;
    [self hideKeyBoard];
    return YES;
}

-(void)hideKeyBoard
{
    [self.txtCarrierRefNo resignFirstResponder];
    [self.txtNoOfPackages resignFirstResponder];
    [self.txtWeight resignFirstResponder];
    [self.txtShippingInstruction resignFirstResponder];
}

@end
