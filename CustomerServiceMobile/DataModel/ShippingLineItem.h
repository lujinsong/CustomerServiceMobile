//
//  ShippingLineItem.h
//  CustomerServiceMobile
//
//  Created by LTXC on 2/22/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ShippingHeader;

@interface ShippingLineItem : NSManagedObject

@property (nonatomic, retain) NSString * bpart_id;
@property (nonatomic, retain) NSString * demand_id;
@property (nonatomic, retain) NSString * doc_type_id;
@property (nonatomic, retain) NSDate * due_date;
@property (nonatomic, retain) NSString * fr_inv_type_id;
@property (nonatomic, retain) NSString * ifield1;
@property (nonatomic, retain) NSString * item_id;
@property (nonatomic, retain) NSString * ldmnd_stat_id;
@property (nonatomic, retain) NSString * lineitemnumber;
@property (nonatomic, retain) NSString * orig_doc_id;
@property (nonatomic, retain) NSString * priority;
@property (nonatomic, retain) NSString * serial_no;
@property (nonatomic, retain) NSString * server_id;
@property (nonatomic, retain) NSString * sfield1;
@property (nonatomic, retain) NSString * shipped_qty;
@property (nonatomic, retain) NSString * to_company_id;
@property (nonatomic, retain) NSString * to_warehouse_id;
@property (nonatomic, retain) ShippingHeader *header;

@end
