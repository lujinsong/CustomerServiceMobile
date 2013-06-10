#import "AutoCompleteDataHelper.h"
#import "MyEntities.h"
#import "SharedConstants.h"
#import "SDDataEngine.h"

@implementation AutoCompleteDataHelper
@synthesize sortDescriptors=_sortDescriptors;
@synthesize template=_template;
@synthesize value=_value;

AutoCompleteBlock _block;
AutoCompleteDisplayBlock _displayBlock;
AutoCompleteDataBlock _dataBlock;
-(AutoCompleteDataHelper*)initWithEntityName:(NSString*) entityName withDisplayBlock:(AutoCompleteDisplayBlock)displayBlock withBlock:(AutoCompleteBlock)block
{
    if(self=[super init])
    {
        self.entityName = entityName;
        _block=block;
        _displayBlock = displayBlock;
        _dataBlock = nil;
    }
    
    return self;
}

-(AutoCompleteDataHelper*)initWithEntityName:(NSString*) entityName withDisplayBlock:(AutoCompleteDisplayBlock)displayBlock withData:(AutoCompleteDataBlock)dataBlock withBlock:(AutoCompleteBlock)block
{
    if(self=[super init])
    {
        self.entityName = entityName;
        _block=block;
        _displayBlock = displayBlock;
        _dataBlock = dataBlock;
    }
    
    return self;
}

//call back method to handle the after selection event.
-(void)selected:(id)value status:(BOOL)status
{
    if(nil!=_block)
    {
        _block(status,value);
    }
}

//display in the table cell,object is the entity object
-(NSString *)display:(id)object
{
    NSString* display;
    if(nil!=_displayBlock)
    {
        display = _displayBlock(object);
    }
    else{
        display = @"n/a";
    }
    return display;    
}


//handle to retrieve data, if datablock is not provided, use the default table retrieve
-(NSArray*) objects{
    NSArray* objects = nil;
    if(nil!=_dataBlock)
    {
        objects = _dataBlock(self.entityName);
        if(objects==nil)
            objects = [[NSArray alloc]init];
    }
    else
        objects = [[SDDataEngine sharedEngine] data:self.entityName predicateTemplate:self.template predicateValue:self.value descriptors:self.sortDescriptors];
    return objects;
}

-(void)addSortDescript:(NSString*)key ascending:(BOOL)ascending
{
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
    if(nil==_sortDescriptors)
    {
        _sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
    }
    else{
        [_sortDescriptors addObject:sortDescriptor];
    }
}
@end
