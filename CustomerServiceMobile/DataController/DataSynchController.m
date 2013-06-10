//
//  DataController.m
//  CustomerServiceMobile

#import "DataSynchController.h"
#import "SDUserPreference.h"
#import "SharedConstants.h"

@implementation DataSynchController
@synthesize objectManager=_objectManager;
@synthesize controllerName=_controllerName;
@synthesize status=_status;
@synthesize message=_message;

-(id)init:(NSString*)controllerName
{
    if(self = [super init])
    {
        self.controllerName = controllerName;
        NSString* hostname = [SDUserPreference sharedUserPreference].ServiceServer;
        NSString* appname = [SDUserPreference sharedUserPreference].ServiceAPPName;
        NSString* urlString = [NSString stringWithFormat:kWebServiceURLTemplate,hostname,appname];
        RKURL *rkURL = [RKURL URLWithBaseURLString:urlString];
        self.objectManager = [RKObjectManager objectManagerWithBaseURL:rkURL];
        self.objectManager.serializationMIMEType = RKMIMETypeJSON;
        
    }
    return self;
    
}

-(RKObjectManager *)setAuthentication:(RKRequestAuthenticationType)authType username:(NSString *)username password:(NSString *)password
{
    RKClient* client =self.objectManager.client;
    client.authenticationType = RKRequestAuthenticationTypeHTTPBasic;
    client.username = username;
    client.password = password;
    return self.objectManager;
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    _message = [NSString stringWithFormat:kMessageSynchFailedTemplate, [error localizedDescription]];
    NSLog(@"%@",self.message);
    self.status = [NSNumber numberWithInt:0];
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    _message = [NSString stringWithFormat:@"%@",  [error localizedDescription]];
    NSLog(@"%@",_message);
    _status = [NSNumber numberWithInt:0];
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    
    NSLog(@"Web Service %@ call response code:%d",self.controllerName, [response statusCode]);
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    if(object!=nil)
    {
        _status = [NSNumber numberWithInt:1];
        _message = [NSString stringWithFormat:@"Service %@ call response object :%@",self.controllerName, [object description]];
        
    }
    else
    {
        _status = [NSNumber numberWithInt:0];
        _message = [NSString stringWithFormat:@"Service %@ call return 0 object",self.controllerName];
        
    }
    
    NSLog(@"%@",_message);

}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects{
    if(objects!=nil)
    {
        _status = [NSNumber numberWithInt:1];
        _message = [NSString stringWithFormat:@"Service %@ call response object count:%d",self.controllerName, [objects count]];
        
    }
    else
    {
        _status = [NSNumber numberWithInt:0];
        _message = [NSString stringWithFormat:@"Service %@ call return 0 object",self.controllerName];

    }
    
    NSLog(@"%@",_message);
}

-(void)reset
{
    _status = [NSNumber numberWithInt:0];
    _message = nil;
}
@end
