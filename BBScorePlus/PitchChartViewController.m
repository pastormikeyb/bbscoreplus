    //
    //  PitchChartViewController.m
    //  BBScorePlus
    //
    //  Created by Michael on 11/15/15.
    //  Copyright © 2015 Michael Usry. All rights reserved.
    //

#import "PitchChartViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PitchChartViewController ()
{
    NSMutableArray *myTeamDictionaryArray, *opponentTeamDictionaryArray, *arrayOfDictionariesMutableArray, *inningArray;
    NSString *lastName, *playerBats, *dictPath, *currentPitcher, *currentHitter;
    NSString *loadedCurrentOuts,*loadedPitchCount;
    int batterPositionNumber,receivedBatterPositionNumber, nextBatterPositionNumber, inningNumber;
    int loadedBalls,loadedStrikes,loadedOuts,loadedPC;
    int singleHit,doubleHit,tripleHit,homeRun,fieldersChoice,fieldingError,hitByPitch,sacFly;
    int myOut, opponentOut, myBallThrown,myStrikeThrown,opponentBallThrown,opponentStrikeThrown;
    int loadedMyTeamPos,loadedOppPos,loadedTemp;
    int currentInning,myTeamCount,opponentTeamCount;
    int loadedMyTeamCurrentBatter,loadedOpponentCurrentBatter;
    NSNumber *loadedBallCount,*loadedStrikeCount,*loadedNextBatter;
    NSDate *gameTimeStart;
    NSNumber *xPos, *yPos, *homeTeam;
    NSArray *pitchLocationArray, *myPitcherArray, *opponentPitcherArray,*playerNumber;
    NSDictionary *boxScoreDictionary, *hittingDictionary,*curPitcherDictionary,*pitcherPitchCountDictionary,*gameVariablesDictionary, *gameVariables,*tempdict;
    NSArray *name, *opponentPlayerNumber;
    NSArray *bats, *hitlocation, *pitchlocation;
    NSArray *loadedMyTeamArray,*loadedOpponentArray;
    NSString *bats1, *myPitcher,*opponentPitcher;
    NSString *whoIsBatting;
    NSMutableArray *topLevel, *myArray;
    BOOL loadMyPitcher,loadOpponentPitcher, isTimerStarted;
    NSString *fn, *ln, *pn, *pb, *pt, *pi, *fb, *sb, *tb, *hr, *fc,*fe,*hp,*sf,*rb,*ou,*bt,*st,*wa,*str,*wap,*strp,*strValue,*cb, *pc,*hc, *th, *oh;
    NSUInteger myPitcherIndex, opponentPitcherIndex;
    NSDate *endingTime;
}


@end

@implementation PitchChartViewController
@synthesize currentOutLabel, currentBallsLabel,currentStrikeLabel,currentPlayerNumberLabel, currentPitchCountLabel, currentBatLabel, currentBatterLabel,batterPositionNumber;


- (void)viewDidLoad {
    NSLog(@"received from hitting chart batterPositionNumber: %i",batterPositionNumber);
    
    myTeamDictionaryArray = [[NSMutableArray alloc]init];
    opponentTeamDictionaryArray = [[NSMutableArray alloc]init];
    tempdict = [[NSDictionary alloc]init];
    [super viewDidLoad];
    didHit = NO;
    [self LoadMyTeam];
    [self LoadOpponentTeam];
    [self LoadGameVariables];
    [self LoadGameDefaults];
    [self setGamePitchersIndex];
    if (![self DoesMyTeamFileExist]) {
        NSLog(@"NO team file");
        [self showMyRosterAlert];
    }
    
    if ([self DoesBoxScoreExist]) {
        [self LoadBoxScore];
        [self checkPitchCount];
    }
        //set app main variables
    
    amIBatting= [[boxScoreDictionary valueForKey:@"amibatting"]intValue];
    isHomeTeam = [boxScoreDictionary valueForKey:@"ishometeam"];
    isTopOfInning = [boxScoreDictionary valueForKey:@"istopofinning"];
    loadedMyTeamCurrentBatter = [[boxScoreDictionary valueForKey:@"myteambattingpositionnumber"]intValue];
    loadedOpponentCurrentBatter = [[boxScoreDictionary valueForKey:@"opponentbattingpositionnumber"]intValue];
    currentOuts = [[boxScoreDictionary valueForKey:@"currentouts"]intValue];
    currentInning = [[boxScoreDictionary valueForKey:@"currentinning"]intValue];
    
    if (isGameStarted) {
        [self gameTimeStart];
    }
    
    if (amIBatting){
        batterPositionNumber = [[boxScoreDictionary valueForKey:@"myteambattingpositionnumber"]intValue]-1;
        NSLog(@"I AM BATTING: %i",batterPositionNumber);
        NSLog(@"CURRENT BATTER: %@",[[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:batterPositionNumber]);
        
    }else{
        batterPositionNumber = [[boxScoreDictionary valueForKey:@"opponentbattingpositionnumber"]intValue]-1;
        NSLog(@"I AM NOT BATTING: %i",batterPositionNumber);
        NSLog(@"CURRENT BATTER: %@",[[opponentTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:batterPositionNumber]);
        
    }
    
    myTeamCount = (int)[myTeamDictionaryArray count];
    opponentTeamCount = (int)[opponentTeamDictionaryArray count];
    
    if (amIBatting){
        if (!isContinousLineup) {
            NSLog(@"Game does NOT have a continous lineup");
            if (myTeamCount > 9) {
                myTeamCount = 9;
            }
        }
        if (batterPositionNumber >=  myTeamCount){
            batterPositionNumber = 0;
        };
        if (batterPositionNumber < 0){
            batterPositionNumber = 0;
        };
        
        NSLog(@"if batting:no:batterPositionNumber: %i",batterPositionNumber);
        
        
    }else{
        if (!isContinousLineup) {
            NSLog(@"Game does NOT have a continous lineup");
            if (opponentTeamCount > 9) {
                opponentTeamCount = 9;
            }
        }
        
        if (batterPositionNumber >=  opponentTeamCount){
            batterPositionNumber = 0;
        };
        
        if (batterPositionNumber < 0){
            batterPositionNumber = 0;
        };
        
        NSLog(@"if batting:no:batterPositionNumber: %i",batterPositionNumber);
        
    }
    [self showPitchCount];
    
    
    
    if (amIBatting){
        
        currentBatLabel.text = [[myTeamDictionaryArray valueForKey:@"playerbat"]objectAtIndex:batterPositionNumber];
        NSLog(@"batting");
        
        currentBatterLabel.text = [[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:batterPositionNumber];
        
        currentPlayerNumberLabel.text = [[myTeamDictionaryArray valueForKey:@"playernumber"] objectAtIndex:batterPositionNumber];
        NSLog(@"battername: %@",[[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:batterPositionNumber]);
        
    }else{
        NSLog(@"NOT batting");
        
        currentBatLabel.text = [[opponentTeamDictionaryArray valueForKey:@"playerbat"]objectAtIndex:batterPositionNumber];
        
        currentBatterLabel.text = [[opponentTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:batterPositionNumber];
        
        currentPlayerNumberLabel.text = [[opponentTeamDictionaryArray valueForKey:@"playernumber"] objectAtIndex:batterPositionNumber];
        NSLog(@"battername: %@",[[opponentTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:batterPositionNumber]);
        
    }
    
    currentOutLabel.text = [NSString stringWithFormat:@"%i",currentOuts];
        //testing
    [self setGamePitchersIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (IBAction)stepper:(id)sender {
    UIStepper *step = (UIStepper *) sender;
    
    step.maximumValue = 99;
    step.minimumValue = 0;
    if (amIBatting){
        
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
        
    }
    
    if (!amIBatting) {
        
        
        if (isHomeTeam) {
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
    
    [self addToBoxScoreDictionary];
}

- (IBAction)onClick:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    switch (button.tag) {
        case 0:
                // 1B - HOME
            NSLog(@"1B");
            currentPitchCount ++;
            singleHit ++;
            totalBallsThrown++;
            
            if (amIBatting){
                    //HOME
                    //Hitting
                
                [self addMySingle];
                
            }else{
                    //OPPONENT
                    //HITTER UPDATE:
                
                [self addOpponentSingle];
                
            }
            
            [self addStrike];
            
            [self currentBatter];

            [self scoreboardHits];
            
                //see the pitch position
            NSLog(@"pitch location: %@",pitchLocationArray);
            
            [self showPitchCount];
            
            [self showPitchStrike];
            
            [self addToBoxScoreDictionary];
            
            [self saveBoxScore];
            
            didHit = YES;
            
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            break;
            
        case 1:
                //2B
            NSLog(@"2B");
            currentPitchCount ++;
            doubleHit ++;
            totalBallsThrown ++;
            
            if (amIBatting){
                    //HOME
                NSLog(@"isHomeTeam:yes");

                [self addMyDouble];
                
            }else{
                    //OPPONENT BATTING
                NSLog(@"is Hometeam:NO");
                
                [self addOpponentDouble];

            }
            
            [self addStrike];
            
            [self currentBatter];
            
            [self scoreboardHits];
            
                //see the pitch position
            NSLog(@"pitch location: %@",pitchLocationArray);
            
            [self showPitchCount];
            
            [self showPitchStrike];
            
            [self addToBoxScoreDictionary];
            
            [self saveBoxScore];
            
            didHit = YES;
            
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            break;
            
        case 2:
                // 3B
            NSLog(@"3B");
            currentPitchCount ++;
            tripleHit ++;
            totalBallsThrown ++;
            
            if (amIBatting){
                    //HOME
                
                [self addMyTriple];
                
            }else{
                    //OPPONENT
                NSLog(@"isHomeTeam:no");
                
                [self addOpponentTriple];
                
            }
            
            [self addStrike];
            
            [self currentBatter];
            
            [self scoreboardHits];
            
                //see the pitch position
            NSLog(@"pitch location: %@",pitchLocationArray);
            
            [self showPitchCount];
            
            [self showPitchStrike];
            
            [self addToBoxScoreDictionary];
            
            [self saveBoxScore];
            
            didHit = YES;
            
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            break;
            
        case 3:
                //HR
            NSLog(@"HR");
            currentPitchCount++;
            homeRun ++;
            totalBallsThrown ++;
            
            if (amIBatting){
                    //HOME
                NSLog(@"isHomeTeam:yes");
                [self addMyHR];
                
            }else{
                    //OPPONENT
                NSLog(@"isHomeTeam:no");
                
                [self addOpponentHR];
                
            }
            [self addStrike];
            
            [self currentBatter];
            
            [self scoreboardHits];
            
                //see the pitch position
            NSLog(@"pitch location: %@",pitchLocationArray);
            
            [self showPitchCount];
            
            [self showPitchStrike];
            
            [self addToBoxScoreDictionary];
            
            [self saveBoxScore];
            
            didHit = YES;
            
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            break;
            
        case 4:
                // FC
            NSLog(@"FC");
            currentPitchCount++;
            fieldersChoice ++;
            totalBallsThrown ++;
            
            if (amIBatting){
                    //HOME
                NSLog(@"isHomeTeam:yes");
                [self addMyFC];

            }else{
                    //OPPONENT
                NSLog(@"no");
                
                [self addOpponentFC];
                
            }
            
            [self addStrike];
            
            [self currentBatter];
            
            [self scoreboardHits];
            
                //see the pitch position
            NSLog(@"pitch location: %@",pitchLocationArray);
            
            [self showPitchCount];
            
            [self showPitchStrike];
            
            [self addToBoxScoreDictionary];
            
            [self saveBoxScore];
            
            didHit = YES;
            
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            break;
            
        case 5:
                //E
            NSLog(@"E");
            currentPitchCount++;
            fieldingError ++;
            
            if (amIBatting){
                    //HOME
                NSLog(@"isHomeTeam:yes");
                [self addMyError];
                
            }else{
                    //OPPONENT
                NSLog(@"no");
                
                [self addOpponentError];
                
                
            }
            [self addStrike];
            
            [self currentBatter];
            
            [self scoreboardHits];
            
                //see the pitch position
            NSLog(@"pitch location: %@",pitchLocationArray);
            
            [self showPitchCount];
            
            [self showPitchStrike];
            
            [self addToBoxScoreDictionary];
            
            [self saveBoxScore];
            
            didHit = YES;
            
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            break;
            
        case 6:
                // OUT
            NSLog(@"OUT");
            currentOuts ++;
            
            if (amIBatting){
                    //HOME
                NSLog(@"isHomeTeam:yes");
                myOut++;
                [self addMyOut];
                [self addStrike];
            }else{
                    //OPPONENT
                NSLog(@"no");
                opponentOut++;
                
                [self addOpponentOut];
                [self addStrike];
            }
            
            if (currentOuts > 2) {
                if (isTopOfInning) {
                    isTopOfInning = NO;
                    
                }else{
                    isTopOfInning = YES;
                    currentInning++;
                }
                currentOuts = 0;
                if (amIBatting){
                    amIBatting= NO;
                }else{
                    amIBatting= YES;
                }
            }
            
            [self showPitchCount];
            [self showPitchStrike];
            
            
            loadedMyTeamCurrentBatter ++;
            [self addToBoxScoreDictionary];
            NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
            
            [self saveBoxScore];
            
            didHit = YES;
            
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            
            break;
            
        case 7:
                // HP
            NSLog(@"HP");
            currentPitchCount ++;
            hitByPitch ++;
            totalBallsThrown ++;
            
            if (amIBatting){
                    //HOME
                NSLog(@"isHomeTeam:yes");
                [self addMyHP];
                
                [self showPitchCount];
                [self showPitchStrike];
                
                loadedMyTeamCurrentBatter ++;
                [self addToBoxScoreDictionary];
                NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
                
                [self saveBoxScore];
                [self addBall];
                
            }else{
                    //OPPONENT
                NSLog(@"no");
                
                [self addOpponentHP];
                [self showPitchCount];
                [self showPitchStrike];
                
                loadedOpponentCurrentBatter ++;
                [self addToBoxScoreDictionary];
                NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
                
                [self saveBoxScore];
                [self addBall];
                [self viewDidLoad];
                
                
            }
            
                //see the pitch position
            NSLog(@"pitch location: %@",pitchLocationArray);
            
            [self showPitchCount];
            [self showPitchStrike];
            
                //LAST
            NSLog(@"pre-batterpositionnumber %i",batterPositionNumber);
            NSLog(@"boxScoreDict %@",boxScoreDictionary);
            
            batterPositionNumber ++;
            NSLog(@"post-batterpositionnumber %i",batterPositionNumber);
            
            [self addToBoxScoreDictionary];
            NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
            
            [self saveBoxScore];
            
            [self viewDidLoad];
            break;
            
        case 8:
                //SAC
            NSLog(@"SAC");
            currentPitchCount ++;
            sacFly ++;
            myOut ++;
            if (amIBatting){
                    //HOME
                NSLog(@"isHomeTeam:yes");
                [self addMySac];
                
                if ([self DoesMyTeamFileExist]) {
                    [self removeTeamDictionaryFile];
                    [self saveUpdatedMyTeamInfo];
                }
                
                [self showPitchCount];
                [self showPitchStrike];
                
                batterPositionNumber ++;
                [self addToBoxScoreDictionary];
                NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
                
                [self saveBoxScore];
                [self addStrike];
                
                
                
            }else{
                    //OPPONENT
                NSLog(@"no");
                
                [self addOpponentSac];
                
                if ([self DoesMyTeamFileExist]) {
                    [self removeTeamDictionaryFile];
                    [self saveUpdatedMyTeamInfo];
                    
                }
                
            }
            
            [self showPitchCount];
            [self showPitchStrike];
            
            batterPositionNumber ++;
            [self addToBoxScoreDictionary];
            NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
            
            [self saveBoxScore];
            [self addStrike];
            
            didHit = YES;
            
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            break;
            
        case 9:
                // BALL
            NSLog(@"BALL");
            NSLog(@"batterPositionNumber: %i",batterPositionNumber);
            currentBatterBall ++;
            currentPitchCount ++;
            totalBallsThrown ++;
            
            [self addBall];
            
            if (currentBatterBall > 3) {
                
                batterPositionNumber ++;
                currentBatterBall = 0;
            }
            
            batterPositionNumber ++;
            NSLog(@"batterPositionNumber: %i",batterPositionNumber);
            
            [self addToBoxScoreDictionary];
            NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
            
            [self saveBoxScore];
            
            [self showPitchCount];
            [self showPitchBall];
            [self viewDidLoad];
            
            break;
            
        case 10:
                //STRIKE
                // ***********verify
            NSLog(@"STRIKE");
            currentBatterStrike ++;
            totalStrikesThrown ++;
            currentPitchCount ++;
            
            [self addStrike];
            if (currentBatterStrike > 2) {
                
                currentOuts ++;
                currentBatterStrike = 0;
                batterPositionNumber ++;
                
                if (currentOuts >=3) {
                    if (isTopOfInning) {
                        isTopOfInning = NO;
                    }else{
                        isTopOfInning = YES;
                    }
                }
                
                [self addToBoxScoreDictionary];
                [self saveBoxScore];
                
            }
            [self showPitchCount];
            [self showPitchStrike];
            
            [self viewDidLoad];
            
            break;
            
        case 11:
                //start the game timer;
            [self gameTimeStart];
            if (!isTimerStarted) {
                [button setTitle:@"Stop Game Timer" forState:UIControlStateNormal];

            }else{
                [button setTitle:@"Start Game Timer" forState:UIControlStateNormal];
            }
            break;
            
        default:
            break;
    }
}

- (void)addStrike{
        //add strike to pitcher
    
    if (amIBatting){
            //opponent team
        
        [self setOpponentTeamPitcherArray];
            //add to loaded
        int t1 = [st intValue];
        t1++;
        strValue = [@(t1) stringValue];
        
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
                    strValue,@"strikesthrown",
                    hc,@"hittingchart",
                    pc,@"pitchingchart",
                    wap,@"walkspitched",
                    strp,@"strikesoutpitched",
                    nil];
        
            //write back file
        [opponentTeamDictionaryArray replaceObjectAtIndex:opponentPitcherIndex withObject:tempdict];
        NSLog(@"opponentTeamDictArr: %@",opponentTeamDictionaryArray);
        
        [self saveUpdatedOpponentTeamInfo];
        
        
    }else{
            //my team
        NSLog(@"MyTeam DictionaryArray %@",myTeamDictionaryArray);
        
        int t1 = [st intValue];
        t1++;
        strValue = [@(t1) stringValue];
        
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
                    strValue,@"strikesthrown",
                    hc,@"hittingchart",
                    pc,@"pitchingchart",
                    wap,@"walkspitched",
                    strp,@"strikesoutpitched",
                    nil];
        
        [myTeamDictionaryArray replaceObjectAtIndex:opponentPitcherIndex withObject:tempdict];
        [self saveUpdatedMyTeamInfo];
        
    }
}

- (void)addBall{
        //add BALL to pitcher
    
    if (amIBatting){
            //opponent team
        NSLog(@"opponentTeamDictArray %@",opponentTeamDictionaryArray);
            //add to loaded
        [self setOpponentTeamPitcherArray];
        int t1 = [bt intValue];
        t1++;
        strValue = [@(t1) stringValue];
        
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
                    strValue,@"ballspitched",
                    st,@"strikesthrown",
                    wa,@"walks",
                    str,@"strikeouts",
                    wap,@"walkspitched",
                    strp,@"strikesoutpitched",
                    pc,@"pitchingchart",
                    hc,@"hittingchart",
                    nil];
        
        NSLog(@"temp: \n %@",tempdict);
            //write back file
        [opponentTeamDictionaryArray replaceObjectAtIndex:opponentPitcherIndex withObject:tempdict];
        NSLog(@"opponentTeamDictArr: %@",opponentTeamDictionaryArray);
        
        [self saveUpdatedOpponentTeamInfo];
        
        
    }else{
            //opponent batting
            //        [self LoadMyTeam];
        [self setMyTeamPitcherArray];
        NSLog(@"myteamdictionaryarray: %@",myTeamDictionaryArray);
        
        int t1 = [bt intValue];
        t1++;
        strValue = [@(t1) stringValue];
        
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
                    strValue,@"ballspitched",
                    st,@"strikesthrown",
                    hc,@"hittingchart",
                    pc,@"pitchingchart",
                    wa,@"walks",
                    str,@"strikeouts",
                    wap,@"walkspitched",
                    strp,@"strikeoutspitched",
                    
                    nil];
        
        [myTeamDictionaryArray replaceObjectAtIndex:myPitcherIndex withObject:tempdict];
        NSLog(@"myteamdictionaryarray updated:\n %@",myTeamDictionaryArray);
        [self saveUpdatedMyTeamInfo];
    }
}

- (void)showPitchCount{
    currentPitchCountLabel.text = [NSString stringWithFormat:@"%i",currentPitchCount];
    
}

- (void)showPitchStrike{
    currentStrikeLabel.text = [NSString stringWithFormat:@"%i",currentBatterStrike];
    
}


- (void)showPitchBall{
    currentBallsLabel.text = [NSString stringWithFormat:@"%i",currentBatterBall];
    
}

#pragma mark - segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"hcSegue"])
        
    { HittingChartViewController *vc = [segue destinationViewController];
        vc.didHit = didHit;
    }
}

#pragma mark - Load Files

- (void)LoadMyTeam{
    NSLog(@"LoadMyTeamFromFile");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"teamdictionary.out"];
    
    myTeamDictionaryArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    /*fn = [myTeamDictionaryArray valueForKey:@"firstname"];
     ln = [myTeamDictionaryArray valueForKey:@"lastname"];
     pn = [myTeamDictionaryArray valueForKey:@"playernumber"];
     pb = [myTeamDictionaryArray valueForKey:@"playerbat"];
     pt = [myTeamDictionaryArray valueForKey:@"playerthrow"];
     pi = [myTeamDictionaryArray valueForKey:@"pitcher"];
     fb = [myTeamDictionaryArray valueForKey:@"1B"];
     sb = [myTeamDictionaryArray valueForKey:@"2B"];
     tb = [myTeamDictionaryArray valueForKey:@"3B"];
     hr = [myTeamDictionaryArray valueForKey:@"HR"];
     fc = [myTeamDictionaryArray valueForKey:@"fielderschoice"];
     fe = [myTeamDictionaryArray valueForKey:@"fieldingerror"];
     hp = [myTeamDictionaryArray valueForKey:@"hitbypitch"];
     sf = [myTeamDictionaryArray valueForKey:@"sacfly"];
     rb = [myTeamDictionaryArray valueForKey:@"RBI"];
     ou = [myTeamDictionaryArray valueForKey:@"out"];
     bt = [myTeamDictionaryArray valueForKey:@"ballspitched"];
     st = [myTeamDictionaryArray valueForKey:@"strikesthrown"];
     hc = [myTeamDictionaryArray valueForKey:@"hittingchart"];
     pc = [myTeamDictionaryArray valueForKey:@"pitchingchart"];
     wa = [myTeamDictionaryArray valueForKey:@"walks"];
     str = [myTeamDictionaryArray valueForKey:@"strikeouts"];
     wap = [myTeamDictionaryArray valueForKey:@"walkspitched"];
     strp = [myTeamDictionaryArray valueForKey:@"strikeoutspitched"];
     */
    NSLog(@"myTeamDictionaryArray %@",myTeamDictionaryArray);
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
    NSLog(@"loadOppTeam from boxscore: %@",[boxScoreDictionary valueForKey:@"opponentbattingpositionnumber"]);
    
}

-(void)LoadBoxScore{
    NSLog(@"LoadBoxScore");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"boxscore.out"];
    
    boxScoreDictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
        //load variables
    
    NSNumber *b = [boxScoreDictionary valueForKey:@"amibatting"];
    amIBatting= [b boolValue];
    
    isTopOfInning = [(NSNumber*)[boxScoreDictionary valueForKey:@"istopofinning"]boolValue];
    
    NSLog(@"LoadBoxScore finished");
    
    currentPitchCount = [[boxScoreDictionary valueForKey:@"pitchcount"]intValue];
    
    currentOuts = [[boxScoreDictionary valueForKey:@"currentouts"]intValue];
    
    homeRuns = [[boxScoreDictionary valueForKey:@"homeruns"]intValue];
    
    homeHits = [[boxScoreDictionary valueForKey:@"homehits"]intValue];
    
    homeErrors = [[boxScoreDictionary valueForKey:@"homeerrors"]intValue];
    
    visitorRuns = [[boxScoreDictionary valueForKey:@"visitorruns"]intValue];
    
    visitorHits = [[boxScoreDictionary valueForKey:@"visitorhits"]intValue];
    
    visitorErrors = [[boxScoreDictionary valueForKey:@"visitorerrors"]intValue];
    
    loadedMyTeamPos =[[boxScoreDictionary valueForKey:@"myteambattingpositionnumber"]intValue];
    
    loadedOppPos = [[boxScoreDictionary valueForKey:@"opponentbattingpositionnumber"]intValue];
    
    currentInning = [[boxScoreDictionary valueForKey:@"currentinning"]intValue];
    
}

- (void)LoadGameVariables{
    NSLog(@"************LoadGameVariables");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"gamevariables.out"];
    NSDictionary *load = [NSDictionary dictionaryWithContentsOfFile:filePath];
    inningNumber = [[load valueForKey:@"currentinning"]intValue];
    isTopOfInning = [[load valueForKey:@"topofinning"]boolValue];
    
    NSLog(@"inningNumber: %d",inningNumber);
    
}

- (void)LoadGameDefaults{
    NSLog(@"***********LoadGameDefaultsFromFile");
    isDefaultsLoaded = YES;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"gamedefaults.out"];
    if (filePath != nil) {
        NSDictionary *load = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        isContinousLineup = [[load valueForKey:@"continouslineup"]boolValue];
        gameTimeLimit = [[load valueForKey:@"gametimelimit"]intValue];
        isHomeTeam = [[load valueForKey:@"hometeam"]boolValue];
        maxNumberOfPitches = [[load valueForKey:@"maxnumberofpitches"]intValue];
        isTrackPitchCount = [[load valueForKey:@"trackpitchcount"]boolValue];
        
        NSLog(@"pause");
    }else{
        NSLog(@"No file.");
    }
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
    wap = [[opponentTeamDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:batterPositionNumber];
    strp = [[opponentTeamDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:batterPositionNumber];
    pc = [[opponentTeamDictionaryArray valueForKey:@"pitchingchart"]objectAtIndex:batterPositionNumber];
    hc = [[opponentTeamDictionaryArray valueForKey:@"hittingchart"]objectAtIndex:batterPositionNumber];
    
    NSLog(@"end of loadOpponentTeamDictionaryArray: %@",opponentTeamDictionaryArray);
    
}

- (void)loadMyTeamDictionaryArray{
    
        //load
    fb = [[myTeamDictionaryArray valueForKey:@"1B"]objectAtIndex:batterPositionNumber];
    sb = [[myTeamDictionaryArray valueForKey:@"2B"]objectAtIndex:batterPositionNumber];
    tb = [[myTeamDictionaryArray valueForKey:@"3B"]objectAtIndex:batterPositionNumber];
    hr = [[myTeamDictionaryArray valueForKey:@"HR"]objectAtIndex:batterPositionNumber];
    fc = [[myTeamDictionaryArray valueForKey:@"fielderschoice"]objectAtIndex:batterPositionNumber];
    fe = [[myTeamDictionaryArray valueForKey:@"fieldingerror"]objectAtIndex:batterPositionNumber];
    hp = [[myTeamDictionaryArray valueForKey:@"hitbypitch"]objectAtIndex:batterPositionNumber];
    sf = [[myTeamDictionaryArray valueForKey:@"sacfly"]objectAtIndex:batterPositionNumber];
    rb = [[myTeamDictionaryArray valueForKey:@"RBI"]objectAtIndex:batterPositionNumber];
    ou = [[myTeamDictionaryArray valueForKey:@"out"]objectAtIndex:batterPositionNumber];
    bt = [[myTeamDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:batterPositionNumber];
    st = [[myTeamDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:batterPositionNumber];
    fn = [[myTeamDictionaryArray valueForKey:@"firstname"]objectAtIndex:batterPositionNumber];
    ln = [[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:batterPositionNumber];
    pn = [[myTeamDictionaryArray valueForKey:@"playernumber"]objectAtIndex:batterPositionNumber];
    pb = [[myTeamDictionaryArray valueForKey:@"playerbat"]objectAtIndex:batterPositionNumber];
    pt = [[myTeamDictionaryArray valueForKey:@"playerthrow"]objectAtIndex:batterPositionNumber];
    pi = [[myTeamDictionaryArray valueForKey:@"pitcher"]objectAtIndex:batterPositionNumber];
    wap = [[myTeamDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:batterPositionNumber];
    strp = [[myTeamDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:batterPositionNumber];
    pc = [[myTeamDictionaryArray valueForKey:@"pitchingchart"]objectAtIndex:batterPositionNumber];
    hc = [[myTeamDictionaryArray valueForKey:@"hittingchart"]objectAtIndex:batterPositionNumber];
    
    NSLog(@"end of loadMyTeamDictionaryArray: %@",myTeamDictionaryArray);
    
}

- (void)setMyTeamPitcherArray{
    
        //load
    fb = [[myTeamDictionaryArray valueForKey:@"1B"]objectAtIndex:myPitcherIndex];
    sb = [[myTeamDictionaryArray valueForKey:@"2B"]objectAtIndex:myPitcherIndex];
    tb = [[myTeamDictionaryArray valueForKey:@"3B"]objectAtIndex:myPitcherIndex];
    hr = [[myTeamDictionaryArray valueForKey:@"HR"]objectAtIndex:myPitcherIndex];
    fc = [[myTeamDictionaryArray valueForKey:@"fielderschoice"]objectAtIndex:myPitcherIndex];
    fe = [[myTeamDictionaryArray valueForKey:@"fieldingerror"]objectAtIndex:myPitcherIndex];
    hp = [[myTeamDictionaryArray valueForKey:@"hitbypitch"]objectAtIndex:myPitcherIndex];
    sf = [[myTeamDictionaryArray valueForKey:@"sacfly"]objectAtIndex:myPitcherIndex];
    rb = [[myTeamDictionaryArray valueForKey:@"RBI"]objectAtIndex:myPitcherIndex];
    ou = [[myTeamDictionaryArray valueForKey:@"out"]objectAtIndex:myPitcherIndex];
    bt = [[myTeamDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:myPitcherIndex];
    st = [[myTeamDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:myPitcherIndex];
    fn = [[myTeamDictionaryArray valueForKey:@"firstname"]objectAtIndex:myPitcherIndex];
    ln = [[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:myPitcherIndex];
    pn = [[myTeamDictionaryArray valueForKey:@"playernumber"]objectAtIndex:myPitcherIndex];
    pb = [[myTeamDictionaryArray valueForKey:@"playerbat"]objectAtIndex:myPitcherIndex];
    pt = [[myTeamDictionaryArray valueForKey:@"playerthrow"]objectAtIndex:myPitcherIndex];
    pi = [[myTeamDictionaryArray valueForKey:@"pitcher"]objectAtIndex:myPitcherIndex];
    wap = [[myTeamDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:myPitcherIndex];
    strp = [[myTeamDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:myPitcherIndex];
    pc = [[myTeamDictionaryArray valueForKey:@"pitchingchart"]objectAtIndex:myPitcherIndex];
    hc = [[myTeamDictionaryArray valueForKey:@"hittingchart"]objectAtIndex:myPitcherIndex];
    
    NSLog(@"end of loadMyTeamDictionaryArray: %@",myTeamDictionaryArray);
    
}

- (void)setOpponentTeamPitcherArray{
    
        //load
    fb = [[opponentTeamDictionaryArray valueForKey:@"1B"]objectAtIndex:opponentPitcherIndex];
    sb = [[opponentTeamDictionaryArray valueForKey:@"2B"]objectAtIndex:opponentPitcherIndex];
    tb = [[opponentTeamDictionaryArray valueForKey:@"3B"]objectAtIndex:opponentPitcherIndex];
    hr = [[opponentTeamDictionaryArray valueForKey:@"HR"]objectAtIndex:opponentPitcherIndex];
    fc = [[opponentTeamDictionaryArray valueForKey:@"fielderschoice"]objectAtIndex:opponentPitcherIndex];
    fe = [[opponentTeamDictionaryArray valueForKey:@"fieldingerror"]objectAtIndex:opponentPitcherIndex];
    hp = [[opponentTeamDictionaryArray valueForKey:@"hitbypitch"]objectAtIndex:opponentPitcherIndex];
    sf = [[opponentTeamDictionaryArray valueForKey:@"sacfly"]objectAtIndex:opponentPitcherIndex];
    rb = [[opponentTeamDictionaryArray valueForKey:@"RBI"]objectAtIndex:opponentPitcherIndex];
    ou = [[opponentTeamDictionaryArray valueForKey:@"out"]objectAtIndex:opponentPitcherIndex];
    bt = [[opponentTeamDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:opponentPitcherIndex];
    st = [[opponentTeamDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:opponentPitcherIndex];
    fn = [[opponentTeamDictionaryArray valueForKey:@"firstname"]objectAtIndex:opponentPitcherIndex];
    ln = [[opponentTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:opponentPitcherIndex];
    pn = [[opponentTeamDictionaryArray valueForKey:@"playernumber"]objectAtIndex:opponentPitcherIndex];
    pb = [[opponentTeamDictionaryArray valueForKey:@"playerbat"]objectAtIndex:opponentPitcherIndex];
    pt = [[opponentTeamDictionaryArray valueForKey:@"playerthrow"]objectAtIndex:opponentPitcherIndex];
    pi = [[opponentTeamDictionaryArray valueForKey:@"pitcher"]objectAtIndex:opponentPitcherIndex];
    wap = [[opponentTeamDictionaryArray valueForKey:@"ballspitched"]objectAtIndex:opponentPitcherIndex];
    strp = [[opponentTeamDictionaryArray valueForKey:@"strikesthrown"]objectAtIndex:opponentPitcherIndex];
    pc = [[opponentTeamDictionaryArray valueForKey:@"pitchingchart"]objectAtIndex:opponentPitcherIndex];
    hc = [[opponentTeamDictionaryArray valueForKey:@"hittingchart"]objectAtIndex:opponentPitcherIndex];
    
    NSLog(@"end of eamDictionaryArray: %@",opponentTeamDictionaryArray);
    
}

#pragma mark - Misc Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *myTouch = [[touches allObjects] objectAtIndex: 0];
    CGPoint currentPos = [myTouch locationInView: nil];
    NSLog(@"Point in myView: (%f,%f)", currentPos.x, currentPos.y);
    if (currentPos.x >= 210 && currentPos.x <= 457) {
        if (currentPos.y >= 10 && currentPos.y <= 256) {
            UIImageView *bbView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baseballSmall"]] ;
                // SAVE THE HIT COORDS & CURRENT BATTER
            float xP = currentPos.x;
            float yP = currentPos.y;
            xPos = [NSNumber numberWithFloat:xP];
            yPos = [NSNumber numberWithFloat:yP];
            
            pitchLocationArray = [NSArray arrayWithObjects:
                                  xPos,yPos,nil];
            
                //addto main chart
            [currentPitchingChart addObject:pitchLocationArray];
            
            NSLog(@"hitLocation %@",currentPitchingChart);
            
            [bbView setCenter:CGPointMake(currentPos.x, currentPos.y)]; // x, y
            [self.view addSubview:bbView];
            
        }
    }
    
}

- (void)getCurrentTime{
    
    NSLog(@"gameTimeLimit: %d",gameTimeLimit);
    if (gameTimeLimit > 0) {
        endingTime = [gameTimeStart dateByAddingTimeInterval:gameTimeLimit*60];
        NSLog(@"endingTime = %@",endingTime);
        
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:endingTime]);
    
    
}

- (void)gameTimeStart{
    if (!isGameStarted) {
        gameTimeStart = [NSDate date];
        [self getCurrentTime];
        isGameStarted = TRUE;
        
    }else{
            //current time = > endingTime
        
        NSDate *ct = [NSDate date];
        
        if (ct >= endingTime) {
            NSLog(@"game time is over.");
            self.view.backgroundColor = [UIColor redColor];
            
        }else{
            NSLog(@"game time is NOT over.");
            
        }
        
        
    }
    
}

- (void)showMyRosterAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My Team Roster"
                                                    message:@"Missing"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)showOpponentRosterAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opponent Team Roster"
                                                    message:@"Missing"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)setGamePitchersIndex{
    NSPredicate *cp = [NSPredicate predicateWithFormat:@"pitcher = true"];
    myPitcherArray = [myTeamDictionaryArray filteredArrayUsingPredicate:cp];
    
    if (myPitcherArray.count > 0) {
        id item = [myPitcherArray objectAtIndex:0];
        myPitcherIndex = [myTeamDictionaryArray indexOfObject:item];
        NSLog(@"my pitcher filter %@",[myTeamDictionaryArray objectAtIndex:myPitcherIndex]);
    }
    
    NSPredicate *cp1 = [NSPredicate predicateWithFormat:@"pitcher = true"];
    opponentPitcherArray = [opponentTeamDictionaryArray filteredArrayUsingPredicate:cp1];
    if (opponentPitcherArray.count > 0) {
        id item2 = [opponentPitcherArray objectAtIndex:0];
        opponentPitcherIndex = [opponentPitcherArray indexOfObject:item2];
        NSLog(@"opponent filter %@",[opponentTeamDictionaryArray objectAtIndex:opponentPitcherIndex]);
    }
    
}

- (void)checkPitchCount{
    if (currentPitchCount >= maxNumberOfPitches) {
        NSLog(@"Max pitches HAVE BEEN REACHED");
        if (amIBatting){
            NSString *pitcher = [[opponentTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:opponentPitcherIndex];
            NSLog(@"opponent pitcher reached max pitches: %@",pitcher);
        }else{
            NSString *pitcher = [[myTeamDictionaryArray valueForKey:@"lastname"]objectAtIndex:myPitcherIndex];
            NSLog(@"opponent pitcher reached max pitches: %@",pitcher);
            
        }
    }
}

- (void)currentBatter {


    if (amIBatting){
        loadedMyTeamCurrentBatter ++;

        if (loadedMyTeamCurrentBatter > myTeamCount) {
            loadedMyTeamCurrentBatter = 1;
        }
    }else{
        loadedOpponentCurrentBatter ++;
        
        if (loadedOpponentCurrentBatter > opponentTeamCount) {
            loadedOpponentCurrentBatter = 1;
        }
    }

}

- (void)scoreboardHits {
    if (isTopOfInning) {
        visitorHits++;
    }else{
        homeHits++;
    }

}

#pragma mark - Does File Exist

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

#pragma mark - Save Files

-(void)saveBoxScore{
    
        // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        // Path to save dictionary
    dictPath = [[paths objectAtIndex:0]
                stringByAppendingPathComponent:@"boxscore.out"];
    
    if ([paths count] > 0)
    {
        
            // Write dictionary
        [boxScoreDictionary writeToFile:dictPath atomically:YES];
        
    }
}

-(void)saveUpdatedMyTeamInfo{
        // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        // Path to save dictionary
    dictPath = [[paths objectAtIndex:0]
                stringByAppendingPathComponent:@"teamdictionary.out"];
    
    if ([paths count] > 0)
    {
        
            // Write dictionary
        [myTeamDictionaryArray writeToFile:dictPath atomically:YES];
        
    }
    
}

-(void)saveUpdatedOpponentTeamInfo{
    
        // Get path to documents directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        // Path to save dictionary
    dictPath = [[paths objectAtIndex:0]
                stringByAppendingPathComponent:@"opponentteamdictionary.out"];
    
    if ([paths count] > 0)
    {
        
            // Write dictionary
        [opponentTeamDictionaryArray writeToFile:dictPath atomically:YES];
        
    }
    
}

#pragma mark - Remove Files

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

- (void)removeTeamDictionaryFile {
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

- (void)removeOpponentDictionaryFile {
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

#pragma mark - Add Files

- (void)addToBoxScoreDictionary {
    NSLog(@"addToBoxScoreDictionary");
    NSLog(@"batterPositionNumber %i",batterPositionNumber);
    
    if (amIBatting){
            //Myteam
        
        if (loadedMyTeamCurrentBatter > myTeamCount) {
            loadedMyTeamCurrentBatter = 1;
        }
        
        NSLog(@"loadedMyTeamCurrentBatter: %i",loadedMyTeamCurrentBatter);
        
        homeTeam = @(isHomeTeam);
        NSNumber *currentouts = [NSNumber numberWithInt:currentOuts];
        NSNumber *ami = @(amIBatting);
        NSNumber *top = @(isTopOfInning);
        NSNumber *pitc = [NSNumber numberWithInt:currentPitchCount];
        NSNumber *homerun = [NSNumber numberWithInt:homeRuns];
        NSNumber *homehits = [NSNumber numberWithInt:homeHits];
        NSNumber *homeerrors = [NSNumber numberWithInt:homeErrors];
        NSNumber *visitorrun = [NSNumber numberWithInt:visitorRuns];
        NSNumber *visitorhits = [NSNumber numberWithInt:visitorHits];
        NSNumber *visitorerrors = [NSNumber numberWithInt:visitorErrors];
        NSString *position = [NSString stringWithFormat:@"%d",loadedMyTeamCurrentBatter];
        NSNumber *oppPos = [NSNumber numberWithInt:loadedOpponentCurrentBatter];
        NSNumber *inn = [NSNumber numberWithInt:currentInning];
        
        boxScoreDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              homerun,@"homeruns",
                              homehits,@"homehits",
                              homeerrors,@"homeerrors",
                              visitorrun,@"visitorruns",
                              visitorhits,@"visitorhits",
                              visitorerrors,@"visitorerrors",
                              pitc,@"pitchcount",
                              currentouts,@"currentouts",
                              homeTeam,@"ishometeam",
                              ami,@"amibatting",
                              top,@"istopofinning",
                              position,@"myteambattingpositionnumber",
                              oppPos,@"opponentbattingpositionnumber",
                              inn,@"currentinning",
                              
                              nil];
        
        NSLog(@"boxScoreDictionary: %@",boxScoreDictionary);
        
        
    }else{
            //Opponent
        
        if (loadedOpponentCurrentBatter > opponentTeamCount) {
            batterPositionNumber = 1;
        }
        
        NSLog(@"loadedOpponentCurrentBatter: %i",loadedOpponentCurrentBatter);
        
        homeTeam = @(isHomeTeam);
        NSNumber *currentouts = [NSNumber numberWithInt:currentOuts];
        NSNumber *ami = @(amIBatting);
        NSNumber *top = @(isTopOfInning);
        NSNumber *pitc = [NSNumber numberWithInt:currentPitchCount];
        NSNumber *homerun = [NSNumber numberWithInt:homeRuns];
        NSNumber *homehits = [NSNumber numberWithInt:homeHits];
        NSNumber *homeerrors = [NSNumber numberWithInt:homeErrors];
        NSNumber *visitorrun = [NSNumber numberWithInt:visitorRuns];
        NSNumber *visitorhits = [NSNumber numberWithInt:visitorHits];
        NSNumber *visitorerrors = [NSNumber numberWithInt:visitorErrors];
        
        NSString *position = [NSString stringWithFormat:@"%d",loadedOpponentCurrentBatter];
        NSNumber *myPos = [NSNumber numberWithInt:loadedMyTeamCurrentBatter];
        
        NSNumber *inn = [NSNumber numberWithInt:currentInning];
        
        boxScoreDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              homerun,@"homeruns",
                              homehits,@"homehits",
                              homeerrors,@"homeerrors",
                              visitorrun,@"visitorruns",
                              visitorhits,@"visitorhits",
                              visitorerrors,@"visitorerrors",
                              pitc,@"pitchcount",
                              currentouts,@"currentouts",
                              homeTeam,@"ishometeam",
                              ami,@"amibatting",
                              top,@"istopofinning",
                              myPos,@"myteambattingpositionnumber",
                              position,@"opponentbattingpositionnumber",
                              inn,@"currentinning",
                              
                              nil];
        
        NSLog(@"boxScoreDictionary: %@",boxScoreDictionary);
        
    }
    
    if ([self DoesBoxScoreExist]) {
        NSLog(@"DoesBoxScoreExist = YES");
    }
        //    [self removeBoxScore];
    
}

#pragma mark - Add My Batting

- (void)addMyWalks{
    NSLog(@"addMyWalks");
    
    [self loadMyTeamDictionaryArray];
    
    
    int t1 = [wa intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                hc,@"hittingchart",
                pc,@"pitchingchart",
                strValue,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
}

- (void)addMyStrikeOut{
    NSLog(@"addStrikeOut");
    
    [self loadMyTeamDictionaryArray];
    
    
    int t1 = [str intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                strValue,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
}

- (void)addMyWalksPitched{
    NSLog(@"addWalksPitched");
    
    [self loadMyTeamDictionaryArray];
    
    int t1 = [wap intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                strValue,@"walkspitched",
                strp,@"strikeoutspitched",
                
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
}

- (void)addMyStrikeOutPitched{
    NSLog(@"addStrikeOutPitched");
    
    [self loadMyTeamDictionaryArray];
    
    
    int t1 = [strp intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strValue,@"strikeoutspitched",
                
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
}

- (void)addMySingle{
    NSLog(@"addSingle");
    
    [self loadMyTeamDictionaryArray];
    
    
    int t1 = [fb intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
    tempdict = [NSDictionary dictionaryWithObjectsAndKeys:
                fn,@"firstname",
                ln,@"lastname",
                pn,@"playernumber",
                pb,@"playerbat",
                pt,@"playerthrow",
                pi,@"pitcher",
                strValue,@"1B",
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
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
        //saveback
    [self saveUpdatedMyTeamInfo];
    
}

- (void)addMyDouble{
    NSLog(@"addDouble");
    
    [self loadMyTeamDictionaryArray];
    
    int t1 = [sb intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
    tempdict = [NSDictionary dictionaryWithObjectsAndKeys:
                fn,@"firstname",
                ln,@"lastname",
                pn,@"playernumber",
                pb,@"playerbat",
                pt,@"playerthrow",
                pi,@"pitcher",
                fb,@"1B",
                strValue,@"2B",
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
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
        //saveback
    [self saveUpdatedMyTeamInfo];
    
}

- (void)addMyTriple{
    NSLog(@"addTriple");
    
    [self loadMyTeamDictionaryArray];
    
    int t1 = [tb intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
    tempdict = [NSDictionary dictionaryWithObjectsAndKeys:
                fn,@"firstname",
                ln,@"lastname",
                pn,@"playernumber",
                pb,@"playerbat",
                pt,@"playerthrow",
                pi,@"pitcher",
                fb,@"1B",
                sb,@"2B",
                strValue,@"3B",
                hr,@"HR",
                fc,@"fielderschoice",
                fe,@"fieldingerror",
                hp,@"hitbypitch",
                sf,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
        //saveback
    [self saveUpdatedMyTeamInfo];
    
}

- (void)addMyHR{
    NSLog(@"addHR");
    
    [self loadMyTeamDictionaryArray];
    
    int t1 = [hr intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                strValue,@"HR",
                fc,@"fielderschoice",
                fe,@"fieldingerror",
                hp,@"hitbypitch",
                sf,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
        //saveback
    [self saveUpdatedMyTeamInfo];
}

- (void)addMyFC{
    NSLog(@"addFC");
    
    [self loadMyTeamDictionaryArray];
    
    int t1 = [fc intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                strValue,@"fielderschoice",
                fe,@"fieldingerror",
                hp,@"hitbypitch",
                sf,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //saveback
    [self saveUpdatedMyTeamInfo];
    
}

- (void)addMyError{
    NSLog(@"addError");
    
    [self loadMyTeamDictionaryArray];
    
    int t1 = [fe intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                strValue,@"fieldingerror",
                hp,@"hitbypitch",
                sf,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //saveback
    [self saveUpdatedMyTeamInfo];
    
}

- (void)addMyOut{
    NSLog(@"addOut");
    
    [self loadMyTeamDictionaryArray];
    
    int t1 = [ou intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                strValue,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
        //saveback
    [self saveUpdatedMyTeamInfo];
    
}

- (void)addMyHP{
    NSLog(@"addHP");
    
    [self loadMyTeamDictionaryArray];
    
    int t1 = [hp intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                strValue,@"hitbypitch",
                sf,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //saveback
    [self saveUpdatedMyTeamInfo];
    
}

- (void)addMySac{
    NSLog(@"addSac");
    
    [self loadMyTeamDictionaryArray];
    
    int t1 = [sf intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                strValue,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //saveback
    [self saveUpdatedMyTeamInfo];
    
}

#pragma mark - Add Opponent Batting

- (void)addOpponentWalksPitched{
    NSLog(@"addOpponentWalksPitched");
    
    [self loadOpponentTeamDictionaryArray];
    
    
    int t1 = [wap intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                strValue,@"walkspitched",
                strp,@"strikeoutspitched",
                
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
    [self saveUpdatedOpponentTeamInfo];
    
}

- (void)addOpponentStrikeOutPitched{
    NSLog(@"addOpponentStrikeOut");
    
    [self loadOpponentTeamDictionaryArray];
    
    int t1 = [str intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                strValue,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
    [self removeOpponentDictionaryFile];
    [self saveUpdatedOpponentTeamInfo];
    
}

- (void)addOpponentWalks{
    NSLog(@"addOpponentWalks");
    
    [self loadOpponentTeamDictionaryArray];
    
    
    int t1 = [wa intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                hc,@"hittingchart",
                pc,@"pitchingchart",
                strValue,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
    [self removeOpponentDictionaryFile];
    [self saveUpdatedOpponentTeamInfo];
    
}

- (void)addOpponentStrikeOut{
    NSLog(@"addOpponentStrikeOut");
    
    [self loadOpponentTeamDictionaryArray];
    
    int t1 = [str intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                strValue,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
}

- (void)addOpponentSingle{
    NSLog(@"addOpponentSingle");
    [self loadOpponentTeamDictionaryArray];
    int t1 = [fb intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
    tempdict = [NSDictionary dictionaryWithObjectsAndKeys:
                fn,@"firstname",
                ln,@"lastname",
                pn,@"playernumber",
                pb,@"playerbat",
                pt,@"playerthrow",
                pi,@"pitcher",
                strValue,@"1B",
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
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    NSLog(@"new opp team dict array %@",opponentTeamDictionaryArray);
    
}

- (void)addOpponentDouble{
    NSLog(@"addOpponentDouble");
    
    [self loadOpponentTeamDictionaryArray];
    
    int t1 = [sb intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
    tempdict = [NSDictionary dictionaryWithObjectsAndKeys:
                fn,@"firstname",
                ln,@"lastname",
                pn,@"playernumber",
                pb,@"playerbat",
                pt,@"playerthrow",
                pi,@"pitcher",
                fb,@"1B",
                strValue,@"2B",
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
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //saveback
    [self saveUpdatedOpponentTeamInfo];
    
}

- (void)addOpponentTriple{
    NSLog(@"addOpponentTriple");
    
    [self loadOpponentTeamDictionaryArray];
    
    int t1 = [tb intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
    tempdict = [NSDictionary dictionaryWithObjectsAndKeys:
                fn,@"firstname",
                ln,@"lastname",
                pn,@"playernumber",
                pb,@"playerbat",
                pt,@"playerthrow",
                pi,@"pitcher",
                fb,@"1B",
                sb,@"2B",
                strValue,@"3B",
                hr,@"HR",
                fc,@"fielderschoice",
                fe,@"fieldingerror",
                hp,@"hitbypitch",
                sf,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
    
        //saveback
    [self saveUpdatedOpponentTeamInfo];
    
}

- (void)addOpponentHR{
    NSLog(@"addOpponentHR");
    
    [self loadOpponentTeamDictionaryArray];
    
    int t1 = [hr intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                strValue,@"HR",
                fc,@"fielderschoice",
                fe,@"fieldingerror",
                hp,@"hitbypitch",
                sf,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //saveback
    [self saveUpdatedOpponentTeamInfo];
    
}

- (void)addOpponentFC{
    NSLog(@"addOpponentFC");
    
    [self loadOpponentTeamDictionaryArray];
    
    int t1 = [fc intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                strValue,@"fielderschoice",
                fe,@"fieldingerror",
                hp,@"hitbypitch",
                sf,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //saveback
    [self saveUpdatedOpponentTeamInfo];
    
}

- (void)addOpponentError{
    NSLog(@"addOpponentError");
    
    [self loadOpponentTeamDictionaryArray];
    
    int t1 = [fe intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                strValue,@"fieldingerror",
                hp,@"hitbypitch",
                sf,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
        //saveback
    [self saveUpdatedOpponentTeamInfo];
    
}

- (void)addOpponentOut{
    NSLog(@"addOpponentOut");
    
    [self loadOpponentTeamDictionaryArray];
    
    int t1 = [ou intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                strValue,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
        //saveback
    [self saveUpdatedOpponentTeamInfo];
    
    
}

- (void)addOpponentHP{
    NSLog(@"addOpponentHP");
    
    [self loadOpponentTeamDictionaryArray];
    
    int t1 = [hp intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                strValue,@"hitbypitch",
                sf,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //saveback
    [self saveUpdatedOpponentTeamInfo];
    
    
}

- (void)addOpponentSac{
    NSLog(@"addOpponentSac");
    
    [self loadOpponentTeamDictionaryArray];
    
    int t1 = [sf intValue];
    t1++;
    strValue = [@(t1) stringValue];
    
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
                strValue,@"sacfly",
                rb,@"RBI",
                ou,@"out",
                bt,@"ballspitched",
                st,@"strikesthrown",
                hc,@"hittingchart",
                pc,@"pitchingchart",
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //saveback
    [self saveUpdatedOpponentTeamInfo];
    
}
@end
