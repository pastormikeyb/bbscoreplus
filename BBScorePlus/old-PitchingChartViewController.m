    //
    //  PitchingChartViewController.m
    //  BBScorePlus
    //
    //  Created by Michael on 10/15/15.
    //  Copyright © 2015 Michael Usry. All rights reserved.
    //

#import "old-PitchingChartViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface PitchingChartViewController ()
{
    NSMutableArray *myTeamDictionaryArray, *opponentTeamDictionaryArray, *arrayOfDictionariesMutableArray;
    NSString *lastName, *playerBats, *dictPath, *currentPitcher, *currentHitter;
    NSString *loadedCurrentOuts,*loadedPitchCount;
    int batterPositionNumber, nextBatterPositionNumber;
    int loadedHomeR,loadedHomeH,loadedHomeE,loadedVisitorR,loadedVisitorH,loadedVisitorE;
    int loadedBalls,loadedStrikes,loadedOuts,loadedPC;
    int singleHit,doubleHit,tripleHit,homeRun,fieldersChoice,fieldingError,hitByPitch,sacFly;
    NSNumber *loadedBallCount,*loadedStrikeCount,*loadedNextBatter;
    NSDate *gameTimeStart;
    NSNumber *xPos, *yPos;
    NSArray *tempArray, *pitcher,*playerNumber;
    NSDictionary *boxScoreDictionary, *hittingDictionary,*curPitcherDictionary,*pitcherPitchCountDictionary,*gameVariablesDictionary;
    NSArray *name, *opponentPlayerNumber;
    NSArray *bats;
    NSString *bats1;
    NSString *whoIsBatting;
    NSMutableArray *topLevel, *myArray;
    
}

@end

@implementation PitchingChartViewController
@synthesize currentOutLabel, currentBallsLabel,currentStrikeLabel,currentPlayerNumberLabel, currentPitchCountLabel, currentBat, currentBatter, isBottomOfInning, isTopOfInning;


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self GameOver];
    topLevel = [[NSMutableArray alloc]init];
    myArray = [[NSMutableArray alloc]init];

    if (doesGameVariablesFileExist) {
        NSLog(@"GameVariables does NOT exist");
//        [self LoadGameVariables];

    }
    
//    [self LoadGameDefaults];
//    [self LoadMyTeam];
//    [self LoadOpponentTeam];
//
    homeRuns = 0;
    homeHits = 0;
    homeErrors = 0;
    visitorRuns = 0;
    visitorHits = 0;
    visitorErrors = 0;
    
    currentPitchingChart = [[NSMutableArray alloc]init];
    arrayOfDictionariesMutableArray = [[NSMutableArray alloc]init];
//    opponentTeamDictionaryArray = [[NSMutableArray alloc]init];
//    myTeamDictionaryArray = [[NSMutableArray alloc]init];

    
//    [self endOfGameTime]; // testing
    
    
//    if ([self DoesBoxScoreExist]) {
//        [self LoadBoxScore];
//        
//        NSNumber *co = [NSNumber numberWithInt:[loadedCurrentOuts intValue]];
//        NSNumber *pc = [NSNumber numberWithInt:[loadedPitchCount intValue]];
//        
//        [currentOutLabel setText:[co stringValue]];
//        [currentPitchCountLabel setText:[pc stringValue]];
//        
//        currentPitchCount = [pc intValue];
//        currentOuts = [co intValue];
//    }else{
//        [self gameStart];
//    }
    
    if (isMyTeamPitching) {
        
        name = [opponentTeamDictionaryArray objectAtIndex:batterPositionNumber];
        currentHitter = [name valueForKey:@"lastname"];
        bats = [opponentTeamDictionaryArray objectAtIndex:batterPositionNumber];
        bats1 = [name valueForKey:@"playerbat"];
        
        currentBatterHitPositionLabel.text = bats1;
        currentBatterNameLabel.text = currentHitter;
        currentPlayerNumberLabel.text = [opponentPlayerNumber objectAtIndex:batterPositionNumber];
        whoIsBatting = @"opponent";
        
    }else{
        
        name = [myTeamDictionaryArray objectAtIndex:batterPositionNumber];
        currentHitter = [name valueForKey:@"lastname"];
        bats = [myTeamDictionaryArray objectAtIndex:batterPositionNumber];
        bats1 = [bats valueForKey:@"playerbat"];
        
        currentBatterHitPositionLabel.text = bats1;
        currentBatterNameLabel.text = currentHitter;
        whoIsBatting = @"us";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (void)gameStart{
    batterPositionNumber = 0;
    nextBatterPositionNumber = 0;
        //    currentPitchingChart = [NSMutableArray alloc];
    [self getCurrentTime];
    currentBallsLabel.text = @"0";
    currentOutLabel.text = @"0";
    currentStrikeLabel.text = @"0";
    isGameStarted = YES;
    if (isHomeTeam) {
        isMyTeamPitching = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [[touches allObjects] objectAtIndex: 0];
    CGPoint currentPos = [myTouch locationInView: nil];
    NSLog(@"Point in myView: (%f,%f)", currentPos.x, currentPos.y);
    if (currentPos.x >= 155 && currentPos.x <= 405) {
        if (currentPos.y >= 10 && currentPos.y <= 290) {
            UIImageView *bbView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baseballSmall"]] ;
                // SAVE THE HIT COORDS & CURRENT BATTER
            float xP = currentPos.x;
            float yP = currentPos.y;
            xPos = [NSNumber numberWithFloat:xP];
            yPos = [NSNumber numberWithFloat:yP];
            
            tempArray = [NSArray arrayWithObjects:
                         xPos,yPos,nil];
            
                //addto main chart
            [currentPitchingChart addObject:tempArray];
            
            
            
            NSLog(@"hitLocation %@",currentPitchingChart);
            
            
            [bbView setCenter:CGPointMake(currentPos.x, currentPos.y)]; // x, y
            [self.view addSubview:bbView];
            
        }
    }
    
}

- (IBAction)stepper:(id)sender {
    UIStepper *step = (UIStepper *) sender;
    
    step.maximumValue = 99;
    step.minimumValue = 0;
    
    if (isHomeTeam) {
        if (step){
            homeRuns++;
            NSLog(@"homeRuns: %i",homeRuns);
        }
        else{
            
            homeRuns--;
            NSLog(@"homeRuns: %i",homeRuns);
            
        }
    }
    if (!isHomeTeam) {
        if (step){
            visitorRuns++;
            NSLog(@"visitorRuns: %i",visitorRuns);
            
        }
        else{
            visitorRuns--;
            NSLog(@"visitorRuns: %i",visitorRuns);
            
        }
        
    }
}


- (IBAction)onClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    switch (button.tag) {
        case 0:
                // 1B
            NSLog(@"1B");
            currentPitchCount ++;
            singleHit ++;
            
            if (isMyTeamPitching) {
                    //opponent
                NSLog(@"hit: %@", [[opponentTeamDictionaryArray valueForKey:@"1B"]batterPositionNumber]);
            }else{
                    //me
                NSLog(@"hit: %@", [[myTeamDictionaryArray valueForKey:@"1B"]objectAtIndex:batterPositionNumber]);
                NSNumber *loaded = [[myTeamDictionaryArray valueForKey:@"1B"]objectAtIndex:batterPositionNumber];
                int conv = [loaded intValue];
                int update = conv + singleHit;
                NSInteger change = batterPositionNumber;
                NSNumber *sb = [NSNumber numberWithInt:update];
                
                for (NSDictionary *ma in myTeamDictionaryArray)
                    [topLevel addObject:[ma valueForKey:@"1B"]];
                NSString *repl = [topLevel objectAtIndex:batterPositionNumber];
                NSLog(@"repl: %@",repl);
                
                NSLog(@"topLevel: %@",topLevel);
                
//                [topLevel addObject:[myTeamDictionaryArray valueForKey:@"1B"]];
                
                NSLog(@"topleveladded: %@",topLevel);
                NSLog(@"toplevel@0: %@",[topLevel objectAtIndex:0]);

                [topLevel replaceObjectAtIndex:batterPositionNumber withObject:sb];
                
                NSLog(@"topLevel update: %@", topLevel);
                
                [myTeamDictionaryArray setValue:topLevel forKey:@"1B"];
                
                NSLog(@"update: %d", update);
                NSLog(@"updated team dict: %@",myTeamDictionaryArray);
                
                NSLog(@"sb: %@", sb);
                NSLog(@"hit - updated: %@", [[myTeamDictionaryArray valueForKey:@"1B"]objectAtIndex:batterPositionNumber]);
            }
            [self pitchCount];
            [self pitchStrike];
//            [self updateCurrentBatter];
            [self addToBoxScoreDictionary];
            [self addToCurrentPitcherDictionary];
            [self addPitcherPitchCountDictionary];
                //LAST
            batterPositionNumber ++;
            
            break;
            
        case 1:
                //2B
            NSLog(@"2B");
            currentPitchCount ++;
            doubleHit ++;
            [self pitchCount];
            [self performSegueWithIdentifier:@"HittingChart1B" sender:nil];
            
            
            [self pitchCount];
            [self pitchStrike];
                //            [self updateCurrentBatter];
            [self addToBoxScoreDictionary];
            [self addToCurrentPitcherDictionary];
            [self addPitcherPitchCountDictionary];
                //LAST
            batterPositionNumber ++;

            break;
            
        case 2:
                // 3B
            NSLog(@"3B");
            currentPitchCount ++;
            tripleHit ++;
            
            [self pitchCount];
            [self performSegueWithIdentifier:@"HittingChart1B" sender:nil];
            
            [self pitchCount];
            [self pitchStrike];
                //            [self updateCurrentBatter];
            [self addToBoxScoreDictionary];
            [self addToCurrentPitcherDictionary];
            [self addPitcherPitchCountDictionary];
                //LAST
            batterPositionNumber ++;

            break;
            
        case 3:
                //HR
            NSLog(@"HR");
            currentPitchCount++;
            homeRun ++;
            
            
            [self pitchCount];
            [self performSegueWithIdentifier:@"HittingChart1B" sender:nil];
            
            [self pitchCount];
            [self pitchStrike];
                //            [self updateCurrentBatter];
            [self addToBoxScoreDictionary];
            [self addToCurrentPitcherDictionary];
            [self addPitcherPitchCountDictionary];
                //LAST
            batterPositionNumber ++;

            break;
            
        case 4:
                // FC
            NSLog(@"FC");
            currentPitchCount++;
            fieldersChoice ++;
            
            [self pitchCount];
            [self performSegueWithIdentifier:@"HittingChart1B" sender:nil];
            
            [self pitchCount];
            [self pitchStrike];
                //            [self updateCurrentBatter];
            [self addToBoxScoreDictionary];
            [self addToCurrentPitcherDictionary];
            [self addPitcherPitchCountDictionary];
                //LAST
            batterPositionNumber ++;

            break;
            
        case 5:
                //E
            NSLog(@"E");
            currentPitchCount++;
            fieldingError ++;
            
            [self pitchCount];
            [self performSegueWithIdentifier:@"HittingChart1B" sender:nil];
            
            [self pitchCount];
            [self pitchStrike];
                //            [self updateCurrentBatter];
            [self addToBoxScoreDictionary];
            [self addToCurrentPitcherDictionary];
            [self addPitcherPitchCountDictionary];
                //LAST
            batterPositionNumber ++;

            break;
            
        case 6:
                // OUT
            NSLog(@"OUT");
            currentOuts ++;
            if (currentOuts > 2) {
                if (!isTopOfInning) {
                    isTopOfInning = YES;
                    
                }
                currentOuts = 0;
            }
            [self inningOuts];
            [self performSegueWithIdentifier:@"HittingChart1B" sender:nil];
            
            [self pitchCount];
            [self pitchStrike];
                //            [self updateCurrentBatter];
            [self addToBoxScoreDictionary];
            [self addToCurrentPitcherDictionary];
            [self addPitcherPitchCountDictionary];
                //LAST
            batterPositionNumber ++;

            break;
            
        case 7:
                // HP
            NSLog(@"HP");
            currentPitchCount ++;
            hitByPitch ++;
            
            [self pitchCount];
            [self performSegueWithIdentifier:@"HittingChart1B" sender:nil];
            
            [self pitchCount];
            [self pitchStrike];
                //            [self updateCurrentBatter];
            [self addToBoxScoreDictionary];
            [self addToCurrentPitcherDictionary];
            [self addPitcherPitchCountDictionary];
                //LAST
            batterPositionNumber ++;

            break;
            
        case 8:
                //SAC
            NSLog(@"SAC");
            currentPitchCount ++;
            sacFly ++;
            
            [self pitchCount];
            [self performSegueWithIdentifier:@"HittingChart1B" sender:nil];
            
            break;
            
        case 9:
                // BALL
            NSLog(@"BALL");
            currentBatterBall ++;
            currentPitchCount ++;
            totalBallsThrown ++;
            if (currentBatterBall > 3) {
                    //AddWalk to batter
                currentBatterBall = 0;
                    //add walk to current batter
                    //remove balls from screen
                
            }
            [self pitchCount];
            [self pitchBall];
            
        
            break;
            
        case 10:
                //STRIKE
            NSLog(@"STRIKE");
            currentBatterStrike ++;
            totalStrikesThrown ++;
            currentPitchCount ++;
            if (currentBatterStrike > 2) {
                currentOuts ++;
                currentBatterStrike = 0;
            }
            [self pitchCount];
            [self pitchStrike];
            [self inningOuts];
            
            break;
            
        default:
            break;
    }
}
/*
- (void)updateCurrentBatter{
    if (!isMyTeamPitching) {
        NSLog(@"MyTeamCurrentPlayer");
        NSLog(@"currentPlayer %@",[myTeamDictionaryArray objectAtIndex:batterPositionNumber]);
            //        NSMutableArray *cp = [myTeamDictionaryArray objectAtIndex:batterPositionNumber];
        NSMutableDictionary *cpnsmd = [NSMutableDictionary dictionary];
            //[array replaceObjectAtIndex:index withObject:newObject];
            //read current player
        NSString *firstname = [[myTeamDictionaryArray valueForKey:@"firstname"]objectAtIndex:batterPositionNumber];
        NSString *lastname = [[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:batterPositionNumber];
        NSString *pitch = [[myTeamDictionaryArray valueForKey:@"pitcher"]objectAtIndex:batterPositionNumber];
        NSString *playerbat = [[myTeamDictionaryArray valueForKey:@"playerbat"]objectAtIndex:batterPositionNumber];
        NSString *playernumber = [[myTeamDictionaryArray valueForKey:@"playernumber"]objectAtIndex:batterPositionNumber];
        NSString *playerthrow = [[myTeamDictionaryArray valueForKey:@"playerthrow"]objectAtIndex:batterPositionNumber];
        NSString *fb = [[myTeamDictionaryArray valueForKey:@"1B"]objectAtIndex:batterPositionNumber];
        NSString *sb = [[myTeamDictionaryArray valueForKey:@"2B"]objectAtIndex:batterPositionNumber];
        NSString *tb = [[myTeamDictionaryArray valueForKey:@"2B"]objectAtIndex:batterPositionNumber];
        NSString *hr = [[myTeamDictionaryArray valueForKey:@"HR"]objectAtIndex:batterPositionNumber];
        NSString *fc = [[myTeamDictionaryArray valueForKey:@"fielderschoice"]objectAtIndex:batterPositionNumber];
        NSString *fe = [[myTeamDictionaryArray valueForKey:@"fieldingerror"]objectAtIndex:batterPositionNumber];
        NSString *hbp = [[myTeamDictionaryArray valueForKey:@"hitbypitch"]objectAtIndex:batterPositionNumber];
        NSString *sf = [[myTeamDictionaryArray valueForKey:@"sacfly"]objectAtIndex:batterPositionNumber];
        NSString *rbi = [[myTeamDictionaryArray valueForKey:@"RBI"]objectAtIndex:batterPositionNumber];
        NSString *ou = [[myTeamDictionaryArray valueForKey:@"out"]objectAtIndex:batterPositionNumber];
        NSString *bp = [[myTeamDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:batterPositionNumber];
        NSString *sp = [[myTeamDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:batterPositionNumber];

        
        NSString *sh1 = [@(singleHit) stringValue];
        NSString *dh1 = [@(doubleHit) stringValue];
        NSString *th1 = [@(tripleHit) stringValue];
        NSString *hr1 = [@(homeRun) stringValue];
        NSString *fc1 = [@(fieldersChoice) stringValue];
        NSString *fe1 = [@(fieldingError) stringValue];
        NSString *hp1 = [@(hitByPitch) stringValue];
        NSString *sf1 = [@(sacFly) stringValue];
//
//        [[cpnsmd setObject:firstname forKey:@"firstname"]objectAtIndex:batterPositionNumber];
//        [cpnsmd setObject:lastname forKey:@"lastname"];
//        [cpnsmd setObject:pitch forKey:@"pitcher"];
//        [cpnsmd setObject:playerbat forKey:@"playerbat"];
//        [cpnsmd setObject:playernumber forKey:@"playernumber"];
//        [cpnsmd setObject:playerthrow forKey:@"playerthrow"];
//        [cpnsmd setObject:sh forKey:@"1B"];
//        [cpnsmd setObject:dh forKey:@"2B"];
//        [cpnsmd setObject:th forKey:@"3B"];
//        [cpnsmd setObject:hr forKey:@"HR"];
//        [cpnsmd setObject:fc forKey:@"fielderschoice"];
//        [cpnsmd setObject:fe forKey:@"fieldingerror"];
//        [cpnsmd setObject:hp forKey:@"hitbypitch"];
//        [cpnsmd setObject:sf forKey:@"sacfly"];
        
        
        NSLog(@"current Batter:\n%@",cpnsmd);
        
        
    }else{
        NSArray *tempOpponent;
        NSLog(@"VisitorCurrentPlayer");
        NSLog(@"VisitorCurrentPlayer %@",[opponentTeamDictionaryArray objectAtIndex:batterPositionNumber]);
            //        NSMutableArray *cp = [opponentTeamDictionaryArray objectAtIndex:batterPositionNumber];
        NSMutableDictionary *cpnsmd = [NSMutableDictionary dictionary];
            //[array replaceObjectAtIndex:index withObject:newObject];
            //read current player
        NSString *firstname = [[opponentTeamDictionaryArray valueForKey:@"firstname"]objectAtIndex:batterPositionNumber];
        NSString *lastname = [opponentTeamDictionaryArray valueForKey:@"lastname"];
        NSString *pitch = [opponentTeamDictionaryArray valueForKey:@"pitcher"];
        NSString *playerbat = [opponentTeamDictionaryArray valueForKey:@"playerbat"];
        NSString *playernumber = [opponentTeamDictionaryArray valueForKey:@"playernumber"];
        NSString *playerthrow = [opponentTeamDictionaryArray valueForKey:@"playerthrow"];
        NSString *fb = [opponentTeamDictionaryArray valueForKey:@"1B"];
        NSString *sb = [opponentTeamDictionaryArray valueForKey:@"2B"];
        NSString *tb = [opponentTeamDictionaryArray valueForKey:@"3B"];
        NSString *hr = [opponentTeamDictionaryArray valueForKey:@"HR"];
        NSString *fc = [opponentTeamDictionaryArray valueForKey:@"fielderschoice"];
        NSString *fe = [opponentTeamDictionaryArray valueForKey:@"fieldingerror"];
        NSString *hbp = [opponentTeamDictionaryArray valueForKey:@"hitbypitch"];
        NSString *sf = [opponentTeamDictionaryArray valueForKey:@"sacfly"];
        NSString *rbi = [opponentTeamDictionaryArray valueForKey:@"RBI"];
        NSString *ou = [opponentTeamDictionaryArray valueForKey:@"out"];
        NSString *bpit = [opponentTeamDictionaryArray valueForKey:@"ballspitched"];
        NSString *spit = [opponentTeamDictionaryArray valueForKey:@"strikesthrown"];

//        NSString *sh = [@(singleHit) stringValue];
//        NSString *dh = [@(doubleHit) stringValue];
//        NSString *th = [@(tripleHit) stringValue];
//        NSString *hr = [@(homeRun) stringValue];
//        NSString *fc = [@(fieldersChoice) stringValue];
//        NSString *fe = [@(fieldingError) stringValue];
//        NSString *hp = [@(hitByPitch) stringValue];
//        NSString *sf = [@(sacFly) stringValue];
        
//        [cpnsmd setObject:firstname forKey:@"firstname"];
//        [cpnsmd setObject:lastname forKey:@"lastname"];
//        [cpnsmd setObject:pitch forKey:@"pitcher"];
//        [cpnsmd setObject:playerbat forKey:@"playerbat"];
//        [cpnsmd setObject:playernumber forKey:@"playernumber"];
//        [cpnsmd setObject:playerthrow forKey:@"playerthrow"];
//        [cpnsmd setObject:sh forKey:@"1B"];
//        [cpnsmd setObject:dh forKey:@"2B"];
//        [cpnsmd setObject:th forKey:@"3B"];
//        [cpnsmd setObject:hr forKey:@"HR"];
//        [cpnsmd setObject:fc forKey:@"fielderschoice"];
//        [cpnsmd setObject:fe forKey:@"fieldingerror"];
//        [cpnsmd setObject:hp forKey:@"hitbypitch"];
//        [cpnsmd setObject:sf forKey:@"sacfly"];
        
        
        NSLog(@"current Batter:\n%@",cpnsmd);

        
    }
}
*/
- (void) pitchCount{
    currentPitchCountLabel.text = [NSString stringWithFormat:@"%i",currentPitchCount];
    
}

- (void) pitchBall{
    currentBallsLabel.text = [NSString stringWithFormat:@"%i",currentBatterBall];
    
}

- (void) inningOuts{
    currentOutLabel.text = [NSString stringWithFormat:@"%i",currentOuts];
    
}

- (void) pitchStrike{
    currentStrikeLabel.text = [NSString stringWithFormat:@"%i",currentBatterStrike];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"HittingChart1B"]) {
        HittingChartViewController *destViewController = segue.destinationViewController;
        destViewController.pitcherPitchCountDictionary = pitcherPitchCountDictionary;
    }
}

- (void)LoadMyTeam{
    NSLog(@"LoadMyTeamFromFile");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"teamdictionary.out"];
    
    myTeamDictionaryArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    lastName = [myTeamDictionaryArray valueForKey:@"lastname"];
    playerBats = [myTeamDictionaryArray valueForKey:@"playerbat"];
    playerNumber = [myTeamDictionaryArray valueForKey:@"playernumber"];
        //
        //    NSLog(@"firstname: %@",firstname);
    
    NSPredicate *cp = [NSPredicate predicateWithFormat:@"pitcher = true"];
    pitcher = [myTeamDictionaryArray filteredArrayUsingPredicate:cp];
    NSLog(@"filter %@",pitcher);
    
    NSArray *f;
    
    f = [pitcher valueForKey:@"lastname"];
    
    currentPitcher = [f objectAtIndex:0];
    
    NSLog(@"currentPitcher: %@",currentPitcher);
    
    
}

- (void)LoadGameDefaults{
    NSLog(@"LoadGameDefaultsFromFile");
    isDefaultsLoaded = YES;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"gamedefaults.out"];
    NSArray *m, *h, *t;
    
    loadedGameDefaultsArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    m = [loadedGameDefaultsArray valueForKey:@"maxnumberofpitches"];
    h = [loadedGameDefaultsArray valueForKey:@"numberofhoursrest"];
    t = [loadedGameDefaultsArray valueForKey:@"gametimelimit"];
    isHomeTeam = [loadedGameDefaultsArray valueForKey:@"hometeam"];
    isTrackPitchCount = [loadedGameDefaultsArray valueForKey:@"trackpitchcount"];
    
    maxPitches = [m objectAtIndex:0];
    hoursRest = [h objectAtIndex:0];
    timeLimit = [t objectAtIndex:0];
    
    NSLog(@"array: %@",loadedGameDefaultsArray);
    NSLog(@"maxnumberofpitches: %@", maxPitches);
    NSLog(@"array: %@",hoursRest);
    NSLog(@"array: %@",timeLimit);
        //    NSLog(@"array: %@",isHomeTeam);
        //    NSLog(@"array: &@",isTrackPitchCount);
    NSLog(@"pause");
}

- (void)LoadOpponentTeam{
    NSLog(@"LoadOpponentFromFile");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"opponentteamdictionary.out"];
    
    opponentTeamDictionaryArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    lastName = [opponentTeamDictionaryArray valueForKey:@"lastname"];
    playerBats = [opponentTeamDictionaryArray valueForKey:@"playerbat"];
    opponentPlayerNumber = [opponentTeamDictionaryArray valueForKey:@"playernumber"];
        //
        //    NSLog(@"firstname: %@",firstname);
    NSPredicate *cp = [NSPredicate predicateWithFormat:@"pitcher = true"];
    NSArray *filtered = [opponentTeamDictionaryArray filteredArrayUsingPredicate:cp];
    NSLog(@"filter %@",filtered);
    NSArray *f;
    
    f = [filtered valueForKey:@"lastname"];
    
    currentPitcher = [f objectAtIndex:0];
    
    NSLog(@"currentPitcher: %@",currentPitcher);
    
}

- (BOOL)doesFileExist {
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

- (void)getCurrentTime{
    gameTimeStart = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:gameTimeStart]);
    
}

- (void)saveTeamPitcher{
    NSLog(@"saveTeamPitcher");
        //PUT PLAYER INFO INTO OBJECT
    if ([self doesFileExist]) {
        NSLog(@"fileExist");
        
            //load file
        [self removeCurrentGameTeamPitchingFile];
        
    }
    
        // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
        // Path to save dictionary
    dictPath = [[paths objectAtIndex:0]
                stringByAppendingPathComponent:@"currentteamgamepitcher.out"];
    
    if ([paths count] > 0)
    {
        
            //pitchcount
        
            //pitcher
        
            // Write dictionary
        [curPitcherDictionary writeToFile:dictPath atomically:YES];
        
    }
    
}

- (void)addToCurrentPitcherDictionary {
    NSNumber *isteampitching = @(isMyTeamPitching);
        //    continous = @(isContinousLineup);
        //    home = @(isHomeTeam);
    NSNumber *pc = [NSNumber numberWithInt:currentPitchCount];
    
    
    curPitcherDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                            pc,@"currentpitchcount",
                            pitcher,@"pitcher",//grab array index
                            isteampitching,@"ismyteampitching",
                            nil];
    
        //    [arrayOfDictionariesMutableArray addObject:curPitcherDictionary];
    
    NSLog(@"gameSettingsDictionary: %@",curPitcherDictionary);
    
    NSLog(@"arrayOfDictionariesMutableArray: %@",arrayOfDictionariesMutableArray);
    NSLog(@"array count: %lu",(unsigned long)[arrayOfDictionariesMutableArray count]);
    
    [self saveTeamPitcher];
    
}

- (void)gameVariables {
    NSNumber *isteampitching = @(isMyTeamPitching);
    NSNumber *ishometeam = @(isHomeTeam);
    NSNumber *istopofinning = @(isTopOfInning);
    NSNumber *gamestarted = @(isGameStarted);
    
    gameVariablesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                            ishometeam,@"ishometeam",
                            istopofinning,@"istopofinning",
                            isteampitching,@"ismyteampitching",
                            gamestarted,@"isgamestarted",
                            nil];
    
    NSLog(@"gameVariablesDictionary: %@",gameVariablesDictionary);
    
    [self saveGameVariables];
    
}

- (void)saveGameVariables{
    NSLog(@"saveGameVariables");

    if ([self doesFileExist]) {
        NSLog(@"fileExist");
        
            //load file
        [self removeGameVariablesFile];
        
    }
    
        // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
        // Path to save dictionary
    dictPath = [[paths objectAtIndex:0]
                stringByAppendingPathComponent:@"gamevariables.out"];
    
    if ([paths count] > 0)
    {
        
            // Write dictionary
        [gameVariablesDictionary writeToFile:dictPath atomically:YES];
        
    }

}

- (BOOL)doesGameVariablesFileExist {
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

- (void)removeGameVariablesFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"gamevariables.out"];
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

- (void)addToBoxScoreDictionary {
        //    pitch = @(isTrackingPitchCount);
        //    continous = @(isContinousLineup);
        //    home = @(isHomeTeam);
    NSNumber *pc = [NSNumber numberWithInt:currentPitchCount];
    NSNumber *homerun = [NSNumber numberWithInt:homeRuns];
    NSNumber *homehits = [NSNumber numberWithInt:homeHits];
    NSNumber *homeerrors = [NSNumber numberWithInt:homeErrors];
    NSNumber *visitorrun = [NSNumber numberWithInt:visitorRuns];
    NSNumber *visitorhits = [NSNumber numberWithInt:visitorHits];
    NSNumber *visitorerrors = [NSNumber numberWithInt:visitorErrors];
    NSNumber *currentouts = [NSNumber numberWithInt:currentOuts];
    
    if ([self DoesBoxScoreExist]) {
        NSLog(@"DoesBoxScoreExist = YES");
    }
    [self removeBoxScore];
    
    boxScoreDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                          homerun,@"homeruns",
                          homehits,@"homehits",
                          homeerrors,@"homeerrors",
                          visitorrun,@"visitorruns",
                          visitorhits,@"visitorhits",
                          visitorerrors,@"visitorerrors",
                          pc,@"pitchcount",
                          currentouts,@"currentouts",
                          nil];
    
    NSLog(@"boxScoreDictionary: %@",boxScoreDictionary);
    
    NSLog(@"arrayOfDictionariesMutableArray: %@",arrayOfDictionariesMutableArray);
    NSLog(@"array count: %lu",(unsigned long)[arrayOfDictionariesMutableArray count]);
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

- (void)addPitcherPitchCountDictionary {
        //History of pitcher pitching
        //array number saved so we know which is pitcher
        //use for segue
    
        //    pitch = @(isTrackingPitchCount);
        //    continous = @(isContinousLineup);
        //    home = @(isHomeTeam);
    NSNumber *pc = [NSNumber numberWithInt:currentPitchCount];
    NSNumber *ballcount = [NSNumber numberWithInt:totalBallsThrown];
    NSNumber *strikecount = [NSNumber numberWithInt:totalStrikesThrown];
    NSNumber *batterindexarray = [NSNumber numberWithInt:batterPositionNumber];
    NSNumber *nextbatter = [NSNumber numberWithInt:nextBatterPositionNumber];
    
    
    pitcherPitchCountDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                   pc,@"pitchcount",
                                   ballcount,@"ballsthrown",
                                   strikecount,@"strikesthrown",
                                   batterindexarray,@"currentbatterpositionnumber",
                                   nextbatter,@"nextbatterpositionnumber",
                                   
                                   nil];
    
        //    [arrayOfDictionariesMutableArray addObject:boxScoreDictionary];
    
        //    NSLog(@"pitcherPitchCountDictionary: %@",pitcherPitchCountDictionary);
        //
        //    NSLog(@"arrayOfDictionariesMutableArray: %@",[arrayOfDictionariesMutableArray objectAtIndex:batterPositionNumber]);
        //    NSLog(@"array count: %lu",(unsigned long)[arrayOfDictionariesMutableArray count]);
}

- (void)removeCurrentGameTeamPitchingFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"currentgameteampitching.out"];
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

- (void)LoadBoxScore{
    NSLog(@"LoadBoxScore");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"boxscore.out"];
    
    boxScoreDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
        //    arrayOfDictionariesMutableArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    loadedPitchCount = [boxScoreDictionary valueForKey:@"pitchcount"];
    loadedCurrentOuts = [boxScoreDictionary valueForKey:@"currentouts"];
    
    NSLog(@"homeRuns: %@",loadedPitchCount);
    
}

- (void)LoadPitcherPitchCountDirectory{
    NSLog(@"LoadBoxScore");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"boxscore.out"];
    
    pitcherPitchCountDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
        //    arrayOfDictionariesMutableArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    loadedBallCount = [pitcherPitchCountDictionary valueForKey:@"ballsthrown"];
    loadedStrikeCount = [pitcherPitchCountDictionary valueForKey:@"strikesthrown"];
    
    NSLog(@"pitcherPitchCountDictionary: %@",pitcherPitchCountDictionary);
    
}

- (void)LoadGameVariables{
    NSLog(@"LoadGameVariables");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"gamevariables.out"];
    
    gameVariablesDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    isGameStarted = [gameVariablesDictionary valueForKey:@"gamestarted"];
    isHomeTeam = [gameVariablesDictionary valueForKey:@"ishometeam"];
    isTopOfInning = [gameVariablesDictionary valueForKey:@"istopinning"];
    
    NSLog(@"gameVariablesDictionary: %@",gameVariablesDictionary);
    NSLog(@"Game Variables Loaded");
    
}

- (void)GameOver{
    NSLog(@"GameOver");
    [self LoadMyTeam];
    NSLog(@"COUNT: %lu", (unsigned long)myTeamDictionaryArray.count);
    NSLog(@"myTeamPlayer 0: %@",[myTeamDictionaryArray objectAtIndex:0]);
    NSString *repl = @"3";
    
        //load
    NSString *fb = [[myTeamDictionaryArray valueForKey:@"1B"]objectAtIndex:0];
    /*
    NSString *sb = [[myTeamDictionaryArray valueForKey:@"2B"]objectAtIndex:0];
    NSString *tb = [[myTeamDictionaryArray valueForKey:@"3B"]objectAtIndex:0];
    NSString *hr = [[myTeamDictionaryArray valueForKey:@"HR"]objectAtIndex:0];
    NSString *fc = [[myTeamDictionaryArray valueForKey:@"fielderschoice"]objectAtIndex:0];
    NSString *fe = [[myTeamDictionaryArray valueForKey:@"fieldingerror"]objectAtIndex:0];
    NSString *hp = [[myTeamDictionaryArray valueForKey:@"hitbypitch"]objectAtIndex:0];
    NSString *sf = [[myTeamDictionaryArray valueForKey:@"sacfly"]objectAtIndex:0];
    NSString *rb = [[myTeamDictionaryArray valueForKey:@"RBI"]objectAtIndex:0];
    NSString *ou = [[myTeamDictionaryArray valueForKey:@"out"]objectAtIndex:0];
    NSString *bt = [[myTeamDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:0];
    NSString *st = [[myTeamDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:0];
    NSString *fn = [[myTeamDictionaryArray valueForKey:@"firstname"]objectAtIndex:0];
    NSString *ln = [[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:0];
    NSString *pn = [[myTeamDictionaryArray valueForKey:@"playernumber"]objectAtIndex:0];
    NSString *pb = [[myTeamDictionaryArray valueForKey:@"playerbat"]objectAtIndex:0];
    NSString *pt = [[myTeamDictionaryArray valueForKey:@"playerthrow"]objectAtIndex:0];
    NSString *pi = [[myTeamDictionaryArray valueForKey:@"pitcher"]objectAtIndex:0];
  */
    NSLog(@"myTeamPlayer 0: %@",[[myTeamDictionaryArray valueForKey:@"1B"] objectAtIndex:0]);
    NSLog(@"fb: %@",fb);
    
        //update
[self setObject:repl forKey:@"1B"];
    NSLog(@"myTeamPlayerUpdated 0: %@",[[myTeamDictionaryArray valueForKey:@"1B"] objectAtIndex:0]);
    NSLog(@"fb: %@",fb);

        //saveback
    
    
    
}

- (void)setObject:(id)anObject forKey:(id)aKey{
    
}

- (void)setValue:(id)value forKey:(NSString *)key{
    
}

- (void)endOfGameTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hhmm dd-MM-yyyy"];
    
    NSString *string = [dateFormatter stringFromDate:gameTimeStart];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:string];
    NSLog(@"%@", dateFromString);
        //subtract time limit if !0
    NSDate *endTime = [dateFromString dateByAddingTimeInterval:- 60.0 * 15.0];//get
    NSLog(@"endTime: %@", endTime);
}

@end
