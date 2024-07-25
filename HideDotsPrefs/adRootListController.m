#import <Foundation/Foundation.h>
#import "adRootListController.h"
#import  "spawn.h"

@implementation adRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)Respring {
    pid_t pid;
    // const char *args[] = {"killall", "-9", "backboardd", NULL};
    posix_spawn(&pid, "/var/jb/usr/bin/sbreload", NULL, NULL, NULL, NULL); 
}

@end
