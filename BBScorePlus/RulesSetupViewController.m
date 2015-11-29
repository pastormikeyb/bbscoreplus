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
    NSDictionary *gameSettingsDictionary;
    NSString *dictPath;
    NSMutableArray *arrayOfDictionariesMutableArray;
    NSNumber *pitch, *continous, *home;
    NSString *maxPitches;
    NSString *hoursRest;
    NSString *timeLimit;
}

@end

@implementation RulesSetupViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    gameSettingsDictionary = [NSDictionary dictionary];
    arrayOfDictionariesMutableArray = [NSMutableArray array];

    if ([self doesFileExist]) {
        [self LoadFromFile];
        isTrackingPitchCount = [arrayOfDictionariesMutableArray valueForKey:@"trackpitchcount"];
        _maxNumberOfPitchesTextField.text = maxPitches;
        _numberOfHoursRestTextField.text = hoursRest;
        isContinousLineup = [arrayOfDictionariesMutableArray valueForKey:@"continouslineup"];
        _gameTimeLimitTextField.text = timeLimit;
        isHomeTeam = [arrayOfDictionariesMutableArray valueForKey:@"hometeam"];


    }else{
    isTrackingPitchCount = YES;
    isContinousLineup = YES;
    isHomeTeam = YES;
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

-(void)saveInfo{
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
        
        NSLog(@"gameSettings: %@", gameSettingsDictionary);
            //        NSLog(@"\nteamInfo: %@", teamDictionary);
        
        
        if ([paths count] > 0)
        {
            
                // Write dictionary array
            [arrayOfDictionariesMutableArray writeToFile:dictPath atomically:YES];
        }
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

- (void)addToDictionary {
    pitch = @(isTrackingPitchCount);
    continous = @(isContinousLineup);
    home = @(isHomeTeam);
    
    
    gameSettingsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                             pitch,@"trackpitchcount",
                            _maxNumberOfPitchesTextField.text,@"maxnumberofpitches",
                            _numberOfHoursRestTextField.text,@"numberofhoursrest",
                            continous,@"continouslineup",
                            _gameTimeLimitTextField.text,@"gametimelimit",
                            home,@"hometeam",
                              nil];
    
    [arrayOfDictionariesMutableArray addObject:gameSettingsDictionary];
    
    NSLog(@"gameSettingsDictionary: %@",gameSettingsDictionary);

    NSLog(@"arrayOfDictionariesMutableArray: %@",arrayOfDictionariesMutableArray);
    NSLog(@"array count: %lu",(unsigned long)[arrayOfDictionariesMutableArray count]);

}

- (IBAction)onClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    switch (button.tag) {
        case 0:
            
            NSLog(@"Save Game Settings");
            [self addToDictionary];
            [self saveInfo];
            
            
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
    
    if (_isHomeTeam.on) {
        isHomeTeam = YES;
        NSLog(@"home yes");
        
    }else{
        isHomeTeam = NO;
        NSLog(@"home no");
        
    }

}

-(void)LoadFromFile{
    NSLog(@"LoadGameDefaultsFromFile");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"gamedefaults.out"];
    NSArray *m, *h, *t;
    
    arrayOfDictionariesMutableArray = [NSMutableArray arrayWithContentsOfFile:filePath];

    m = [arrayOfDictionariesMutableArray valueForKey:@"maxnumberofpitches"];
    h = [arrayOfDictionariesMutableArray valueForKey:@"numberofhoursrest"];
    t = [arrayOfDictionariesMutableArray valueForKey:@"gametimelimit"];
    
    maxPitches = [m objectAtIndex:0];
    hoursRest = [h objectAtIndex:0];
    timeLimit = [t objectAtIndex:0];


    NSLog(@"array: %@",arrayOfDictionariesMutableArray);
    NSLog(@"maxnumberofpitches: %@", maxPitches);
    NSLog(@"array: %@",hoursRest);
    NSLog(@"array: %@",timeLimit);
    NSLog(@"pause");
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

@end
