#import <Foundation/Foundation.h>

@interface TVSquaredCollector : NSObject

@property NSString *userId;
- (id)initTracker:(NSString *)hostname siteid:(NSString*)siteid;
- (id)initTracker:(NSString *)hostname siteid:(NSString*)siteid secure:(BOOL)secure;
- (void)track;
- (void)track:(NSString*)actionname product:(NSString*)product orderid:(NSString*)orderid revenue:(float)revenue promocode:(NSString*)promocode;

- (void)appendSessionDetails:(NSMutableDictionary*)params;
- (void)appendActionDetails:(NSMutableDictionary*)params actionname:(NSString*)actionname product:(NSString*)product orderid:(NSString*)orderid revenue:(float)revenue promocode:(NSString*)promocode;
- (NSString*)getVisitorId;

- (NSString*)json:(id)obj;
- (NSString*)md5:(NSString*)input;
- (NSString *)urlencode:(NSString*)toEncode;
@end
