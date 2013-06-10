// SDUserPreference.m use default value in the plist.

#import "SDUserPreference.h"
#import "SharedConstants.h"
@implementation SDUserPreference
@synthesize user=_user;
@synthesize Version, Printer;
@synthesize keys, preferences;
@synthesize ServiceServer, ServiceAPPName, DefaultWarehouseID, LastLogin,LastLoginAA, IsRememberUserID, BackgroundProcessInterval, MaxRows, ReportServer;
@synthesize LastSynchBin,LastSynchCarrier,LastSynchCompany,LastSynchWarehouse, LastSynchReason, LastSynchReports, LastSynchShipmentInstructions;

@synthesize LastLoginPassword;
@synthesize dateFormatter=_dateFormatter;

+(SDUserPreference*) sharedUserPreference
{
    static SDUserPreference *sharedUserPreference = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserPreference = [[SDUserPreference alloc]
                                initWithKeys:[NSArray arrayWithObjects: kIdServerDomain,
                                                                        kIdVersion,
                                                                        kIdPrinter,
                                                                        kIdAppName,                                                                        kIdDefaultWarehouseId,
                                                                        kIdIsRemember,
                                                                        kIdLastLogin,
                                                                        kIdBackgroundPeriod,
                                                                        kIdMaxRows,
                                                                        kIdReportServer,
                                                                        kIdLastSynchBin,
                                                                        kIdLastSynchCarrier,
                                                                        kIdLastSynchCompany,
                                                                        kIdLastSynchWarehouse,
                                                            kIdLastSynchReports,
                                                        kIdLastSynchShipmentInstructions
                                                                        ,nil]];
        
        //init the date formatter
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"MM/dd/yy HH:mm"];
//        dateFormatter.timeZone=[NSTimeZone timeZoneWithAbbreviation:kTimeZone];
//        dateFormatter.timeZone = [NSTimeZone systemTimeZone];
//        dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:kLocalIdentifier];
//        sharedUserPreference.dateFormatter = dateFormatter;
        
        sharedUserPreference.dateFormatter = [[NSDateFormatter alloc] init];
        [sharedUserPreference.dateFormatter setDateFormat:@"MM/dd/yy HH:mm"];
    });
    
    return sharedUserPreference;
}

+(NSString*)trim:(NSString*)value
{
    if(nil==value)
        return nil;
    else
        return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
+(void)addShadow:(CALayer*) layer
{
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 1.0;
    layer.shadowOffset = CGSizeMake(0,3);
    layer.cornerRadius = 5.0;
   
}

- initWithKeys:(NSArray *) aKeys
{
    [self setKeys:aKeys];
    [self setPreferences:[self registerDefaultWithKeyArray:aKeys]];
    
    return self;
}

////Register default values for any pereferences that it expects to be presented. Only the custom one that is not in the plist
//-(void) registerDefaultsNotInSettingBundle:(NSMutableDictionary *) localDefaults
//                                        Keys:(NSArray*) aKeys
//{
//    NSArray* extraKeys = [NSArray arrayWithObjects:kIdLastSynchBin, kIdLastSynchCarrier,kIdLastSynchCompany, nil];
//    
//    NSArray* extraDefaults = [NSArray arrayWithObjects:[NSDate distantPast],[NSDate distantPast],[NSDate distantPast],[NSDate distantPast],nil];
//    
//    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:kDefaultServerDomain, kDefaultAppName, kDefaultDefaultWarehouseId,kDefaultLastLogin, kDefaultReportServer,[NSDate distantPast],[NSDate distantPast],[NSDate distantPast],[NSDate distantPast],nil] forKeys:[NSArray arrayWithObjects:kIdServerDomain,kIdAppName,kIdDefaultWarehouseId, kIdLastLogin,kIdReportServer, kIdLastSynchBin, kIdLastSynchCarrier,kIdLastSynchCompany, kIdLastSynchWarehouse, nil]];
//    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}


- (NSDictionary *)registerDefaultWithKeyArray:(NSArray *)aKeys {
    NSDictionary *settings = [self bundleSettings];
    NSMutableDictionary *localDefaults = [[NSMutableDictionary alloc] init];
    NSString *prefItem = nil;
    for (prefItem in settings) {
        if([prefItem length]!=0)
        {
        NSDictionary *tempDict = [settings objectForKey:prefItem];
        id defaultValue = nil;
        if([[tempDict objectForKey:@"Type"] isEqualToString:@"PSMultiValueSpecifier"]) {
            NSArray *titles = [tempDict objectForKey:@"Titles"];
            NSNumber *index = [tempDict objectForKey:@"DefaultValue"];
            defaultValue = [titles objectAtIndex:[index intValue]];
        } else {
              defaultValue = [tempDict objectForKey:@"DefaultValue"];
        }
        if(nil!=defaultValue)
            [localDefaults setObject:defaultValue forKey:prefItem];
        }
    }
    [[NSUserDefaults standardUserDefaults] registerDefaults:localDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return localDefaults;
}


- (NSDictionary *)bundleSettings {
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath =
    [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *finalPath =
    [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionary];
    NSDictionary *settingsDict =
    [NSDictionary dictionaryWithContentsOfFile:finalPath];
    NSMutableArray *array =
    [settingsDict objectForKey:@"PreferenceSpecifiers"];
    NSDictionary *tempDict = nil;
    NSDictionary *tempChildDict = nil;
    for(tempDict in array) {
        if([tempDict objectForKey:@"Key"]) {
            NSString *typeValueStr = [tempDict objectForKey:@"Type"];
            if([typeValueStr isEqualToString:@"PSChildPaneSpecifier"]) {
                NSString *keyValueStr = [NSString stringWithFormat:@"%@.plist",
                                         [tempDict objectForKey:@"Key"]];
                NSString *plist =
                [settingsBundlePath stringByAppendingPathComponent:keyValueStr];
                NSDictionary *childSettings =
                [NSDictionary dictionaryWithContentsOfFile:plist];
                NSArray *childArray =
                [childSettings objectForKey:@"PreferenceSpecifiers"];
                if(childArray) {
                    for(tempChildDict in childArray) {
                        [array addObject:tempChildDict];
                        if([tempChildDict objectForKey:@"Key"]) {
                            [plistDict setObject:tempChildDict
                                          forKey:[tempChildDict objectForKey:@"Key"]];
                        }
                    }
                }
            } else {
                [plistDict setObject:tempDict
                              forKey:[tempDict objectForKey:@"Key"]];
            }
        }
    }
    return plistDict;
}
//- (NSString *)valueForKey:(NSString *)key {
//    NSString *keyValue =
//    [[NSUserDefaults standardUserDefaults] stringForKey:key];
//    NSDictionary *tempDict = [[self preferences] objectForKey:key];
//    if([[tempDict objectForKey:@"Type"]
//        isEqualToString:@"PSMultiValueSpecifier"]) {
//        NSArray *a = [tempDict objectForKey:@"Titles"];
//        int index = [keyValue intValue];
//        keyValue = [a objectAtIndex:index];
//    } else if(keyValue == nil) {
//        keyValue = [tempDict objectForKey:@"DefaultValue"];
//    }
//    return keyValue;
//}


-(BOOL) synchronize
{
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)ServiceServer
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kIdServerDomain];
}

-(NSString *)ServiceAPPName
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kIdAppName];
}

-(NSString *)DefaultWarehouseID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kIdDefaultWarehouseId];
}

-(NSString *)LastLogin
{
    NSString* sLastLogin = [[NSUserDefaults standardUserDefaults] stringForKey:kIdLastLogin];
    return sLastLogin;
}

-(void)setLastLogin:(NSString *)lastLogin
{
    [[NSUserDefaults standardUserDefaults] setObject:lastLogin forKey:kIdLastLogin];
    [self synchronize];	
}

-(NSString *)LastLoginAA
{
    NSString* sLastLoginAA = [[NSUserDefaults standardUserDefaults] stringForKey:kIdLastLoginAA];
    return sLastLoginAA;
}

-(void)setLastLoginAA:(NSString *)lastLoginAA
{
    [[NSUserDefaults standardUserDefaults] setObject:lastLoginAA forKey:kIdLastLoginAA];
    [self synchronize];
}

-(BOOL)IsRememberUserID
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kIdIsRemember];
}

-(NSTimeInterval)BackgroundProcessInterval
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kIdBackgroundPeriod];
    
}

-(NSString*)Version
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kIdVersion];
}

-(NSString*)Printer
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kIdPrinter];
}

-(NSInteger)MaxRows
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kIdMaxRows];
}

-(NSString *)ReportServer
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kIdReportServer];
}

-(NSDate *)LastSynchBin
{
    
    NSDate* dateLastSynch =  (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:kIdLastSynchBin];
    if(nil==dateLastSynch)
    {
        dateLastSynch = [NSDate distantPast];
        [[NSUserDefaults standardUserDefaults] setObject:dateLastSynch forKey:kIdLastSynchBin];
        [self synchronize];
    }
    
    return dateLastSynch;
}

-(void)setLastSynchBin:(NSDate *)lastSynchBin
{
    [[NSUserDefaults standardUserDefaults] setObject:lastSynchBin forKey:kIdLastSynchBin];
    [self synchronize];
}


-(NSDate *)LastSynchCompany
{
    NSDate* dateLastSynch =  (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:kIdLastSynchCompany];
    if(nil==dateLastSynch)
    {
        dateLastSynch = [NSDate distantPast];
        [[NSUserDefaults standardUserDefaults] setObject:dateLastSynch forKey:kIdLastSynchCompany];
        [self synchronize];
    }
    
    return dateLastSynch;
}


-(void)setLastSynchCompany:(NSDate *)lastSynchCompany
{
    [[NSUserDefaults standardUserDefaults]  setObject:lastSynchCompany forKey:kIdLastSynchCompany];
    [self synchronize];
}

-(NSDate *)LastSynchWarehouse
{
    NSDate* dateLastSynch =  (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:kIdLastSynchWarehouse];
    if(nil==dateLastSynch)
    {
        dateLastSynch = [NSDate distantPast];
        [[NSUserDefaults standardUserDefaults] setObject:dateLastSynch forKey:kIdLastSynchWarehouse];
        [self synchronize];
    }
    
    return dateLastSynch;}

-(void)setLastSynchWarehouse:(NSDate *)lastSynchWarehouse
{
    [[NSUserDefaults standardUserDefaults] setObject:lastSynchWarehouse forKey:kIdLastSynchWarehouse];
    [self synchronize];
}

-(NSDate *)LastSynchCarrier
{
    NSDate* dateLastSynch =  (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:kIdLastSynchCarrier];
    if(nil==dateLastSynch)
    {
        dateLastSynch = [NSDate distantPast];
        [[NSUserDefaults standardUserDefaults] setObject:dateLastSynch forKey:kIdLastSynchCarrier];
        [self synchronize];
    }
    
    return dateLastSynch;
}

-(void)setLastSynchCarrier:(NSDate *)lastSynchCarrier
{
    [[NSUserDefaults standardUserDefaults] setObject:lastSynchCarrier forKey:kIdLastSynchCarrier];
    [self synchronize];
}


-(NSDate *)LastSynchReason
{
    NSDate* dateLastSynch =  (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:kIdLastSynchReason];
    if(nil==dateLastSynch)
    {
        dateLastSynch = [NSDate distantPast];
        [[NSUserDefaults standardUserDefaults] setObject:dateLastSynch forKey:kIdLastSynchReason];
        [self synchronize];
    }
    
    return dateLastSynch;}

-(void)setLastSynchReason:(NSDate *)lastSynchReason
{
    [[NSUserDefaults standardUserDefaults] setObject:lastSynchReason forKey:kIdLastSynchReason];
    [self synchronize];
}

-(NSDate *)LastSynchReports
{
    NSDate* dateLastSynch =  (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:kIdLastSynchReports];
    if(nil==dateLastSynch)
    {
        dateLastSynch = [NSDate distantPast];
        [[NSUserDefaults standardUserDefaults] setObject:dateLastSynch forKey:kIdLastSynchReports];
        [self synchronize];
    }
    
    return dateLastSynch;
}

-(void)setLastSynchReports:(NSDate *)lastSynchReports
{
    [[NSUserDefaults standardUserDefaults] setObject:lastSynchReports forKey:kIdLastSynchReports];
    [self synchronize];
}


-(NSDate *)LastSynchShipmentInstructions
{
    NSDate* dateLastSynch =  (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:kIdLastSynchShipmentInstructions];
    if(nil==dateLastSynch)
    {
        dateLastSynch = [NSDate distantPast];
        [[NSUserDefaults standardUserDefaults] setObject:dateLastSynch forKey:kIdLastSynchShipmentInstructions];
        [self synchronize];
    }
    
    return dateLastSynch;
}


-(void)setLastSynchShipmentInstructions:(NSDate *)lastSynchShipmentInstructions
{
    [[NSUserDefaults standardUserDefaults]  setObject:lastSynchShipmentInstructions forKey:kIdLastSynchShipmentInstructions];
    [self synchronize];
}

-(void) log
{
    
    NSLog(@"%@ : %@", kIdServerDomain, self.ServiceServer);
    NSLog(@"%@ : %@", kIdAppName, self.ServiceAPPName);
    NSLog(@"%@ : %c", kIdIsRemember, self.IsRememberUserID);
    NSLog(@"%@ : %@", kIdLastLogin, self.LastLogin);
    NSLog(@"%@ : %f", kIdBackgroundPeriod, self.BackgroundProcessInterval);
    NSLog(@"%@ : %d", kIdMaxRows, self.MaxRows);
    NSLog(@"%@ : %@", kIdReportServer, self.ReportServer);
    NSLog(@"%@ : %@", kIdLastSynchBin, self.LastSynchBin);
    NSLog(@"%@ : %@", kIdLastSynchCarrier, self.LastSynchCarrier);
    NSLog(@"%@ : %@", kIdLastSynchCompany, self.LastSynchCompany);
    NSLog(@"%@ : %@", kIdLastSynchWarehouse, self.LastSynchWarehouse);
    NSLog(@"%@ : %@", kIdVersion, self.Version);
    NSLog(@"%@ : %@", kIdPrinter, self.Printer);
    
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
