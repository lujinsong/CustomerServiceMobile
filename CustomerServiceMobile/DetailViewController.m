
#import "DetailViewController.h"
#import "SDUserPreference.h"
@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
//    // Update the user interface for the detail item.
//
//    if (self.detailItem) {
//        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self configureView];
    UIColor *backGroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BlueBackground.png"]];
    self.view.backgroundColor = backGroundColor;
    self.lblDefaultWarehouse.text = [SDUserPreference sharedUserPreference].DefaultWarehouseID;
    self.lblUserName.text = [SDUserPreference sharedUserPreference].LastLogin;
    self.lblVersion.text = [SDUserPreference sharedUserPreference].Version;
     [self positionLoginFrame];
    self.lblPrinter.text = [SDUserPreference sharedUserPreference].Printer;
   
}


-(void)viewWillAppear:(BOOL)animated
{
 [self positionLoginFrame];
}

-(void)positionLoginFrame{
    CGFloat width = self.view.bounds.size.width/2;
    CGFloat height = self.view.bounds.size.height/2;
    if(self.interfaceOrientation == UIInterfaceOrientationPortrait||self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        height = self.view.bounds.size.height/2;
    }
    
    self.layoutCell.center = CGPointMake(width,height );
}



-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self positionLoginFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Menu", @"Menu");
    [self.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
