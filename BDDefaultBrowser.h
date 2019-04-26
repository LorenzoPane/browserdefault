@interface BDDefaultBrowser : NSObject

@property (readonly) bool percentEscapes;
@property (readonly) NSString *scheme;
@property (readonly) NSString *bundleID;

+ (instancetype)browserFromPrefs:(NSMutableDictionary *)prefs;
- (instancetype)initWithBundle:(NSString *)bundle scheme:(NSString *)scheme percentEscapes:(bool)percentEscapes;
- (NSURL *)modifiedURL:(NSURL *)url;
@end
