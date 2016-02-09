    //
    //  HittingChartViewController.m
    //  BBScorePlus
    //
    //  Created by Michael on 10/15/15.
    //  Copyright © 2015 Michael Usry. All rights reserved.
    //

#import "HittingChartViewController.h"
#import "PitchChartViewController.h"

@interface HittingChartViewController ()
{
    NSDictionary *hittingChartDictionary, *tempdict;
    NSMutableArray *myTeamDictionaryArray, *opponentTeamDictionaryArray;
    NSString *fn, *ln, *pn, *pb, *pt, *pi, *fb, *sb, *tb, *hr, *fc,*fe,*hp,*sf,*rb,*ou,*bt,*st,*wa,*str,*wap,*strp,*strValue, *pc, *hc;
    NSArray *hitLocation,*pitchLocation;
    NSMutableArray *loadedMyHitLocationMutableArray,*loadedOpponentHitLocationMutableArray;
    int loadedMyTeamCurrentBatter, loadedOpponentCurrentBatter;
    
}

@end

@implementation HittingChartViewController
@synthesize currentHitter, currentHitterLabel, pitcherPitchCountDictionary, arrayOfDictionariesMutableArray, homeRunsLabel, homeHitsLabel, homeErrorLabel, visitorRunsLabel,visitorHitsLabel,visitorErrorLabel, isMyTeamBatting, currentInningLabel,didHit,batterPositionNumber,batting,isTopOfInning,isGameStarted,inningNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"START of viewDidLoad");
    NSLog(@"batterposition:\n%d",batterPositionNumber);
    NSLog(@"batting?:\n%d",batting);
    [self LoadBoxScore];
    
    if (batterPositionNumber <0) {
        batterPositionNumber = 0;
    }
    
    [self LoadMyTeam];
    [self LoadOpponentTeam];
    
    [self LoadBoxScore];
    
    
    if (batterPositionNumber < 0) {
        batterPositionNumber = 0;
    }
    if (batting) {
        if (batterPositionNumber >= myTeamDictionaryArray.count) {
            batterPositionNumber = 0;
        }
    }else if (batterPositionNumber >= opponentTeamDictionaryArray.count){
        batterPositionNumber = 0;
        
    }
    NSLog(@"inning %i",inningNumber);
    NSLog(@"istopofinning %i",isTopOfInning);
    NSLog(@"isMyTeamBatting %i",isMyTeamBatting);
    
    if ([self DoesMyTeamFileExist] && [self DoesMyOpponentFileExist] && [self DoesBoxScoreExist]) {
        
//        if (batting) {
//                //HOME
//            NSLog(@"Home batting pos number: %i",batterPositionNumber);
//            int count = (int)[opponentTeamDictionaryArray count];
//            NSLog(@"Home batting count: %i",count);
//            
//            
//            
//        }else{
//                //OPPONENT
//            NSLog(@"opp batting pos number: %i",batterPositionNumber);
//            int count = (int)[opponentTeamDictionaryArray count];
//            NSLog(@"Opp batting count: %i",count);
//            
//            
//            if (batterPositionNumber >=  count){
//                batterPositionNumber = 0;
//            };
//            if (batterPositionNumber < 0){
//                batterPositionNumber = 0;
//            };
//            
//            
//        }
        
            //load team
        NSLog(@"Dictionaries has info");
            //which team
        if (batting) {
            currentHitterLabel.text = [[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:batterPositionNumber];
            NSLog(@"current batter: %@",[[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:batterPositionNumber]);
            
        }else{
            currentHitterLabel.text = [[opponentTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:batterPositionNumber];
            NSLog(@"current batter: %@",[[opponentTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:batterPositionNumber]);
            
        }
        
        if (isGameStarted) {
            [self  getHittingChart];
        }
        
        if (isTopOfInning) {
            _topOfInningLabel.text = @"TOP";
            
        }else {
            _topOfInningLabel.text = @"BOTTOM";
            
        }
        
    }else{
            //NO FILES
        NSLog(@" Main files has something missing");
        homeRunsLabel.text = @"0";
        homeHitsLabel.text = @"0";
        homeErrorLabel.text = @"0";
        visitorRunsLabel.text = @"0";
        visitorHitsLabel.text = @"0";
        visitorErrorLabel.text = @"0";
        currentInningLabel.text = @"1";
        
            //alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File missing."
                                                        message:@"Please (re)save game setup and check rosters."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (didHit) {
        
        UITouch *myTouch = [[touches allObjects] objectAtIndex: 0];
        CGPoint currentPos = [myTouch locationInView: nil];
        NSLog(@"Point in myView: (%f,%f)", currentPos.x, currentPos.y);
        if (currentPos.x >= 220 && currentPos.x <= 505) {
            if (currentPos.y >= 65 && currentPos.y <= 340) {
                
                UIImageView *bbView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baseballGloveSmall"]] ;
                
                [bbView setCenter:CGPointMake(currentPos.x, currentPos.y)];                     [self.view addSubview:bbView];
                
                float xPos = currentPos.x;
                float yPos = currentPos.y;
                NSString *xPos1,*yPos1;
                
                hitLocation = [NSArray arrayWithObjects:
                               
                               xPos1 = [[NSNumber numberWithFloat:xPos] stringValue],
                               yPos1 = [[NSNumber numberWithFloat:yPos] stringValue],
                               
                               nil];
                NSLog(@"hitLocation %@",hitLocation);
                
            }
        }
    }else{
        NSLog(@"didHit = NO");
    }
}

- (void)addToDictionary {
    
    
    
    hittingChartDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              hitLocation,@"hitlocation",
                              nil];
    
    NSLog(@"gameSettingsDictionary: %@",hittingChartDictionary);
    
}


#pragma mark - Navigation

    //- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //
    //    if ([[segue identifier] isEqualToString:@"pitchSegue"]){
    //            //        receivedBatterPositionNumber++;
    //        NSLog(@"hitting chart segue: receivedBatterPositionNumber %i",receivedBatterPositionNumber);
    //        { PitchChartViewController *vc = [segue destinationViewController];
    //                //            vc.receivedBatterPositionNumber = receivedBatterPositionNumber;
    //        }
    //    }
    //
    //
    //}


- (void)LoadBoxScore{
    NSLog(@"LoadBoxScore");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"boxscore.out"];
    
    boxScoreDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
        //load variables
    if (!isGameStarted) {
        
        batting = [[boxScoreDictionary valueForKey:@"amibatting"]boolValue];
        
        isTopOfInning = [[boxScoreDictionary valueForKey:@"istopofinning"]boolValue];
        
    }
    
    currentPitchCount = [[boxScoreDictionary valueForKey:@"pitchcount"]intValue];
    if (!isGameStarted) {
                inningNumber = [[boxScoreDictionary valueForKey:@"currentinning"]intValue];

    }
    
    currentOuts = [[boxScoreDictionary valueForKey:@"currentouts"]intValue];
    
    homeRuns = [[boxScoreDictionary valueForKey:@"homeruns"]intValue];
    
    homeHits = [[boxScoreDictionary valueForKey:@"homehits"]intValue];
    
    homeErrors = [[boxScoreDictionary valueForKey:@"homeerrors"]intValue];
    
    visitorRuns = [[boxScoreDictionary valueForKey:@"visitorruns"]intValue];
    
    visitorHits = [[boxScoreDictionary valueForKey:@"visitorhits"]intValue];
    
    visitorErrors = [[boxScoreDictionary valueForKey:@"visitorerrors"]intValue];
    
    homeRunsLabel.text = [NSString stringWithFormat:@"%i",homeRuns];
    
    homeHitsLabel.text = [NSString stringWithFormat:@"%i",homeHits];
    
    homeErrorLabel.text = [NSString stringWithFormat:@"%i",homeErrors];
    
    visitorRunsLabel.text = [NSString stringWithFormat:@"%i",visitorRuns];
    
    visitorHitsLabel.text = [NSString stringWithFormat:@"%i",visitorHits];
    
    visitorErrorLabel.text = [NSString stringWithFormat:@"%i",visitorErrors];
    
    currentInningLabel.text = [NSString stringWithFormat:@"%i",inningNumber];
    
    if (!isGameStarted) {
        
        
        if (batting) {
            batterPositionNumber = [[boxScoreDictionary valueForKey:@"myteambattingpositionnumber"]intValue];
            if (batterPositionNumber < 0) {
                batterPositionNumber = 0;
            }
            NSLog(@"I am batting.  batterPositionNumber %i",batterPositionNumber);
            
            if (batterPositionNumber < 0) {
                batterPositionNumber = 0;
            }
            NSLog(@"loadedMyHitLocationArray %@",loadedMyHitLocationMutableArray);
        }else{
            batterPositionNumber = [[boxScoreDictionary valueForKey:@"opponentbattingpositionnumber"]intValue];
            NSLog(@"I am NOT batting.  batterPositionNumber %i",batterPositionNumber);
            
        }
    }
    NSLog(@"LoadBoxScore finished");
    
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
    }
}

#pragma mark - File check

- (BOOL)doesFileExist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"currentbatter.out"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        NSLog(@"File Exist");
        return YES;
    }
    NSLog(@"File Does not Exist");
    return NO;
    
}

- (BOOL)DoesMyTeamFileExist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"teamdictionary.out"];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        NSLog(@"File Exist");
        return YES;
    }
    NSLog(@"File Does not Exist");
    return NO;
    
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

#pragma mark - Load files

- (void)LoadMyTeam{
    NSLog(@"LoadMyTeamFromFile");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"teamdictionary.out"];
    
    myTeamDictionaryArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
}

- (void) batterPositionErrorCheck{
    int myTeamCount = (int)[myTeamDictionaryArray count];
    int opponentTeamCount = (int)[opponentTeamDictionaryArray count];

    if (batting) {
        if (batterPositionNumber > myTeamCount || batterPositionNumber < 0) {
            batterPositionNumber = 0;
        }
    }else{
        if (batterPositionNumber > opponentTeamCount || batterPositionNumber < 0) {
            batterPositionNumber = 0;
        }
    }
}


- (void)LoadOpponentTeam{
    NSLog(@"LoadOpponentFromFile");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"opponentteamdictionary.out"];
    
    opponentTeamDictionaryArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    
    
}

- (void)addHittingChart{
    NSLog(@"hitting chart");
    
        //check and load
    
    tempdict = [NSDictionary dictionaryWithObjectsAndKeys:
                fn,@"firstname",
                ln,@"lastname",
                pn,@"playernumber",
                pb,@"playerbat",
                pt,@"playerthrow",
                pi,@"pitcher",
                fb,@"1B",
                sb,@"2B",
                tb,@"3B",
                hr,@"HR",
                fc,@"fielderschoice",
                fe,@"fieldingerror",
                hp,@"hitbypitch",
                sf,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                hitLocation,@"hittingchart",
                pitchLocation,@"pitchingchart",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    
}

- (void)loadOpponentTeamDictionaryArray{
        //load
    fb = [[opponentTeamDictionaryArray valueForKey:@"1B"]objectAtIndex:batterPositionNumber];
    sb = [[opponentTeamDictionaryArray valueForKey:@"2B"]objectAtIndex:batterPositionNumber];
    tb = [[opponentTeamDictionaryArray valueForKey:@"3B"]objectAtIndex:batterPositionNumber];
    hr = [[opponentTeamDictionaryArray valueForKey:@"HR"]objectAtIndex:batterPositionNumber];
    fc = [[opponentTeamDictionaryArray valueForKey:@"fielderschoice"]objectAtIndex:batterPositionNumber];
    fe = [[opponentTeamDictionaryArray valueForKey:@"fieldingerror"]objectAtIndex:batterPositionNumber];
    hp = [[opponentTeamDictionaryArray valueForKey:@"hitbypitch"]objectAtIndex:batterPositionNumber];
    sf = [[opponentTeamDictionaryArray valueForKey:@"sacfly"]objectAtIndex:batterPositionNumber];
    rb = [[opponentTeamDictionaryArray valueForKey:@"RBI"]objectAtIndex:batterPositionNumber];
    ou = [[opponentTeamDictionaryArray valueForKey:@"out"]objectAtIndex:batterPositionNumber];
    bt = [[opponentTeamDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:batterPositionNumber];
    st = [[opponentTeamDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:batterPositionNumber];
    fn = [[opponentTeamDictionaryArray valueForKey:@"firstname"]objectAtIndex:batterPositionNumber];
    ln = [[opponentTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:batterPositionNumber];
    pn = [[opponentTeamDictionaryArray valueForKey:@"playernumber"]objectAtIndex:batterPositionNumber];
    pb = [[opponentTeamDictionaryArray valueForKey:@"playerbat"]objectAtIndex:batterPositionNumber];
    pt = [[opponentTeamDictionaryArray valueForKey:@"playerthrow"]objectAtIndex:batterPositionNumber];
    pi = [[opponentTeamDictionaryArray valueForKey:@"pitcher"]objectAtIndex:batterPositionNumber];
    wap = [[opponentTeamDictionaryArray valueForKey:@"walkspitched"]objectAtIndex:batterPositionNumber];
    strp = [[opponentTeamDictionaryArray valueForKey:@"strikeoutspitched"]objectAtIndex:batterPositionNumber];
    pc = [[opponentTeamDictionaryArray valueForKey:@"pitchingchart"]objectAtIndex:batterPositionNumber];
    hc = [[opponentTeamDictionaryArray valueForKey:@"hittingchart"]objectAtIndex:batterPositionNumber];
    wa = [[opponentTeamDictionaryArray valueForKey:@"walks"]objectAtIndex:batterPositionNumber];
    str = [[opponentTeamDictionaryArray valueForKey:@"strikeouts"]objectAtIndex:batterPositionNumber];

    
    NSLog(@"end of loadOpponentTeamDictionaryArray: %@",opponentTeamDictionaryArray);
    
}

- (void)loadMyTeamDictionaryArray{
    
        //load
    fb = [[opponentTeamDictionaryArray valueForKey:@"1B"]objectAtIndex:batterPositionNumber];
    sb = [[opponentTeamDictionaryArray valueForKey:@"2B"]objectAtIndex:batterPositionNumber];
    tb = [[opponentTeamDictionaryArray valueForKey:@"3B"]objectAtIndex:batterPositionNumber];
    hr = [[opponentTeamDictionaryArray valueForKey:@"HR"]objectAtIndex:batterPositionNumber];
    fc = [[opponentTeamDictionaryArray valueForKey:@"fielderschoice"]objectAtIndex:batterPositionNumber];
    fe = [[opponentTeamDictionaryArray valueForKey:@"fieldingerror"]objectAtIndex:batterPositionNumber];
    hp = [[opponentTeamDictionaryArray valueForKey:@"hitbypitch"]objectAtIndex:batterPositionNumber];
    sf = [[opponentTeamDictionaryArray valueForKey:@"sacfly"]objectAtIndex:batterPositionNumber];
    rb = [[opponentTeamDictionaryArray valueForKey:@"RBI"]objectAtIndex:batterPositionNumber];
    ou = [[opponentTeamDictionaryArray valueForKey:@"out"]objectAtIndex:batterPositionNumber];
    bt = [[opponentTeamDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:batterPositionNumber];
    st = [[opponentTeamDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:batterPositionNumber];
    fn = [[opponentTeamDictionaryArray valueForKey:@"firstname"]objectAtIndex:batterPositionNumber];
    ln = [[opponentTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:batterPositionNumber];
    pn = [[opponentTeamDictionaryArray valueForKey:@"playernumber"]objectAtIndex:batterPositionNumber];
    pb = [[opponentTeamDictionaryArray valueForKey:@"playerbat"]objectAtIndex:batterPositionNumber];
    pt = [[opponentTeamDictionaryArray valueForKey:@"playerthrow"]objectAtIndex:batterPositionNumber];
    pi = [[opponentTeamDictionaryArray valueForKey:@"pitcher"]objectAtIndex:batterPositionNumber];
    wap = [[opponentTeamDictionaryArray valueForKey:@"walkspitched"]objectAtIndex:batterPositionNumber];
    strp = [[opponentTeamDictionaryArray valueForKey:@"strikeoutspitched"]objectAtIndex:batterPositionNumber];
    pc = [[opponentTeamDictionaryArray valueForKey:@"pitchingchart"]objectAtIndex:batterPositionNumber];
    hc = [[opponentTeamDictionaryArray valueForKey:@"hittingchart"]objectAtIndex:batterPositionNumber];
    wa = [[opponentTeamDictionaryArray valueForKey:@"walks"]objectAtIndex:batterPositionNumber];
    str = [[opponentTeamDictionaryArray valueForKey:@"strikeouts"]objectAtIndex:batterPositionNumber];
    
    NSLog(@"end of loadMyTeamDictionaryArray: %@",myTeamDictionaryArray);
    
}

- (IBAction)onClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    switch (button.tag) {
        case 0:
            NSLog(@"Pitch button pressed");
            if (batting) {
                NSLog(@"I'm batting");
                if (hitLocation !=nil) {
                    loadedMyHitLocationMutableArray = [[myTeamDictionaryArray valueForKey:@"hittingchart"]objectAtIndex:batterPositionNumber];
                    NSLog(@"loadedMyHitLocationMutableArray %@",loadedMyHitLocationMutableArray);
                    
                    [loadedMyHitLocationMutableArray addObject:hitLocation ];
                    NSLog(@"loadedMyHitLocationMutableArray %@",loadedMyHitLocationMutableArray);
                    
                }
                
            }else{
                NSLog(@"I'm NOT batting");
                if (hitLocation !=nil) {
                    loadedOpponentHitLocationMutableArray = [[opponentTeamDictionaryArray valueForKey:@"hittingchart"]objectAtIndex:batterPositionNumber];
                    
                    [loadedOpponentHitLocationMutableArray addObject:hitLocation ];
                    
                    [self loadOpponentTeamDictionaryArray];
                    
                    [self setTempDict];
                    
                    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
                    
                    [self saveUpdatedOpponentTeamInfo];
                    
                    
                }
                
            }
            
            [self performSegueWithIdentifier:@"pitchSegue" sender:nil];
            
            break;
            
    }
}

- (void)setTempDict{
    
    tempdict = [NSDictionary dictionaryWithObjectsAndKeys:
                fn,@"firstname",
                ln,@"lastname",
                pn,@"playernumber",
                pb,@"playerbat",
                pt,@"playerthrow",
                pi,@"pitcher",
                fb,@"1B",
                sb,@"2B",
                tb,@"3B",
                hr,@"HR",
                fc,@"fielderschoice",
                fe,@"fieldingerror",
                hp,@"hitbypitch",
                sf,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                loadedOpponentHitLocationMutableArray,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                
                nil];
    
    NSLog(@"tempDict: %@",tempdict);
    
}

-(void)saveUpdatedOpponentTeamInfo{
    
        // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        // Path to save dictionary
    NSString *dictPath = [[paths objectAtIndex:0]
                          stringByAppendingPathComponent:@"opponentteamdictionary.out"];
    
    if ([paths count] > 0)
    {
        
            // Write dictionary
        [opponentTeamDictionaryArray writeToFile:dictPath atomically:YES];
        
    }
    
}

-(void)saveUpdatedMyTeamInfo{
    
        // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        // Path to save dictionary
    NSString *dictPath = [[paths objectAtIndex:0]
                          stringByAppendingPathComponent:@"teamdictionary.out"];
    
    if ([paths count] > 0)
    {
        
            // Write dictionary
        [opponentTeamDictionaryArray writeToFile:dictPath atomically:YES];
        
    }
    
}

- (void)getHittingChart{
    NSLog(@"getHittingChart");
    NSArray *myArray;
    if (batting) {
        if ([[myTeamDictionaryArray valueForKey:@"hittingchart"]objectAtIndex:batterPositionNumber] != nil) {
            myArray = [[myTeamDictionaryArray valueForKey:@"hittingchart"]objectAtIndex:batterPositionNumber];
            
        }
        
    }else{
        if ([[opponentTeamDictionaryArray valueForKey:@"hittingchart"]objectAtIndex:batterPositionNumber] !=nil) {
            myArray = [[opponentTeamDictionaryArray valueForKey:@"hittingchart"]objectAtIndex:batterPositionNumber];
            
        }
    }
    
    if (myArray != nil) {
        for (int i = 0; i <myArray.count; i++) {
            int x = [[myArray[i]objectAtIndex:0]intValue];
            int y = [[myArray[i]objectAtIndex:1]intValue];
            
            NSLog(@"myArray: %@",myArray[i]);
            NSLog(@"x: %i",x);
            NSLog(@"y: %i",y);
                //after getting x,y place on screen;
            UIImage *glove = [UIImage imageNamed:@"baseballGloveSmall"];
            UIImageView *gloveView = [[UIImageView alloc]initWithImage:glove];
            CGRect frame = gloveView.bounds;
            frame.origin.x = x;
            frame.origin.y = y;
            gloveView.frame = frame;
            [self.view addSubview:gloveView];
            
        }
        
    }
    
}
@end
