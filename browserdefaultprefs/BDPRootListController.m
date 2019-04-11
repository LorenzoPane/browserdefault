#include "BDPRootListController.h"

@implementation BDPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)openGoogle {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://google.com"]
	options:@{}
	completionHandler:nil];
}

@end
