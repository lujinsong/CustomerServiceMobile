

#import <UIKit/UIKit.h>


@interface QueriesViewController : UITableViewController<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
//@property (strong,nonatomic) NSArray* queries;
@end
