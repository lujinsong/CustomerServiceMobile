//
//  DetailViewNavigationController.h
//  CustomerServiceMobile
//
//  Created by LTXC on 10/25/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@interface DetailViewNavigationController : UINavigationController <SubstitutableDetailViewController,UINavigationControllerDelegate>


@property (strong, nonatomic) UIBarButtonItem *menuBarButtonItem;
@end
