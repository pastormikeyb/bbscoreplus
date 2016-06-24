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
    NSString *dictPath, *opponentName;
    NSArray *filePathsArray;
    NSMutableArray *arrayOfDictionariesMutableArray, *gameDefaultsMutableArray;
    NSNumber *pitch, *continous, *home, *timerstarted;
    NSString *maxPitches;
    NSString *hoursRest;
    NSString *timeLimit;
    CGFloat screenWidth;

}

@end

@implementation RulesSetupViewController

@synthesize opponentTeamName, isOpponentLoaded;
@synthesize btnDone,inputAccView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    gameDefaultsDictionary = [NSDictionary dictionary];
    gameDefaultsMutableArray = [NSMutableArray array];
    isTopOfInning = YES;
    isTrackingPitchCount = YES;

    [self TeamSaveDirectory];
    
    if (filePathsArray == nil) {
        NSLog(@"No .sav teams");
            //hide button
        _LoadOpponentButton.enabled = NO;
    }
    
    if ([self DoesMyOpponentFileExist]) {
        

    if ([self doesFileExist]) {
        [self LoadGameDefaults];
        if (isOpponentLoaded) {
            _opponentNameTextField.text = opponentTeamName;
        }else{
        _opponentNameTextField.text = [gameDefaultsDictionary valueForKey:@"opponentteamname"];;
        }
        isTrackingPitchCount = [[gameDefaultsDictionary valueForKey:@"trackpitchcount"]boolValue];
        
        _maxNumberOfPitchesTextField.text = [gameDefaultsDictionary valueForKey:@"maxnumberofpitches"];
        
        _numberOfHoursRestTextField.text = [gameDefaultsDictionary valueForKey:@"numberofhoursrest"];
        
        isContinousLineup = [[gameDefaultsDictionary valueForKey:@"continouslineup"]boolValue];
        _gameTimeLimitTextField.text = [gameDefaultsDictionary valueForKey:@"gametimelimit"];
        
        isHomeTeam = [[gameDefaultsDictionary valueForKey:@"hometeam"]boolValue];
        
        opponentName = [gameDefaultsDictionary valueForKey:@"opponentteamname"];
        
        timerstarted = [gameDefaultsDictionary valueForKey:@"istimerstarted"];
        
//        gameStartTime = [[gameDefaultsDictionary valueForKey:@"amibatting"]boolValue];


        }
        
        
    }else{
        isTrackingPitchCount = YES;
        isContinousLineup = YES;
        isHomeTeam = YES;
        batting = NO;
        [self removeBoxScore];
        [self removeGameDefaults];
        
        
    }
    
    if (! isTrackingPitchCount) {
        _maxNumberOfPitchesTextField.hidden = YES;
        _trackPitchCountSwitch.on = NO;
    }
    
    if (! isContinousLineup) {
        _continousLineupSwitch.on = NO;
    }
    
    if (! isHomeTeam) {
        _isHomeTeamSwitch.on = NO;
    }

    [self getScreenSize];
    
    [self createInputAccessoryView];
    [_maxNumberOfPitchesTextField setInputAccessoryView:inputAccView];
    [_gameTimeLimitTextField setInputAccessoryView:inputAccView];

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

- (void)getScreenSize {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
}
- (void)saveGameDefaults{
    if ([self doesFileExist]) {
        NSLog(@"fileExist");
        
            //load file
//        [self removeFile];
        
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
    timerstarted = @(isTimerStarted);
    opponentName = _opponentNameTextField.text;
    NSString *junk = @"";
    if (opponentName.length < 1) {
        opponentName = @"NA";
    }
    NSNumber *rest = @([_gameTimeLimitTextField.text intValue]);
    
    gameDefaultsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              pitch,@"trackpitchcount",
                              _maxNumberOfPitchesTextField.text,@"maxnumberofpitches",
                              rest,@"numberofhoursrest",
                              continous,@"continouslineup",
                              _gameTimeLimitTextField.text,@"gametimelimit",
                              home,@"hometeam",
                              opponentName,@"opponentteamname",
                              
                              junk,@"gamestarttime",
                              
                              timerstarted,@"istimerstarted",
                              
                              nil];
    
    [gameDefaultsMutableArray addObject:gameDefaultsDictionary];
    
    NSLog(@"gameSettingsDictionary: %@",gameDefaultsDictionary);
    
    NSLog(@"array count: %lu",(unsigned long)[gameDefaultsMutableArray count]);
    
}

- (IBAction)onClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    switch (button.tag) {
        case 0:
            
            NSLog(@"Save Game Settings");
            [self addToGameDefaultsDictionary];
            [self saveGameDefaults];            
            
            break;
            
        case 1:
            NSLog(@"Load Opponent");

            
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

- (void)TeamSaveDirectory{
        //Get dir of .sav
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory
                                                     error:nil];
        //--- Listing file by name sort
    NSLog(@"\n File list %@",fileList);
    
        //---- Sorting files by extension
    filePathsArray =
    [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory
                                                        error:nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF EndsWith '.sav'"];
    filePathsArray =  [filePathsArray filteredArrayUsingPredicate:predicate];
    NSLog(@"\n\n Sorted files by extension %@",filePathsArray);
    
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
    NSNumber *myhit = [NSNumber numberWithInt:0];
    NSNumber *opphit = [NSNumber numberWithInt:0];
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
//                              pc,@"mypitchcount",
//                              pc,@"opponentpitchcount",
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

- (void)removeGameDefaults {
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


- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Rules"
                                                    message:@"Saved"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (BOOL)DoesMyOpponentFileExist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"opponentteamdictionary.out"];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        NSLog(@"File Exist");
        return YES;
    }
    NSLog(@"File Does not Exist");
    return NO;
    
}

-(void)createInputAccessoryView{
    // Extra view for the done button to dismiss the keyboard
    
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, screenWidth, 25)];
    
    [inputAccView setBackgroundColor:[UIColor darkGrayColor]];
    
    [inputAccView setAlpha: 0.6];
    
    
    btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(screenWidth-80, 0.0f, 80.0f, 25)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setBackgroundColor:[UIColor darkTextColor]];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDone setAlpha:0.7];
    [btnDone addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    // Now that our buttons are ready we just have to add them to our view.
    [inputAccView addSubview:btnDone];
}

- (IBAction)dismiss:(id)sender
{
    // dismiss the KB
    
    NSLog(@"dismiss KB");
    [self.view endEditing:YES];
    
}

@end
