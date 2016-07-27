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
    BOOL showInstructions;
    NSMutableArray *opponentDictionaryArray, *myTeamDictionaryArray;
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
    
    if (![self doesMyTeamFileExist] || ![self doesOpponentTeamExist] || ![self doesGameFileExist]) {
        _StartGameButton.alpha = 0.5;
        _StartGameButton.enabled = NO;
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)doesGameFileExist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"gamevariables.out"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        NSLog(@"File Exist");
        return YES;
    }
    NSLog(@"File Does not Exist");
    return NO;
    
}

- (BOOL)doesMyTeamFileExist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"teamdictionary.out"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        NSLog(@"File Exist");
        
        myTeamDictionaryArray = [NSMutableArray arrayWithContentsOfFile:path];
        
        if (myTeamDictionaryArray.count <1) {
            [self removeMyTeamFile];
            [self removeBoxScore];
            return NO;
        }else{
            
            
            return YES;
        }
    }
    NSLog(@"File Does not Exist");
    return NO;
    
}

- (BOOL)doesOpponentTeamExist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"opponentteamdictionary.out"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        NSLog(@"File Exist");
        
        opponentDictionaryArray = [NSMutableArray arrayWithContentsOfFile:path];
        
        if (opponentDictionaryArray.count <1) {
            [self removeFile];
            [self removeBoxScore];
            return NO;
        }else{

        
        return YES;
        }
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

- (void)removeFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"opponentteamdictionary.out"];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"File removed");
    }
    else
    {
        NSLog(@"Could not remove file");
        NSLog(@"Error: %@",[error description]);
    }
}

- (void)removeMyTeamFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"teamdictionary.out"];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"File removed");
    }
    else
    {
        NSLog(@"Could not remove file");
    }
}

- (void)removeBoxScore
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"boxscore.out"];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"File removed");
    }
    else
    {
        NSLog(@"Could not remove file");
    }
}


- (IBAction)onClick:(id)sender {
}
@end
