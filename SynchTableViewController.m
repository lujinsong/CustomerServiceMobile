//
//  SynchTableViewController.m
//  CustomerServiceMobile
//


#import "SynchTableViewController.h"
#import "SDUserPreference.h"
#import "SharedConstants.h"
#import "WarehouseSynchController.h"
#import "CompanySynchController.h"
#import "CarrierSynchController.h"
#import "BinPartSynchController.h"
#import "QueriesSynchController.h"
#import "ManAdjustReason.h"
#import "Queries.h"
#import "SDRestKitEngine.h"

@interface SynchTableViewController ()

@end
BOOL _synchInProgressWarehouse;
BOOL _synchInProgressCompany;
BOOL _synchInProgressCarrier;
BOOL _synchInProgressBinPart;
BOOL _synchInProgressQueries;
BOOL _synchInProgressReason;
BOOL _synchInProgressReports;
BOOL _synchInProgressShipmentInstructions;

@implementation SynchTableViewController
@synthesize lblLastUpdated_SynchBin,lblLastUpdated_SynchCarrier,lblLastUpdated_SynchCompany,
lblLastUpdated_SynchWarehosue,lblLastUpdated_SynchReason, lblLastUpdated_SynchReports ,lblStatus_SynchBin,lblStatus_SynchCarrier,lblStatus_SynchCompany,lblStatus_SynchWarehouse,lblStatus_SynchReason, lblStatus_SynchReports,lblLastUpdated_SynchShipmentInstructions,lblStatus_SynchShipmentInstructions;
@synthesize dateFormatter;
@synthesize activity_SynchBin,activity_SynchCarrier,activity_SynchCompany,activity_SynchWarehouse,activity_SynchReason, activity_SynchReports,activity_SynchShipmentInstructions;
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

    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:kSynchDateTemplate options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    self.dateFormatter = formatter;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [self setDataFromUserDefault:formatter];

    
    
}

- (void) setDataFromUserDefault:(NSDateFormatter*) formatter
{
    //last updated
    lblLastUpdated_SynchBin.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchBin]] ;
    lblLastUpdated_SynchCompany.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchCompany]] ;
    lblLastUpdated_SynchCarrier.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchCarrier]] ;
    lblLastUpdated_SynchWarehosue.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchWarehouse]] ;
    lblLastUpdated_SynchReason.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchReason]] ;
    lblLastUpdated_SynchReports.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchReports]] ;
    lblLastUpdated_SynchShipmentInstructions.text = [formatter stringFromDate:[[SDUserPreference sharedUserPreference] LastSynchShipmentInstructions]] ;
    //last update status
    
}

- (void) resetDataToUserDefault
{
    [SDUserPreference sharedUserPreference].LastSynchBin = [NSDate distantPast];
    [SDUserPreference sharedUserPreference].LastSynchCarrier = [NSDate distantPast];
    [SDUserPreference sharedUserPreference].LastSynchCompany = [NSDate distantPast];
    [SDUserPreference sharedUserPreference].LastSynchWarehouse = [NSDate distantPast];
    [SDUserPreference sharedUserPreference].LastSynchReason = [NSDate distantPast];
    [SDUserPreference sharedUserPreference].LastSynchReports = [NSDate distantPast];
    [SDUserPreference sharedUserPreference].LastSynchShipmentInstructions = [NSDate distantPast];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction) synchAll:(id)sender{

    [self synchCompany:sender];
    [self synchCarrier:sender];
    [self synchWarehouse:sender];
    [self synchReason:sender];
    [self synchReports:sender];
    [self synchShipmentInstructions:sender];
    sleep(1);
    [self synchBin:sender];
    
}

- (IBAction)resetAll:(id)sender {
    [self resetDataToUserDefault];
    [self setDataFromUserDefault:self.dateFormatter];
    
    
}

-(IBAction) synchCompany:(id)sender{
    CompanySynchController* controller = [SDRestKitEngine sharedCompanyController];
    if(!_synchInProgressCompany)
    {
        _synchInProgressCompany = YES;
        [activity_SynchCompany startAnimating];
        [lblStatus_SynchCompany setText:@""];
        //add observer
        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationNameCompany selector:@selector(synchNotifiedCompany:)];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load];
        });
    }
}

-(void) synchNotifiedCompany:(NSNotification *)notification
{
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationNameCompany];
    [lblStatus_SynchCompany setText:info];
    _synchInProgressCompany = NO;
    [activity_SynchCompany stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchCompany = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationNameCompany];
}


-(IBAction) synchCarrier:(id)sender{
    CarrierSynchController* controller = [SDRestKitEngine sharedCarrierController];
    if(!_synchInProgressCarrier)
    {
        _synchInProgressCarrier = YES;
        [activity_SynchCarrier startAnimating];
         [lblStatus_SynchCarrier setText:@""];
        //add observer
        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationNameCarrier selector:@selector(synchNotifiedCarrier:)];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load];
        });
    }
}

-(void) synchNotifiedCarrier:(NSNotification *)notification
{
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationNameCarrier];
    [lblStatus_SynchCarrier setText:info];
    _synchInProgressCarrier= NO;
    [activity_SynchCarrier stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchCarrier = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationNameCarrier];
}

-(IBAction) synchWarehouse:(id)sender{
    WarehouseSynchController* controller = [SDRestKitEngine sharedWarehouseController];
    if(!_synchInProgressWarehouse)
    {
        _synchInProgressWarehouse = YES;
        [activity_SynchWarehouse startAnimating];
         [lblStatus_SynchWarehouse setText:@""];
        //add observer
        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationNameWarehouse selector:@selector(synchNotifiedWarehouse:)];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load];
        });
    }}


-(void) synchNotifiedWarehouse:(NSNotification *)notification
{
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationNameWarehouse];
    [lblStatus_SynchWarehouse setText:info];
    _synchInProgressWarehouse= NO;
    [activity_SynchWarehouse stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchWarehouse = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationNameWarehouse];
}

-(IBAction) synchBin:(id)sender{
    BinPartSynchController* controller = [SDRestKitEngine sharedBinPartController];
    if(!_synchInProgressBinPart)
    {
        _synchInProgressBinPart = YES;
         [lblStatus_SynchBin setText:@""];
        [activity_SynchBin startAnimating];
        //add observer
        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationNameBinPart selector:@selector(synchNotifiedBin:)];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load];
        });
    }

}




-(void) synchNotifiedBin:(NSNotification *)notification
{
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationNameBinPart];
    [lblStatus_SynchBin setText:info];
    _synchInProgressBinPart= NO;
    [activity_SynchBin stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchBin = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationNameBinPart];
}



- (IBAction)synchReason:(id)sender {
    ManAdjustReasonController* controller = [SDRestKitEngine sharedReasonController];
    if(!_synchInProgressReason)
    {
        _synchInProgressReason = YES;
        [lblStatus_SynchReason setText:@""];
        [activity_SynchReason startAnimating];
        //add observer
        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationNameManAdjustReason selector:@selector(synchNotifiedReason:)];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load];
        });
    }

}



-(void) synchNotifiedReason:(NSNotification *)notification
{
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationNameManAdjustReason];
    [lblStatus_SynchReason setText:info];
    _synchInProgressReason= NO;
    [activity_SynchReason stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchReason = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationNameManAdjustReason];
}


- (IBAction)synchReports:(id)sender {
    QueriesSynchController* controller = [SDRestKitEngine sharedQueriesController];
    if(!_synchInProgressReports)
    {
        _synchInProgressReports = YES;
        [lblStatus_SynchReports setText:@""];
        [activity_SynchReports startAnimating];
        //add observer
        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationReports selector:@selector(synchNotifiedReports:)];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load];
        });
    }
    
    
}



-(void) synchNotifiedReports:(NSNotification *)notification
{
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationReports];
    [lblStatus_SynchReports setText:info];
    _synchInProgressReports= NO;
    [activity_SynchReports stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchReports = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationReports];
}


- (IBAction)synchShipmentInstructions:(id)sender {
    ShipmentInstructionsSynchController* controller = [SDRestKitEngine sharedShipmentInstructionsController];
    if(!_synchInProgressShipmentInstructions)
    {
        _synchInProgressShipmentInstructions = YES;
        [lblStatus_SynchShipmentInstructions setText:@""];
        [activity_SynchShipmentInstructions startAnimating];
        //add observer
        [[SDRestKitEngine sharedEngine] addNotificationObserver:self notificationName:kNotificationShipmentInstructions selector:@selector(synchNotifiedShipmentInstructions:)];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [controller load];
        });
    }
    
    
}

-(void) synchNotifiedShipmentInstructions:(NSNotification *)notification
{
    NSString* info = [[SDRestKitEngine sharedEngine] getNofiticationInfo:notification actionname:kNotificationReports];
    [lblStatus_SynchShipmentInstructions setText:info];
    _synchInProgressShipmentInstructions= NO;
    [activity_SynchShipmentInstructions stopAnimating];
    [SDUserPreference sharedUserPreference].LastSynchShipmentInstructions = [NSDate date];
    [self setDataFromUserDefault:self.dateFormatter];
    //remove observer
    [[SDRestKitEngine sharedEngine] removeNotificationObserver:self notificationName:kNotificationShipmentInstructions];
}

-(void) threadStartAnimating:(UIActivityIndicatorView*) indicator
{
    [indicator startAnimating];

}






@end
