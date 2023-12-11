
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (QLValueNonnull)

- (void)setSafeValue:(nullable id)value forKey:(NSString *)key;

- (NSNumber *)jsonNumberForKey:(NSString *)aKey;
- (NSString *)jsonNSStringForKey:(NSString *)aKey;
- (NSArray *)jsonArrayForKey:(NSString *)aKey;
- (NSDictionary *)jsonDictionaryForKey:(NSString *)aKey;

@end

NS_ASSUME_NONNULL_END
