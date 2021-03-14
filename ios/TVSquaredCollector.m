#import "TVSquaredCollector.h"
#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>

@implementation TVSquaredCollector {
    NSString *_hostname;
    NSString *_siteid;
    BOOL _secure;
    NSString *_visitorid;
}

@synthesize userId;

- (id)initTracker:(NSString *)hostname siteid:(NSString*)siteid {
    return [self initTracker:hostname siteid:siteid secure:FALSE];
}

- (id)initTracker:(NSString *)hostname siteid:(NSString*)siteid secure:(BOOL)secure {
    self = [super init];
    if (self) {
        _hostname = hostname;
        _siteid = siteid;
        _secure = secure;
        _visitorid = [self getVisitorId];
    }
    return self;
}

- (void)track {
    [self track:nil product:nil orderid:nil revenue:0 promocode:nil];
}

- (void)track:(NSString*)actionname product:(NSString*)product orderid:(NSString*)orderid revenue:(float)revenue promocode:(NSString*)promocode {
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@://%@/piwik/piwik.php", _secure ? @"https" : @"http", _hostname];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_siteid forKey:@"idsite"];
    [params setObject:@"1" forKey:@"rec"];
    [params setObject:[NSString stringWithFormat:@"%d", arc4random()] forKey:@"rand"];
    [params setObject:_visitorid forKey:@"_id"];
    [self appendSessionDetails:params];
    if (actionname != nil)
        [self appendActionDetails:params actionname:actionname product:product orderid:orderid revenue:revenue promocode:promocode];

    BOOL first = TRUE;
    for (NSString* key in params) {
        id value = [params objectForKey:key];
        
        if (first)
            [url appendString:@"?"];
        else
            [url appendString:@"&"];
        first = FALSE;
        
        [url appendFormat:@"%@=%@", [self urlencode:key], [self urlencode:value]];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValue:@"TVSquared iOS Collector Client 1.0" forHTTPHeaderField:@"User-Agent"];
    [NSURLConnection sendAsynchronousRequest:request
                     queue:[NSOperationQueue mainQueue]
                     completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                         if (error) {
                             NSLog(@"Failed to call tracker: %@", error);
                             return;
                         }
                         
                         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                         if ([httpResponse statusCode] != 200)
                             NSLog(@"Failed to call tracker: %@", response);
                     }];
}

-(void)appendSessionDetails:(NSMutableDictionary*)params {
    NSMutableDictionary *v5 = [NSMutableDictionary dictionary];
    [v5 setObject:@"app" forKey:@"medium"];
    [v5 setObject:@"ios" forKey:@"dev"];
    if (userId != nil)
        [v5 setObject:userId forKey:@"user"];
    
    NSMutableArray *custom5 = [NSMutableArray array];
    [custom5 addObject:@"session"];
    [custom5 addObject:[self json:v5]];

    NSMutableDictionary *cvar = [NSMutableDictionary dictionary];
    [cvar setObject:custom5 forKey:@"5"];
    
    [params setObject:[self json:cvar] forKey:@"_cvar"];
}

-(void)appendActionDetails:(NSMutableDictionary*)params actionname:(NSString*)actionname product:(NSString*)product orderid:(NSString*)orderid revenue:(float)revenue promocode:(NSString*)promocode {
    NSMutableDictionary *v5 = [NSMutableDictionary dictionary];
    if (product != nil)
        [v5 setObject:product forKey:@"prod"];
    if (orderid != nil)
        [v5 setObject:orderid forKey:@"id"];
    [v5 setObject:[NSNumber numberWithFloat:revenue] forKey:@"rev"];
    if (promocode != nil)
        [v5 setObject:promocode forKey:@"promo"];

    NSMutableArray *custom5 = [NSMutableArray array];
    [custom5 addObject:actionname];
    [custom5 addObject:[self json:v5]];

    NSMutableDictionary *cvar = [NSMutableDictionary dictionary];
    [cvar setObject:custom5 forKey:@"5"];
    
    [params setObject:[self json:cvar] forKey:@"cvar"];
}

- (NSString*)getVisitorId {
    NSString *prefname = [NSString stringWithFormat:@"visitor%@", _siteid];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *visitorid = [userDefaults stringForKey:prefname];
    if (visitorid == nil) {
        CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
        NSString *UUIDString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, UUID);
        CFRelease(UUID);
        visitorid = [[self md5:UUIDString] substringToIndex:16];
        
        [userDefaults setValue:visitorid forKey:prefname];
        [userDefaults synchronize];
    }
    
    return visitorid;
}

-(NSString*)json:(id)obj {
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString*)md5:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *hexString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hexString appendFormat:@"%02x", result[i]];
    
    return hexString;
}

- (NSString *)urlencode:(NSString*)toEncode {
    return (__bridge_transfer NSString*) CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)toEncode,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 kCFStringEncodingUTF8);
}

@end
