#include "BDPRootListController.h"

@implementation BDPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}
	return _specifiers;
}

- (void)openLink {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LorenzoPane/browserdefault"]
	options:@{}
	completionHandler:nil];
}

@end
