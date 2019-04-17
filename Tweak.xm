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

	//get bundle id from preferences
	NSString *bundle = [[[NSMutableDictionary alloc] initWithContentsOfFile: @"/var/mobile/Library/Preferences/com.lpane.browserdefaultpref.plist"] valueForKey:@"picker"];

	NSString *scheme = @"";

	//firefox focus requires url to be encoded
	if([bundle isEqualToString:@"org.mozilla.ios.Focus"]) {
		scheme = @"firefox-focus://open-url?url=";
		strungURL = [strungURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}

	if([bundle isEqualToString:@"org.mozilla.ios.Firefox"]) {
		scheme = @"firefox://open-url?url=";
	}

	//return NSURL object containing the scheme, followed by the strung url
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", scheme, strungURL]];
}

//TODO: Remove dependancy on order in setBundleIdentifier and setOptions
- (void)setBundleIdentifier:(NSString *)arg1 {
	if([arg1 isEqualToString:@"com.apple.mobilesafari"]) {
		arg1 = [[[NSMutableDictionary alloc] initWithContentsOfFile: @"/var/mobile/Library/Preferences/com.lpane.browserdefaultpref.plist"] valueForKey:@"picker"];
	}
	%orig;
}

- (void)setOptions:(FBSOpenApplicationOptions *)arg1 {
	if([[self bundleIdentifier] isEqualToString:@"org.mozilla.ios.Firefox"] || [[self bundleIdentifier] isEqualToString:@"org.mozilla.ios.Focus"]) {
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict addEntriesFromDictionary: [arg1 dictionary]];

		//modify url with scheme
		[dict setObject:[[self class] modifiedURL:[dict objectForKey:@"__PayloadURL"]] forKey:@"__PayloadURL"];

		[arg1 setDictionary:dict];
	}

	%orig;
}

%end
