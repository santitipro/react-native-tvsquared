#import "Tvsquared.h"

@implementation Tvsquared

RCT_EXPORT_MODULE()

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

RCT_EXPORT_METHOD(trackAction:(NSString *)actionName product:(NSString *)product actionId:(NSString *)actionId renueve:(NSString *)renueve promoCode:(NSString *)promoCode)
{
    _collector.userId = _collector.userId;
    [_collector track:actionName product:product orderid:actionId revenue:renueve promocode:promoCode];
}



@end
