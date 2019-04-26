#import "BDDefaultBrowser.m"

@interface FBSOpenApplicationOptions : NSObject
@property (nonatomic,copy) NSDictionary * dictionary;
@end

@interface FBSystemServiceOpenApplicationRequest : NSObject
@property (nonatomic,copy) NSString * bundleIdentifier;
@end

%hook FBSystemServiceOpenApplicationRequest

- (void)setBundleIdentifier:(NSString *)arg1 {
	if([arg1 isEqualToString:@"com.apple.mobilesafari"])
		arg1 = [[%c(BDDefaultBrowser) browserFromPrefs:[[NSMutableDictionary alloc] initWithContentsOfFile: @"/var/mobile/Library/Preferences/com.lpane.browserdefaultpref.plist"]] bundleID];
	%orig;
}

- (void)setOptions:(FBSOpenApplicationOptions *)arg1 {
	BDDefaultBrowser *defaultBrowser = [%c(BDDefaultBrowser) browserFromPrefs:[[NSMutableDictionary alloc] initWithContentsOfFile: @"/var/mobile/Library/Preferences/com.lpane.browserdefaultpref.plist"]];
	if([[self bundleIdentifier] isEqualToString:@"com.apple.mobilesafari"]|| [[self bundleIdentifier] isEqualToString:[defaultBrowser bundleID]]) {
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict addEntriesFromDictionary: [arg1 dictionary]];
		
		[dict setObject:[defaultBrowser modifiedURL:[dict objectForKey:@"__PayloadURL"]] forKey:@"__PayloadURL"];

		[arg1 setDictionary:dict];
	}
	%orig;
}

%end
