

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *lblDefaultWarehouse;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblPrinter;
@property (weak, nonatomic) IBOutlet UITableViewCell *layoutCell;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
