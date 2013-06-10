//
//  AutoCompleteDataHelper.h
//  CustomerServiceMobile


#import <Foundation/Foundation.h>
#import "AutoCompleteController.h"
#import "SharedConstants.h"
@interface AutoCompleteDataHelper : NSObject <AutoCompleteDelegate>

@property (strong, nonatomic) NSString* entityName;

-(AutoCompleteDataHelper*)initWithEntityName:(NSString*) entityName withDisplayBlock:(AutoCompleteDisplayBlock)displayBlock  withBlock:(AutoCompleteBlock)block;
-(AutoCompleteDataHelper*)initWithEntityName:(NSString*) entityName withDisplayBlock:(AutoCompleteDisplayBlock)displayBlock withData:(AutoCompleteDataBlock)dataBlock withBlock:(AutoCompleteBlock)block;
@property (weak, nonatomic) NSString* template;
@property (weak, nonatomic) NSString* value;
@property (readonly,nonatomic) NSMutableArray* sortDescriptors;

-(void)addSortDescript:(NSString*)key ascending:(BOOL)ascending;
@end
