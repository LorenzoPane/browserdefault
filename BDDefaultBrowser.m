#import "BDDefaultBrowser.h"

@implementation BDDefaultBrowser

+ (instancetype)browserFromPrefs:(NSMutableDictionary *)prefs {
	NSString *bundle = [prefs valueForKey:@"bundle"];
	BDDefaultBrowser *browser = [[self class] alloc];

	//presets
	if([bundle isEqualToString:@"com.apple.mobilesafari"]) return [browser initWithBundle:bundle scheme:@"" percentEscapes:false];
	if([bundle isEqualToString:@"org.mozilla.ios.Firefox"]) return [browser initWithBundle:bundle scheme:@"firefox://open-url?url=https://" percentEscapes:false];
	if([bundle isEqualToString:@"org.mozilla.ios.Focus"]) return [browser initWithBundle:bundle scheme:@"firefox-focus://open-url?url=" percentEscapes:true];
	if([bundle isEqualToString:@"com.google.chrome.ios"]) return [browser initWithBundle:bundle scheme:@"googlechromes://" percentEscapes:false];
	if([bundle isEqualToString:@"com.brave.ios.browser"]) return [browser initWithBundle:bundle scheme:@"brave://open-url?url=https://" percentEscapes:true];
	if([bundle isEqualToString:@"com.cloudmosa.PuffinFree"]) return [browser initWithBundle:bundle scheme:@"" percentEscapes:false];
	if([bundle isEqualToString:@"RAPS.appstore.com.dolphin.browser.iphone"]) return [browser initWithBundle:bundle scheme:@"" percentEscapes:false];
	if([bundle isEqualToString:@"com.lipslabs.cake"]) return [browser initWithBundle:bundle scheme:@"cakebrowser://open-url?url=" percentEscapes:true];
	if([bundle isEqualToString:@"com.opera.OperaTouch"]) return [browser initWithBundle:bundle scheme:@"touch-https://" percentEscapes:true];

	//custom browser
	return [browser initWithBundle:[prefs valueForKey:@"customBundleID"] scheme:[prefs valueForKey:@"customScheme"] percentEscapes:[prefs valueForKey:@"customPercentEscapes"]];
}

- (instancetype)initWithBundle:(NSString *)bundle scheme:(NSString *)scheme percentEscapes:(bool)percentEscapes {
	_bundleID = bundle;
	_scheme = scheme;
	_percentEscapes = percentEscapes;

	return self;
}

- (NSURL *)modifiedURL:(NSURL *)url {
	if([[url scheme] isEqualToString:@"x-web-search"]) {
		NSString *query = [[url absoluteString] substringFromIndex:16];
		url = [NSURL URLWithString:[NSString stringWithFormat:@"google.com/search?q=%@", query]];
	}

	NSString *strungURL = [url absoluteString];

	//strip url of schemes
	while([url scheme] != nil) {
		strungURL = [strungURL substringFromIndex:[[url scheme] length] + 3];
		url = [NSURL URLWithString:strungURL];
	}

	if(_percentEscapes) strungURL = [strungURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", _scheme, strungURL]];
}

@end
