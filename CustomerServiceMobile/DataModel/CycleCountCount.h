//
//  CycleCountCount.h
//  CustomerServiceMobile
//
//  Created by LTXC on 2/12/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CycleCountMaster;

@interface CycleCountCount : NSManagedObject

@property (nonatomic, retain) NSString * qty;
@property (nonatomic, retain) NSString * target;
@property (nonatomic, retain) CycleCountMaster *master;

@end
