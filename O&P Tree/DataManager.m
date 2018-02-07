
#import "DataManager.h"

@implementation DataManager


-(id) init{
    if ([super init]) {
        
        self.codesNameArray = [[NSMutableArray alloc] init];
        self.categoryArray = [[NSMutableArray alloc] init];
        self.favoritesArray = [[NSMutableArray alloc] init];
        
        self.bannerArray = [[NSMutableArray alloc] init];
        self.splashArray = [[NSMutableArray alloc] init];
        
        self.addonArray = [[NSMutableArray alloc] init];
        self.cartArray = [[NSMutableArray alloc] init];
        
        self.bannerTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f
                                                            target:self
                                                          selector:@selector(getNewNews:)
                                                          userInfo:nil
                                                           repeats:YES];
        
        self.splashTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f
                                                            target:self
                                                          selector:@selector(getNewNews1:)
                                                          userInfo:nil
                                                           repeats:YES];
        
        return self;
    }
    return nil;
    
}


-(void)getNewNews:(NSTimer *)timer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBannerImage" object:nil];
}

-(void)getNewNews1:(NSTimer *)timer
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSplashImage" object:nil];
}

@end
