#import "iOctocatAppDelegate.h"
#import "RootViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>



@interface iOctocatAppDelegate (PrivateMethods)

- (void)displayNoConnectionView;

@end


@implementation iOctocatAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	if (self.isDataSourceAvailable) {
		[window addSubview:[navigationController view]];
    } else {
		[self displayNoConnectionView];
	}
}

- (BOOL)isDataSourceAvailable {
    static BOOL checkNetwork = YES;
    if (checkNetwork) {
        checkNetwork = NO;
		const char *hostName = "github.com";
        Boolean success;
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, hostName);
        SCNetworkReachabilityFlags flags;
        success = SCNetworkReachabilityGetFlags(reachability, &flags);
        isDataSourceAvailable = success && (flags & (kSCNetworkFlagsReachable)) && !(flags & kSCNetworkFlagsConnectionRequired);
        CFRelease(reachability);
    }
    return isDataSourceAvailable;
}

- (void)displayNoConnectionView {
	UIImage *noConnectionImage = [UIImage imageNamed:@"NoConnection.png"];
	UIImageView *noConnectionView = [[UIImageView alloc] initWithImage:noConnectionImage];
	CGRect noConnectionViewFrame = noConnectionView.frame;
	noConnectionViewFrame.origin = CGPointMake(0.0f, [UIApplication sharedApplication].statusBarFrame.size.height);
	noConnectionView.frame = noConnectionViewFrame;
	[window addSubview:noConnectionView];
	[noConnectionView release];
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
