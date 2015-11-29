//
//  ViewController.m
//  BBScorePlus
//
//  Created by Michael on 10/11/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSDictionary *gameVariables;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    if (![self doesGameFileExist]) {
        NSLog(@"NOT fileExist");
        
            //load file
        NSNumber *beginning = [NSNumber numberWithInt:1];
        BOOL isTopofInning;
        isTopofInning = YES;
        NSNumber *inn = @(isTopofInning);
        
        
        gameVariables = [NSDictionary dictionaryWithObjectsAndKeys:
                         beginning,@"currentinning",
                         inn,@"topofinning",
                         nil];
        
        
        NSLog(@"gameVariables: %@",gameVariables);
        
        [self saveGameFileDefaults];
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)doesGameFileExist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"currentteamgamepitcher.out"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        NSLog(@"File Exist");
        return YES;
    }
    NSLog(@"File Does not Exist");
    return NO;
    
}

- (void)saveGameFileDefaults{
    NSLog(@"saveGameFileDefaults");
    
        // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
        // Path to save dictionary
    NSString *dictPath = [[paths objectAtIndex:0]
                stringByAppendingPathComponent:@"gamevariables.out"];
    
    if ([paths count] > 0)
    {
        
            // Write dictionary
        [gameVariables writeToFile:dictPath atomically:YES];
        
    }
    
}


@end
