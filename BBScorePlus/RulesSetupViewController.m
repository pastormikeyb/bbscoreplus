    //
    //  RulesSetupViewController.m
    //  BBScorePlus
    //
    //  Created by Michael on 10/20/15.
    //  Copyright © 2015 Michael Usry. All rights reserved.
    //

#import "RulesSetupViewController.h"

@interface RulesSetupViewController ()
{
    NSDictionary *gameDefaultsDictionary, *boxScoreDictionary;
    NSString *dictPath;
    NSMutableArray *arrayOfDictionariesMutableArray, *gameDefaultsMutableArray;
    NSNumber *pitch, *continous, *home;
    NSString *maxPitches;
    NSString *hoursRest;
    NSString *timeLimit;
}

@end

@implementation RulesSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    gameDefaultsDictionary = [NSDictionary dictionary];
    gameDefaultsMutableArray = [NSMutableArray array];
    isTopOfInning = YES;
    
    
    if ([self doesFileExist]) {
        [self LoadGameDefaults];
        isTrackingPitchCount = [gameDefaultsDictionary valueForKey:@"trackpitchcount"];
        _maxNumberOfPitchesTextField.text = [gameDefaultsDictionary valueForKey:@"maxnumberofpitches"];
        _numberOfHoursRestTextField.text = [gameDefaultsDictionary valueForKey:@"numberofhoursrest"];
        isContinousLineup = [gameDefaultsDictionary valueForKey:@"continouslineup"];
        _gameTimeLimitTextField.text = [gameDefaultsDictionary valueForKey:@"gametimelimit"];
        isHomeTeam = [gameDefaultsDictionary valueForKey:@"hometeam"];
        batting = [[gameDefaultsDictionary valueForKey:@"amibatting"]boolValue];
        
        if (! isTrackingPitchCount) {
            _maxNumberOfPitchesTextField.hidden = YES;
        }
        
    }else{
        isTrackingPitchCount = YES;
        isContinousLineup = YES;
        isHomeTeam = YES;
        batting = NO;
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)saveGameDefaults{
    if ([self doesFileExist]) {
        NSLog(@"fileExist");
        
            //load file
        [self removeFile];
        
    }
        // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
        // Path to save dictionary
    dictPath = [[paths objectAtIndex:0]
                stringByAppendingPathComponent:@"gamedefaults.out"];
    
    NSLog(@"gameDefaults: %@", gameDefaultsDictionary);
        //        NSLog(@"\nteamInfo: %@", teamDictionary);
    
    
    if ([paths count] > 0)
    {
        
            // Write dictionary array
        [gameDefaultsDictionary writeToFile:dictPath atomically:YES];
    }
    
    if (![self DoesBoxScoreExist]) {
        [self addToBoxScoreDictionary];//add and save boxscore.out
    }
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Rules setup"
                          message:@"File saved."
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
}

- (BOOL)doesFileExist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"gamedefaults.out"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        NSLog(@"File Exist");
        return YES;
    }
    return NO;
}

- (void)addToGameDefaultsDictionary {
    pitch = @(isTrackingPitchCount);
    continous = @(isContinousLineup);
    home = @(isHomeTeam);
    
    gameDefaultsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              pitch,@"trackpitchcount",
                              _maxNumberOfPitchesTextField.text,@"maxnumberofpitches",
                              _numberOfHoursRestTextField.text,@"numberofhoursrest",
                              continous,@"continouslineup",
                              _gameTimeLimitTextField.text,@"gametimelimit",
                              home,@"hometeam",
                              nil];
    
    [arrayOfDictionariesMutableArray addObject:gameDefaultsDictionary];
    
    NSLog(@"gameSettingsDictionary: %@",gameDefaultsDictionary);
    
    NSLog(@"arrayOfDictionariesMutableArray: %@",arrayOfDictionariesMutableArray);
    NSLog(@"array count: %lu",(unsigned long)[arrayOfDictionariesMutableArray count]);
    
}

- (IBAction)onClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    switch (button.tag) {
        case 0:
            
            NSLog(@"Save Game Settings");
            [self addToGameDefaultsDictionary];
            [self saveGameDefaults];
            
            
            break;
    }
}

- (IBAction)onSwitch:(id)sender {
    if (_trackPitchCountSwitch.on) {
        isTrackingPitchCount = YES;
        NSLog(@"pitch yes");
        _maxNumberOfPitchesTextField.hidden = NO;
    }else{
        isTrackingPitchCount = NO;
        NSLog(@"pitch no");
        _maxNumberOfPitchesTextField.hidden = YES;
    }
    
    if (_continousLineupSwitch.on) {
        isContinousLineup = YES;
        NSLog(@"continous yes");
        
    }else{
        isContinousLineup = NO;
        NSLog(@"continous no");
        
    }
    
    if (!_isHomeTeamSwitch.on) {
        isHomeTeam = NO;
        batting = YES;
        NSLog(@"home NO");
        
    }else{
        isHomeTeam = YES;
        batting = NO;
        NSLog(@"home no");
        
    }
    
}

- (void)LoadGameDefaults{
    NSLog(@"LoadGameDefaultsFromFile");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"gamedefaults.out"];
    
    gameDefaultsDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
}

- (void)removeFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"gamedefaults.out"];
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

    //default file
- (void)addToBoxScoreDictionary {
    
    NSNumber *battPos = [NSNumber numberWithInt:0];
    NSNumber *homeTeam = @(isHomeTeam);
    NSNumber *amibatting = @(batting);
    NSNumber *top = @(isTopOfInning);
    NSNumber *pc = [NSNumber numberWithInt:0];
    NSNumber *homerun = [NSNumber numberWithInt:0];
    NSNumber *homehits = [NSNumber numberWithInt:0];
    NSNumber *homeerrors = [NSNumber numberWithInt:0];
    NSNumber *visitorrun = [NSNumber numberWithInt:0];
    NSNumber *visitorhits = [NSNumber numberWithInt:0];
    NSNumber *visitorerrors = [NSNumber numberWithInt:0];
    NSNumber *currentouts = [NSNumber numberWithInt:0];
    NSNumber *myhit = [NSNumber numberWithInt:1];
    NSNumber *opphit = [NSNumber numberWithInt:1];
    NSNumber *inning = [NSNumber numberWithInt:1];
    
    
    if (![self DoesBoxScoreExist]) {
        NSLog(@"DoesBoxScoreExist = NO");
        
        if ([self DoesBoxScoreExist]) {
            [self removeBoxScore];
        }
        
        boxScoreDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              homerun,@"homeruns",
                              homehits,@"homehits",
                              homeerrors,@"homeerrors",
                              visitorrun,@"visitorruns",
                              visitorhits,@"visitorhits",
                              visitorerrors,@"visitorerrors",
                              pc,@"pitchcount",
                              currentouts,@"currentouts",
                              homeTeam,@"ishometeam",
                              amibatting,@"amibatting",
                              battPos,@"currentbattingposition",
                              top,@"istopofinning",
                              myhit,@"myteambattingpositionnumber",
                              opphit,@"opponentbattingpositionnumber",
                              inning,@"currentinning",
                              nil];
        
            // Get path to documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
            // Path to save dictionary
        dictPath = [[paths objectAtIndex:0]
                    stringByAppendingPathComponent:@"boxscore.out"];
        
        if ([paths count] > 0)
        {
            
                // Write dictionary
            [boxScoreDictionary writeToFile:dictPath atomically:YES];
            
        }
    }
    
}

- (BOOL)DoesBoxScoreExist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"boxscore.out"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        NSLog(@"Boxscore File Exist");
        return YES;
    }
    NSLog(@"Boxscore File Does not Exist");
    return NO;
    
}

- (void)removeBoxScore {
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

@end
