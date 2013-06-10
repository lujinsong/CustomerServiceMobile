//
//  AutoCompleteController.h
//  CustomerServiceMobile
//
//  Created by LTXC on 12/6/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AutoCompleteDelegate <NSObject>
@required
-(void)selected:(id)value status:(BOOL)status;
-(NSString*) display:(id)object;
-(NSArray*) objects;
@end

@interface AutoCompleteController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) NSString* autoCompleteTitle;
@property (strong, nonatomic) NSString* defaultValue;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) id<AutoCompleteDelegate> autoCompleteDelegate;
- (IBAction)btnCancel:(id)sender;
@end
