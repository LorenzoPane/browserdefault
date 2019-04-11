@interface UIApplication(LLAdditions)
+ (NSURL *)modifiedURL:(NSURL *)url;
@end

%hook UIApplication

%new
+ (NSURL *)modifiedURL:(NSURL *)url {
	NSLog(@"called");

	NSString *strungURL = [url absoluteString];
	NSRange httpLocation = [strungURL rangeOfString: @"http"];

	//get bundle id from preferences
	NSMutableDictionary* preferences = [[NSMutableDictionary alloc] initWithContentsOfFile: @"/var/mobile/Library/Preferences/com.lpane.browserdefaultpref.plist"];
	NSString *bundle = [preferences valueForKey:@"picker"];

	NSString *scheme = @"";

	//test valid url & current app
	if(httpLocation.location == 0 && ![[[NSBundle mainBundle] bundleIdentifier] isEqual:bundle]) {
		//firefox focus requires url to be encoded
		if([bundle isEqualToString:@"com.mozilla.io.Focus"]) {
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

		if([bundle isEqualToString:@"org.mozilla.firefox"]) {
			scheme = @"firefox://open-url?url=";
		}
	}
	//returns NSURL object containing the scheme, followed by the strung url
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", scheme, strungURL]];
}

- (BOOL)openURL:(NSURL *)url {
	url = [[self class] modifiedURL:url];
	return %orig;
}

- (void)openURL:(id)arg1 withCompletionHandler:(id)arg2 {
	arg1 = (id)[[self class] modifiedURL:arg1];
	%orig;
}

- (void)openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options completionHandler:(void (^)(BOOL success))completion {
	url = [[self class] modifiedURL:url];
	%orig;
}

- (BOOL)_openURL:(NSURL *)url {
	url = [[self class] modifiedURL:url];
	return %orig;
}

-(void)_openURL:(id)arg1 originatingView:(id)arg2 completionHandler:(/*^block*/id)arg3  {
	arg1 = (id)[[self class] modifiedURL:arg1];
	return %orig;
}

%end
