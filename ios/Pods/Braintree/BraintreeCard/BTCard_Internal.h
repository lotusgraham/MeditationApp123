#import "BTCard.h"
#import "BTJSON.h"

@interface BTCard ()

- (NSDictionary *)parameters;

- (NSDictionary *)graphQLParameters;

extern NSString * const BTCardGraphQLTokenizationMutation;

extern NSString * const BTCardGraphQLTokenizationWithAuthenticationInsightMutation;

@end
