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
//    int receivedBatterPositionNumber;
    NSString *fn, *ln, *pn, *pb, *pt, *pi, *fb, *sb, *tb, *hr, *fc,*fe,*hp,*sf,*rb,*ou,*bt,*st,*wa,*str,*wap,*strp,*strValue;
    NSArray *hitLocation,*pitchlocation;
    int loadedMyTeamCurrentBatter, loadedOpponentCurrentBatter;
    
}

@end

@implementation HittingChartViewController
@synthesize currentHitter, currentHitterLabel, pitcherPitchCountDictionary, arrayOfDictionariesMutableArray, homeRunsLabel, homeHitsLabel, homeErrorLabel, visitorRunsLabel,visitorHitsLabel,visitorErrorLabel, receivedBatterPositionNumber, isMyTeamBatting, currentInningLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadMyTeam];
    [self LoadOpponentTeam];

    NSLog(@"received from Pitching receivedBatterPositionNumber: %i",receivedBatterPositionNumber);
    [self LoadGameVariables];
    
    if ([self DoesBoxScoreExist]) {
        [self LoadBoxScore];
        loadedMyTeamCurrentBatter = [[boxScoreDictionary valueForKey:@"myteambattingpositionnumber"]intValue];
        loadedOpponentCurrentBatter = [[boxScoreDictionary valueForKey:@"opponentbattingpositionnumber"]intValue];


    }else{
            //alert
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File missing."
                                                                                            message:@"Please (re)save game setup."
                                                                                           delegate:self
                                                                                  cancelButtonTitle:@"OK"
                                                                                  otherButtonTitles:nil];
                                            [alert show];

    }
    
    NSLog(@"inning %i",inningNumber);
    NSLog(@"istopofinning %i",isTopOfInning);
    NSLog(@"isMyTeamBatting %i",isMyTeamBatting);
    
        // Do any additional setup after loading the view.
    if ([self DoesMyTeamFileExist] && [self DoesMyOpponentFileExist] && [self DoesBoxScoreExist]) {
        

        
        if (batting) {
                //HOME
            NSLog(@"opp batting pos number: %i",[[boxScoreDictionary valueForKey:@"myteambattingpositionnumber"]intValue]);
            int count = (int)[opponentTeamDictionaryArray count];
            
            if (receivedBatterPositionNumber >=  count-1){
                receivedBatterPositionNumber = 0;            };
            if (receivedBatterPositionNumber < 0){
                receivedBatterPositionNumber = 0;            };
            
        }else{
                //OPPONENT
            NSLog(@"opp batting pos number: %i",[[boxScoreDictionary valueForKey:@"opponentbattingpositionnumber"]intValue]);
            receivedBatterPositionNumber = [[boxScoreDictionary valueForKey:@"opponentbattingpositionnumber"]intValue]-1;
            int count = (int)[opponentTeamDictionaryArray count];
            
            if (receivedBatterPositionNumber >=  count){
                receivedBatterPositionNumber = 0;            };
            if (receivedBatterPositionNumber < 0){
                receivedBatterPositionNumber = 0;            };
   
        }
   
        NSLog(@"receivedBatterPositionNumber: %i",receivedBatterPositionNumber);

            //RECEIVE currentBatterPosition
        
        didHit = NO;
        
            //load team
        NSLog(@"Dictionaries has info");
            //which team
        if (batting) {
            currentHitterLabel.text = [[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:receivedBatterPositionNumber];
            NSLog(@"current batter: %@",[[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:receivedBatterPositionNumber]);

        }else{
            currentHitterLabel.text = [[opponentTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:receivedBatterPositionNumber];
            NSLog(@"current batter: %@",[[opponentTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:receivedBatterPositionNumber]);

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
    
    UITouch *myTouch = [[touches allObjects] objectAtIndex: 0];
    CGPoint currentPos = [myTouch locationInView: nil];
    NSLog(@"Point in myView: (%f,%f)", currentPos.x, currentPos.y);
    if (currentPos.x >= 155 && currentPos.x <= 405) {
        if (currentPos.y >= 10 && currentPos.y <= 290) {
            if (!didHit) {
                
                UIImageView *bbView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baseballGloveSmall"]] ;
                
                [bbView setCenter:CGPointMake(currentPos.x, currentPos.y)]; // x, y
                [self.view addSubview:bbView];
                didHit = YES;
                float xPos = currentPos.x;
                float yPos = currentPos.y;
                
                hitLocation = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:xPos],
                               [NSNumber numberWithFloat:yPos],
                               nil];
                NSLog(@"hitLocation %@",hitLocation);
                    // SAVE THE HIT COORDS & CURRENT BATTER
                
                
            }
        }
    }
    
}

- (void)addToDictionary {
    
    hittingChartDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              hitLocation,@"hitlocation",
                              nil];
    
    NSLog(@"gameSettingsDictionary: %@",hittingChartDictionary);
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"pitchSegue"]){
            //        receivedBatterPositionNumber++;
        NSLog(@"hitting chart segue: receivedBatterPositionNumber %i",receivedBatterPositionNumber);
        { PitchChartViewController *vc = [segue destinationViewController];
//            vc.receivedBatterPositionNumber = receivedBatterPositionNumber;
        }
    }
    
    
}


-(void)LoadBoxScore{
    NSLog(@"LoadBoxScore");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"boxscore.out"];
    
    boxScoreDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
        //load variables
    
    NSNumber *b = [boxScoreDictionary valueForKey:@"amibatting"];
    batting = [b boolValue];
    
    batting = [[boxScoreDictionary valueForKey:@"amibatting"]boolValue];
    NSLog(@"LoadBoxScore finished");
    
    currentPitchCount = [[boxScoreDictionary valueForKey:@"pitchcount"]intValue];
    
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
    
}


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
    lastname = [[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:receivedBatterPositionNumber];
    
}

- (void)LoadOpponentTeam{
    NSLog(@"LoadOpponentFromFile");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"opponentteamdictionary.out"];
    
    opponentTeamDictionaryArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    lastname = [[opponentTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:receivedBatterPositionNumber];
    
    
    
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
                wa,@"batterwalks",
                str,@"batterstrikeouts",
                wap,@"walkspitched",
                strValue,@"strikeoutspitched",
                hitLocation,@"hittingchart",
                pitchlocation,@"pitchingchart",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:receivedBatterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",receivedBatterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:receivedBatterPositionNumber]);
    
        //saveback
    
}

- (void)LoadGameVariables{
    NSLog(@"LoadGameVariables");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"gamevariables.out"];
    NSDictionary *load = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    inningNumber = [[load valueForKey:@"currentinning"]intValue];
    isTopOfInning = [[load valueForKey:@"topofinning"]boolValue];
    NSLog(@"inningNumber: %d",inningNumber);
    NSLog(@"isTopOfInning: %d",isTopOfInning);
    
}

-(void)loadOpponentTeamDictionaryArray{
        //load
    fb = [[opponentTeamDictionaryArray valueForKey:@"1B"]objectAtIndex:receivedBatterPositionNumber];
    sb = [[opponentTeamDictionaryArray valueForKey:@"2B"]objectAtIndex:receivedBatterPositionNumber];
    tb = [[opponentTeamDictionaryArray valueForKey:@"3B"]objectAtIndex:receivedBatterPositionNumber];
    hr = [[opponentTeamDictionaryArray valueForKey:@"HR"]objectAtIndex:receivedBatterPositionNumber];
    fc = [[opponentTeamDictionaryArray valueForKey:@"fielderschoice"]objectAtIndex:receivedBatterPositionNumber];
    fe = [[opponentTeamDictionaryArray valueForKey:@"fieldingerror"]objectAtIndex:receivedBatterPositionNumber];
    hp = [[opponentTeamDictionaryArray valueForKey:@"hitbypitch"]objectAtIndex:receivedBatterPositionNumber];
    sf = [[opponentTeamDictionaryArray valueForKey:@"sacfly"]objectAtIndex:receivedBatterPositionNumber];
    rb = [[opponentTeamDictionaryArray valueForKey:@"RBI"]objectAtIndex:receivedBatterPositionNumber];
    ou = [[opponentTeamDictionaryArray valueForKey:@"out"]objectAtIndex:receivedBatterPositionNumber];
    bt = [[opponentTeamDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:receivedBatterPositionNumber];
    st = [[opponentTeamDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:receivedBatterPositionNumber];
    fn = [[opponentTeamDictionaryArray valueForKey:@"firstname"]objectAtIndex:receivedBatterPositionNumber];
    ln = [[opponentTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:receivedBatterPositionNumber];
    pn = [[opponentTeamDictionaryArray valueForKey:@"playernumber"]objectAtIndex:receivedBatterPositionNumber];
    pb = [[opponentTeamDictionaryArray valueForKey:@"playerbat"]objectAtIndex:receivedBatterPositionNumber];
    pt = [[opponentTeamDictionaryArray valueForKey:@"playerthrow"]objectAtIndex:receivedBatterPositionNumber];
    pi = [[opponentTeamDictionaryArray valueForKey:@"pitcher"]objectAtIndex:receivedBatterPositionNumber];
    wap = [[opponentTeamDictionaryArray valueForKey:@"walkspitched"]objectAtIndex:receivedBatterPositionNumber];
    strp = [[opponentTeamDictionaryArray valueForKey:@"strikeoutspitched"]objectAtIndex:receivedBatterPositionNumber];
    
}

- (void)loadMyTeamDictionaryArray{
        //load
    fb = [[myTeamDictionaryArray valueForKey:@"1B"]objectAtIndex:receivedBatterPositionNumber];
    sb = [[myTeamDictionaryArray valueForKey:@"2B"]objectAtIndex:receivedBatterPositionNumber];
    tb = [[myTeamDictionaryArray valueForKey:@"3B"]objectAtIndex:receivedBatterPositionNumber];
    hr = [[myTeamDictionaryArray valueForKey:@"HR"]objectAtIndex:receivedBatterPositionNumber];
    fc = [[myTeamDictionaryArray valueForKey:@"fielderschoice"]objectAtIndex:receivedBatterPositionNumber];
    fe = [[myTeamDictionaryArray valueForKey:@"fieldingerror"]objectAtIndex:receivedBatterPositionNumber];
    hp = [[myTeamDictionaryArray valueForKey:@"hitbypitch"]objectAtIndex:receivedBatterPositionNumber];
    sf = [[myTeamDictionaryArray valueForKey:@"sacfly"]objectAtIndex:receivedBatterPositionNumber];
    rb = [[myTeamDictionaryArray valueForKey:@"RBI"]objectAtIndex:receivedBatterPositionNumber];
    ou = [[myTeamDictionaryArray valueForKey:@"out"]objectAtIndex:receivedBatterPositionNumber];
    bt = [[myTeamDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:receivedBatterPositionNumber];
    st = [[myTeamDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:receivedBatterPositionNumber];
    fn = [[myTeamDictionaryArray valueForKey:@"firstname"]objectAtIndex:receivedBatterPositionNumber];
    ln = [[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:receivedBatterPositionNumber];
    pn = [[myTeamDictionaryArray valueForKey:@"playernumber"]objectAtIndex:receivedBatterPositionNumber];
    pb = [[myTeamDictionaryArray valueForKey:@"playerbat"]objectAtIndex:receivedBatterPositionNumber];
    pt = [[myTeamDictionaryArray valueForKey:@"playerthrow"]objectAtIndex:receivedBatterPositionNumber];
    pi = [[myTeamDictionaryArray valueForKey:@"pitcher"]objectAtIndex:receivedBatterPositionNumber];
    wa = [[myTeamDictionaryArray valueForKey:@"walks"]objectAtIndex:receivedBatterPositionNumber];
    str = [[myTeamDictionaryArray valueForKey:@"strikeouts"]objectAtIndex:receivedBatterPositionNumber];
    wap = [[myTeamDictionaryArray valueForKey:@"walkspitched"]objectAtIndex:receivedBatterPositionNumber];
    strp = [[myTeamDictionaryArray valueForKey:@"strikeoutspitched"]objectAtIndex:receivedBatterPositionNumber];
    
}

@end
