//#import "HideDotsPrefs/adRootListController.h"
#import <UIKit/UIKit.h>

static BOOL isEnabled;

@interface _SBTopAffordanceView : UIView

@end

%hook _SBTopAffordanceView

-(void)didMoveToWindow {
    %orig;

      NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/jb/var/mobile/Library/Preferences/com.admin233.hidedotsprefs.plist"];
      isEnabled = [[prefs objectForKey:@"isEnabled"] boolValue];

    if (isEnabled) {
        self.hidden = YES;
    }

}

%end
