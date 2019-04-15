@interface FBSOpenApplicationOptions : NSObject
@property (nonatomic,copy) NSDictionary * dictionary;
@end

@interface FBSystemServiceOpenApplicationRequest : NSObject
@property (nonatomic,copy) NSString * bundleIdentifier;
@end

@interface FBSystemServiceOpenApplicationRequest(LLAdditions)
+ (NSURL *)modifiedURL:(NSURL *)url;
@end

%hook FBSystemServiceOpenApplicationRequest

%new
+ (NSURL *)modifiedURL:(NSURL *)url {
	NSString *strungURL = [url absoluteString];
	NSRange httpLocation = [strungURL rangeOfString: @"http"];

	//get bundle id from preferences
	NSMutableDictionary* preferences = [[NSMutableDictionary alloc] initWithContentsOfFile: @"/var/mobile/Library/Preferences/com.lpane.browserdefaultpref.plist"];
	NSString *bundle = [preferences valueForKey:@"picker"];

	NSString *scheme = @"";

	//test valid url & current app
	if(httpLocation.location == 0 && ![[[NSBundle mainBundle] bundleIdentifier] isEqual:bundle]) {
		//firefox focus requires url to be encoded
		if([bundle isEqualToString:@"org.mozilla.ios.Focus"]) {
			scheme = @"firefox-focus://open-url?url=";
			strungURL = [strungURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		}

		//chrome has different schemes for http and https
		if([bundle isEqualToString:@"com.google.chrome.ios"]) {
			if([strungURL rangeOfString: @"https"].location == 0) {
				scheme = @"googlechrome://";
				strungURL = [strungURL substringFromIndex:8];
			}
			else {
				scheme = @"googlechromes://";
				strungURL = [strungURL substringFromIndex:7];
			}
		}

		if([bundle isEqualToString:@"org.mozilla.ios.Firefox"]) {
			scheme = @"firefox://open-url?url=";
		}
	}
	//returns NSURL object containing the scheme, followed by the strung url
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", scheme, strungURL]];
}

- (void)setBundleIdentifier:(NSString *)arg1 {
	if([arg1 isEqualToString:@"com.apple.mobilesafari"]) {
		arg1 = [[[NSMutableDictionary alloc] initWithContentsOfFile: @"/var/mobile/Library/Preferences/com.lpane.browserdefaultpref.plist"] valueForKey:@"picker"];
	}
	%orig;
}

- (void)setOptions:(FBSOpenApplicationOptions *)arg1 {
	if([self.bundleIdentifier isEqualToString:@"org.mozilla.ios.Focus"] || [self.bundleIdentifier isEqualToString:@"org.mozilla.ios.Firefox"]) {
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict addEntriesFromDictionary: [arg1 dictionary]];
		//modify url with scheme
		[dict setObject:[%c(FBSystemServiceOpenApplicationRequest) modifiedURL:[dict objectForKey:@"__PayloadURL"]] forKey:@"__PayloadURL"];
		[arg1 setDictionary:dict];
	}
	%orig;
}

%end
