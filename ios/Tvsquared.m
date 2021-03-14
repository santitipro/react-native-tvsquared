#import "Tvsquared.h"
#import "TVSquaredCollector.h"

@implementation Tvsquared {
    TVSquaredCollector *_collector;
}

RCT_EXPORT_MODULE(Tvsquared)

RCT_EXPORT_METHOD(initialize:(NSString *)hostname clientKey:(NSString *)clientKey)
{
    _collector = [[TVSquaredCollector alloc] initTracker:hostname siteid:clientKey];
}

RCT_EXPORT_METHOD(track)
{
    [_collector track];
}

RCT_EXPORT_METHOD(trackUser:(NSString *)userId)
{
    _collector.userId = userId;
    [_collector track];
}

RCT_EXPORT_METHOD(trackAction:(NSString *)actionName product:(NSString *)product actionId:(NSString *)actionId revenue:(float)revenue promoCode:(NSString *)promoCode)
{
    _collector.userId = _collector.userId;
    [_collector track:actionName product:product orderid:actionId revenue:revenue promocode:promoCode];
}



@end
