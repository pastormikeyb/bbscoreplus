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
    int loadedHomeR,loadedHomeH,loadedHomeE,loadedVisitorR,loadedVisitorH,loadedVisitorE;
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
    BOOL loadMyPitcher,loadOpponentPitcher;
    NSString *fn, *ln, *pn, *pb, *pt, *pi, *fb, *sb, *tb, *hr, *fc,*fe,*hp,*sf,*rb,*ou,*bt,*st,*wa,*str,*wap,*strp,*strValue,*cb, *pc,*hc, *th, *oh;
    NSUInteger myPitcherIndex, opponentPitcherIndex;
    
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
    
    [self LoadMyTeam];
    [self LoadOpponentTeam];
    [self LoadGameVariables];
    [self LoadGameDefaults];
    if (![self DoesMyTeamFileExist]) {
        NSLog(@"NO team file");
        [self showMyRosterAlert];
    }
    
    if ([self DoesBoxScoreExist]) {
        [self LoadBoxScore];
    }
        //set app main variables
    
    batting = [[boxScoreDictionary valueForKey:@"amibatting"]intValue];
    isHomeTeam = [boxScoreDictionary valueForKey:@"ishometeam"];
    isTopOfInning = [boxScoreDictionary valueForKey:@"istopofinning"];
    loadedMyTeamCurrentBatter = [[boxScoreDictionary valueForKey:@"myteambattingpositionnumber"]intValue];
    loadedOpponentCurrentBatter = [[boxScoreDictionary valueForKey:@"opponentbattingpositionnumber"]intValue];
    currentOuts = [[boxScoreDictionary valueForKey:@"currentouts"]intValue];
    currentInning = [[boxScoreDictionary valueForKey:@"currentinning"]intValue];
    
    
    if (batting) {
        batterPositionNumber = [[boxScoreDictionary valueForKey:@"myteambattingpositionnumber"]intValue]-1;
        NSLog(@"I AM BATTING: %i",batterPositionNumber);
    }else{
        batterPositionNumber = [[boxScoreDictionary valueForKey:@"opponentbattingpositionnumber"]intValue]-1;
        NSLog(@"I AM NOT BATTING: %i",batterPositionNumber);
        
    }
    
    myTeamCount = (int)[myTeamDictionaryArray count];
    opponentTeamCount = (int)[opponentTeamDictionaryArray count];
    
    if (batting) {
        
        if (batterPositionNumber >=  myTeamCount){
            batterPositionNumber = 0;
        };
        if (batterPositionNumber < 0){
            batterPositionNumber = 0;
        };
        
        NSLog(@"if batting:no:batterPositionNumber: %i",batterPositionNumber);
        
        
    }else{
        
        if (batterPositionNumber >=  opponentTeamCount){
            batterPositionNumber = 0;            };
        if (batterPositionNumber < 0){
            batterPositionNumber = 0;            };
        
        NSLog(@"if batting:no:batterPositionNumber: %i",batterPositionNumber);
        
    }
    [self showPitchCount];
    
    
    
    if (batting) {
        
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

- (IBAction)stepper:(id)sender {
    UIStepper *step = (UIStepper *) sender;
    
    step.maximumValue = 99;
    step.minimumValue = 0;
    if (batting) {
        
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
    
    if (!batting) {
        
        
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
            
            if (batting) {
                    //HOME
                NSLog(@"isHomeTeam:yes");
                NSLog(@"pre-batterPositionNumber: %i", batterPositionNumber);
                
                [self addMySingle];
                
                if ([self DoesMyTeamFileExist]) {
                    [self removeTeamDictionaryFile];
                    [self saveUpdatedMyTeamInfo];
                    
                }
                
                if (isTopOfInning) {
                    visitorHits++;
                }else{
                    homeHits++;
                }
                [self showPitchCount];
                [self showPitchStrike];
                
                NSLog(@"before update - batter position number: %i ",loadedMyTeamCurrentBatter);
                
                loadedMyTeamCurrentBatter ++;
                
                [self addToBoxScoreDictionary];
                NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
                
                [self saveBoxScore];
                [self addOpponentStrikeThrown];
                
                [self performSegueWithIdentifier:@"hcSegue" sender:nil];
                
            }else{
                    //OPPONENT
                    //HITTER UPDATE:
                NSLog(@"isHomeTeam:no");
                NSLog(@"pre-batterPositionNumber: %i", batterPositionNumber);
                [self addOpponentSingle];
                
                if ([self DoesMyOpponentFileExist]) {
                }
                [self saveUpdatedOpponentTeamInfo];
                
                if (isTopOfInning) {
                    visitorHits++;
                }else{
                    homeHits++;
                }
                [self addMyStrikeThrown];
                
            }
                //see the pitch position
            NSLog(@"pitch location: %@",pitchLocationArray);
            
            [self showPitchCount];
            [self showPitchStrike];
            
            NSLog(@"pre-batterpositionnumber %i",batterPositionNumber);
            NSLog(@"boxScoreDict %@",boxScoreDictionary);
            
            NSLog(@"pre-batterpositionnumber %i",batterPositionNumber);
            
            loadedOpponentCurrentBatter ++;
            NSLog(@"post-batterpositionnumber %i",batterPositionNumber);
            
            
                //PITCHER UPDATE OPPONENT
            
            if (batting) {
                if (loadedMyTeamCurrentBatter > myTeamCount) {
                    loadedMyTeamCurrentBatter = 1;
                }
            }else{
                if (loadedOpponentCurrentBatter > opponentTeamCount) {
                    loadedOpponentCurrentBatter = 1;
                }
            }
            
            [self addToBoxScoreDictionary];
            NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
            
            [self saveBoxScore];

            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            break;
            
        case 1:
                //2B
            NSLog(@"2B");
            currentPitchCount ++;
            doubleHit ++;
            
            if (batting) {
                    //HOME
                NSLog(@"isHomeTeam:yes");
                [self addMyDouble];
                
                if ([self DoesMyTeamFileExist]) {
                    [self removeTeamDictionaryFile];
                    [self saveUpdatedMyTeamInfo];
                    
                }
                
                if (isTopOfInning) {
                    visitorHits++;
                }else{
                    homeHits++;
                }
                [self showPitchCount];
                [self showPitchStrike];
                
                
                loadedMyTeamCurrentBatter ++;
                
                [self addToBoxScoreDictionary];
                NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
                
                [self saveBoxScore];
                [self addOpponentStrikeThrown];
                
                
                [self performSegueWithIdentifier:@"hcSegue" sender:nil];
                
            }else{
                    //OPPONENT BATTING
                NSLog(@"is Hometeam:NO");
                
                [self addOpponentDouble];
                if ([self DoesMyOpponentFileExist]) {
                    [self removeOpponentDictionaryFile];
                    [self saveUpdatedOpponentTeamInfo];
                }
                
                if (isTopOfInning) {
                    visitorHits++;
                }else{
                    homeHits++;
                }
                
            }
                //see the pitch position
            NSLog(@"pitch location: %@",pitchLocationArray);
            
            [self showPitchCount];
            [self showPitchStrike];
            
                //LAST
            NSLog(@"pre-batterpositionnumber %i",batterPositionNumber);
            NSLog(@"boxScoreDict %@",boxScoreDictionary);
            
            loadedOpponentCurrentBatter ++;
            NSLog(@"post-batterpositionnumber %i",batterPositionNumber);
            
            [self addToBoxScoreDictionary];
            NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
            
            [self saveBoxScore];
            [self addMyStrikeThrown];
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            break;
            
        case 2:
                // 3B
            NSLog(@"3B");
            currentPitchCount ++;
            tripleHit ++;
            
            if (batting) {
                    //HOME
                
                [self addMyTriple];
                NSLog(@"isHomeTeam:yes");
                if ([self DoesMyTeamFileExist]) {
                    [self removeTeamDictionaryFile];
                    [self saveUpdatedMyTeamInfo];
                    
                }
                
                if (isTopOfInning) {
                    visitorHits++;
                }else{
                    homeHits++;
                }
                [self showPitchCount];
                [self showPitchStrike];
                
                loadedMyTeamCurrentBatter ++;
                [self addToBoxScoreDictionary];
                NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
                
                [self saveBoxScore];
                
                [self addOpponentStrikeThrown];
                [self performSegueWithIdentifier:@"hcSegue" sender:nil];
                
            }else{
                    //OPPONENT
                NSLog(@"isHomeTeam:no");
                
                [self addOpponentTriple];
                
                if ([self DoesMyOpponentFileExist]) {
                    [self removeOpponentDictionaryFile];
                    [self saveUpdatedOpponentTeamInfo];
                }
                
                if (isTopOfInning) {
                    visitorHits++;
                }else{
                    homeHits++;
                }
            }
            
                //see the pitch position
            NSLog(@"pitch location: %@",pitchLocationArray);
            
            [self showPitchCount];
            [self showPitchStrike];
            
                //LAST
            NSLog(@"pre-batterpositionnumber %i",batterPositionNumber);
            NSLog(@"boxScoreDict %@",boxScoreDictionary);
            
            loadedOpponentCurrentBatter ++;
            NSLog(@"post-batterpositionnumber %i",batterPositionNumber);
            
            [self addToBoxScoreDictionary];
            NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
            
            [self saveBoxScore];
            [self addMyStrikeThrown];
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            break;
            
        case 3:
                //HR
            NSLog(@"HR");
            currentPitchCount++;
            homeRun ++;
            
            if (batting) {
                    //HOME
                NSLog(@"isHomeTeam:yes");
                [self addMyHR];
                
                if ([self DoesMyTeamFileExist]) {
                    [self removeTeamDictionaryFile];
                    [self saveUpdatedMyTeamInfo];
                    
                }
                
                if (isTopOfInning) {
                    visitorHits++;
                }else{
                    homeHits++;
                }
                [self showPitchCount];
                [self showPitchStrike];
                
                loadedTemp = [[boxScoreDictionary valueForKey:@"myteambattingpositionnumber"]intValue];
                
                loadedMyTeamCurrentBatter ++;
                [self addToBoxScoreDictionary];
                NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
                
                [self saveBoxScore];
                [self addOpponentStrikeThrown];
                [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            }else{
                    //OPPONENT
                NSLog(@"isHomeTeam:no");
                
                [self addOpponentHR];
                
                if ([self DoesMyOpponentFileExist]) {
                    [self removeOpponentDictionaryFile];
                    [self saveUpdatedOpponentTeamInfo];
                }
                
                if (isTopOfInning) {
                    visitorHits++;
                }else{
                    homeHits++;
                }
                
            }
                //see the pitch position
            NSLog(@"pitch location: %@",pitchLocationArray);
            
            [self showPitchCount];
            [self showPitchStrike];
            
                //LAST
            NSLog(@"pre-batterpositionnumber %i",batterPositionNumber);
            NSLog(@"boxScoreDict %@",boxScoreDictionary);
            
            loadedOpponentCurrentBatter ++;
            NSLog(@"post-batterpositionnumber %i",batterPositionNumber);
            
            [self addToBoxScoreDictionary];
            NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
            
            [self saveBoxScore];
            [self addMyStrikeThrown];
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            break;
            
        case 4:
                // FC
            NSLog(@"FC");
            currentPitchCount++;
            fieldersChoice ++;
            
            
            if (batting) {
                    //HOME
                NSLog(@"isHomeTeam:yes");
                [self addMyFC];
                
                if ([self DoesMyTeamFileExist]) {
                    [self removeTeamDictionaryFile];
                    [self saveUpdatedMyTeamInfo];
                    
                }
                
                [self showPitchCount];
                [self showPitchStrike];
                
                
                loadedMyTeamCurrentBatter ++;
                [self addToBoxScoreDictionary];
                NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
                
                [self saveBoxScore];
                [self addOpponentStrikeThrown];
                [self performSegueWithIdentifier:@"hcSegue" sender:nil];
                
            }else{
                    //OPPONENT
                NSLog(@"no");
                
                [self addOpponentFC];
                if ([self DoesMyOpponentFileExist]) {
                    [self removeOpponentDictionaryFile];
                    [self saveUpdatedOpponentTeamInfo];
                }
                
                if (isTopOfInning) {
                    visitorHits++;
                }else{
                    homeHits++;
                }
                
            }
                //see the pitch position
            NSLog(@"pitch location: %@",pitchLocationArray);
            
            [self showPitchCount];
            [self showPitchStrike];
            
                //LAST
            NSLog(@"pre-batterpositionnumber %i",batterPositionNumber);
            NSLog(@"boxScoreDict %@",boxScoreDictionary);
            
            loadedOpponentCurrentBatter ++;
            NSLog(@"post-batterpositionnumber %i",batterPositionNumber);
            
            [self addToBoxScoreDictionary];
            NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
            
            [self saveBoxScore];
            
            [self addMyStrikeThrown];
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            break;
            
        case 5:
                //E
            NSLog(@"E");
            currentPitchCount++;
            fieldingError ++;
            [self addMyError];
            
            if (batting) {
                    //HOME
                NSLog(@"isHomeTeam:yes");
                if ([self DoesMyTeamFileExist]) {
                    [self removeTeamDictionaryFile];
                    [self saveUpdatedMyTeamInfo];
                    
                }
                
                if (isTopOfInning) {
                    visitorErrors++;
                }else{
                    homeErrors++;
                }
                [self showPitchCount];
                [self showPitchStrike];
                
                
                loadedMyTeamCurrentBatter ++;
                [self addToBoxScoreDictionary];
                NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
                
                [self saveBoxScore];
                [self addOpponentStrikeThrown];
                [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            }else{
                    //OPPONENT
                NSLog(@"no");
                
                [self addOpponentError];
                if ([self DoesMyOpponentFileExist]) {
                    [self removeOpponentDictionaryFile];
                    [self saveUpdatedOpponentTeamInfo];
                }
                
                if (isTopOfInning) {
                    visitorErrors++;
                }else{
                    homeErrors++;
                }
                
            }
                //see the pitch position
            NSLog(@"pitch location: %@",pitchLocationArray);
            
            [self showPitchCount];
            [self showPitchStrike];
            
                //LAST
            NSLog(@"pre-batterpositionnumber %i",batterPositionNumber);
            NSLog(@"boxScoreDict %@",boxScoreDictionary);
            
            loadedOpponentCurrentBatter ++;
            NSLog(@"post-batterpositionnumber %i",batterPositionNumber);
            
            [self addToBoxScoreDictionary];
            NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
            
            [self saveBoxScore];
            [self addMyStrikeThrown];
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            break;
            
        case 6:
                // OUT
            NSLog(@"OUT");
            currentOuts ++;
            
            if (batting) {
                    //HOME
                NSLog(@"isHomeTeam:yes");
                myOut++;
                [self addMyOut];
                    // **** ADD CURRENTOUTS TO BOXSCORE
                [self addOpponentStrikeThrown];
            }else{
                    //OPPONENT
                NSLog(@"no");
                opponentOut++;
                [self addOpponentOut];
                [self addMyStrikeThrown];
            }
            
            if (currentOuts > 2) {
                if (isTopOfInning) {
                    isTopOfInning = NO;
                    
                }else{
                    isTopOfInning = YES;
                    currentInning++;
                }
                currentOuts = 0;
                if (batting) {
                    batting = NO;
                }else{
                    batting = YES;
                }
            }
            
            [self showPitchCount];
            [self showPitchStrike];
            
            
            loadedMyTeamCurrentBatter ++;
            [self addToBoxScoreDictionary];
            NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
            
            [self saveBoxScore];
            
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            
            break;
            
        case 7:
                // HP
            NSLog(@"HP");
            currentPitchCount ++;
            hitByPitch ++;
            
            if (batting) {
                    //HOME
                NSLog(@"isHomeTeam:yes");
                [self addMyHP];
                if ([self DoesMyTeamFileExist]) {
                    [self removeTeamDictionaryFile];
                    [self saveUpdatedMyTeamInfo];
                    
                    [self showPitchCount];
                    [self showPitchStrike];
                    
                    loadedMyTeamCurrentBatter ++;
                    [self addToBoxScoreDictionary];
                    NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
                    
                    [self saveBoxScore];
                    [self addOpponentBallThrown];
                    [self viewDidLoad];
                    
                }
            }else{
                    //OPPONENT
                NSLog(@"no");
                
                [self addOpponentHP];
                if ([self DoesMyOpponentFileExist]) {
                    [self removeOpponentDictionaryFile];
                    [self saveUpdatedOpponentTeamInfo];
                }
                [self showPitchCount];
                [self showPitchStrike];
                
                loadedOpponentCurrentBatter ++;
                [self addToBoxScoreDictionary];
                NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
                
                [self saveBoxScore];
                [self addMyBallThrown];
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
            if (batting) {
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
                [self addOpponentStrikeThrown];
                [self performSegueWithIdentifier:@"hcSegue" sender:nil];
                
                
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
            [self addMyStrikeThrown];
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
                
                if (batting) {
                    
                    [self addOpponentBallThrown];
                }else{
                    
                    [self addMyBallThrown];
                }
                
                batterPositionNumber ++;
                NSLog(@"batterPositionNumber: %i",batterPositionNumber);
                
                [self addToBoxScoreDictionary];
                NSLog(@"return add to boxscore-batterpositionnumber %i",batterPositionNumber);
                
                [self saveBoxScore];
                
            }
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
                
                if (batting) {
                    [self addOpponentStrikeThrown];
                }else{
                    [self addMyStrikeThrown];
                }
                [self addToBoxScoreDictionary];
                [self saveBoxScore];
                
            }
            [self showPitchCount];
            [self showPitchStrike];
            
            
            [self performSegueWithIdentifier:@"hcSegue" sender:nil];
            
            break;
            
        default:
            break;
    }
}

- (void)addStrike{
        //add strike to pitcher
    
    if (batting) {
            //opponent team
        NSPredicate *cp = [NSPredicate predicateWithFormat:@"pitcher = true"];
        NSArray *filtered = [opponentTeamDictionaryArray filteredArrayUsingPredicate:cp];
        id item = [filtered objectAtIndex:0];
        NSUInteger itemIndex = [opponentTeamDictionaryArray indexOfObject:item];
        
        NSLog(@"filter %@",filtered);
        NSArray *f;
        
        f = [filtered valueForKey:@"lastname"];
        
        currentPitcher = [f objectAtIndex:0];
        
        NSLog(@"currentPitcher: %@",currentPitcher);
        
        [self loadMyTeamDictionaryArray];
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
        [opponentTeamDictionaryArray replaceObjectAtIndex:itemIndex withObject:tempdict];
        NSLog(@"opponentTeamDictArr: %@",opponentTeamDictionaryArray);
        
        [self saveUpdatedOpponentTeamInfo];
    }else{
            //my team
        NSPredicate *cp = [NSPredicate predicateWithFormat:@"pitcher = true"];
        NSArray *filtered = [myTeamDictionaryArray filteredArrayUsingPredicate:cp];
        id item = [filtered objectAtIndex:0];
        NSUInteger itemIndex = [myTeamDictionaryArray indexOfObject:item];
        
        NSLog(@"filter %@",filtered);
        NSArray *f;
        
        f = [filtered valueForKey:@"lastname"];
        
        currentPitcher = [f objectAtIndex:0];
        
        NSLog(@"ADD STRIKE ELSE:currentPitcher: %@",currentPitcher);
        
        [self loadMyTeamDictionaryArray];
        
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
                    th,@"myteambattingpositionnumber",
                    
                    nil];
        
        [myTeamDictionaryArray replaceObjectAtIndex:itemIndex withObject:tempdict];
        [self saveUpdatedMyTeamInfo];
    }
}

- (void)addBall{
        //add BALL to pitcher
    
    if (batting) {
            //opponent team
        [self LoadOpponentTeam];
        
        NSPredicate *cp = [NSPredicate predicateWithFormat:@"pitcher = true"];
        NSArray *filtered = [opponentTeamDictionaryArray filteredArrayUsingPredicate:cp];
        id item = [filtered objectAtIndex:0];
        opponentPitcherIndex = [opponentTeamDictionaryArray indexOfObject:item];
        
        NSLog(@"filter %@",filtered);
        NSArray *f;
        
        f = [filtered valueForKey:@"lastname"];
        
        opponentPitcher = [f objectAtIndex:0];
        
        NSLog(@"opponentPitcher: %@",opponentPitcher);

            //add to loaded
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
        
            //write back file
        [opponentTeamDictionaryArray replaceObjectAtIndex:opponentPitcherIndex withObject:tempdict];
        NSLog(@"opponentTeamDictArr: %@",opponentTeamDictionaryArray);
        
        [self saveUpdatedOpponentTeamInfo];
        
    }else{
        [self LoadMyTeam];
        
        NSPredicate *cp = [NSPredicate predicateWithFormat:@"pitcher = true"];
        NSArray *filtered = [myTeamDictionaryArray filteredArrayUsingPredicate:cp];
        id item = [filtered objectAtIndex:0];
        myPitcherIndex = [myTeamDictionaryArray indexOfObject:item];
        
        NSLog(@"filter %@",filtered);
        NSArray *f;
        
        f = [filtered valueForKey:@"lastname"];
        
        myPitcher = [f objectAtIndex:0];
        
        NSLog(@"myPitcher: %@",myPitcher);
        
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
                    pc,@"pitchingchart",
                    hc,@"hittingchart",
                    
                    
                    nil];
        
        [myTeamDictionaryArray replaceObjectAtIndex:myPitcherIndex withObject:tempdict];
        
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
        NSLog(@"PitchChart Segue loadedtemp: %i",loadedTemp);
    
    { HittingChartViewController *vc = [segue destinationViewController];
        vc.receivedBatterPositionNumber = batterPositionNumber;
    }
}

#pragma mark - Load Files

- (void)LoadMyTeam{
    NSLog(@"LoadMyTeamFromFile");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"teamdictionary.out"];
    
    myTeamDictionaryArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    lastName = [myTeamDictionaryArray valueForKey:@"lastname"];
    playerBats = [myTeamDictionaryArray valueForKey:@"playerbat"];
    playerNumber = [myTeamDictionaryArray valueForKey:@"playernumber"];
    
    NSLog(@"myTeamDictionaryArray %@",myTeamDictionaryArray);
    NSLog(@"currentPitcher: %@",currentPitcher);
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
    batting = [b boolValue];
    
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
    
    
    NSLog(@"end of myTeamDictionaryArray: %@",myTeamDictionaryArray);
    
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
    gameTimeStart = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:gameTimeStart]);
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

- (void)GamePitchers{
    NSPredicate *cp = [NSPredicate predicateWithFormat:@"pitcher = true"];
    myPitcherArray = [myTeamDictionaryArray filteredArrayUsingPredicate:cp];
    NSLog(@"filter %@",myPitcherArray);
    
    NSPredicate *cp1 = [NSPredicate predicateWithFormat:@"pitcher = true"];
    opponentPitcherArray = [opponentTeamDictionaryArray filteredArrayUsingPredicate:cp1];
    NSLog(@"filter %@",opponentPitcherArray);
    
    NSArray *f;
    
    f = [cp valueForKey:@"lastname"];
    
    currentPitcher = [f objectAtIndex:0];
    NSLog(@"myPitcher: %@",currentPitcher);
    
    NSLog(@"opponentPitcher: %@",opponentPitcher);
    
    
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
    NSLog(@"batterPositionNumber %i",loadedMyTeamCurrentBatter);
    if (batting) {
            //Myteam
        
        if (loadedMyTeamCurrentBatter > myTeamCount) {
            batterPositionNumber = 1;
        }
        
        NSLog(@"addToBoxScoreDict: %i",batterPositionNumber);
        
        homeTeam = @(isHomeTeam);//
        NSNumber *currentouts = [NSNumber numberWithInt:currentOuts];//
        NSNumber *ami = @(batting);//
        NSNumber *top = @(isTopOfInning);//
        NSNumber *pitc = [NSNumber numberWithInt:currentPitchCount];//
        NSNumber *homerun = [NSNumber numberWithInt:homeRuns];//
        NSNumber *homehits = [NSNumber numberWithInt:homeHits];//
        NSNumber *homeerrors = [NSNumber numberWithInt:homeErrors];//
        NSNumber *visitorrun = [NSNumber numberWithInt:visitorRuns];//
        NSNumber *visitorhits = [NSNumber numberWithInt:visitorHits];//
        NSNumber *visitorerrors = [NSNumber numberWithInt:visitorErrors];//
        NSString *position = [NSString stringWithFormat:@"%d",loadedMyTeamCurrentBatter];//
        NSNumber *oppPos = [NSNumber numberWithInt:loadedOpponentCurrentBatter];
        NSNumber *inn = [NSNumber numberWithInt:currentInning];
        
        boxScoreDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              homerun,@"homeruns",//-
                              homehits,@"homehits",//-
                              homeerrors,@"homeerrors",//-
                              visitorrun,@"visitorruns",//-
                              visitorhits,@"visitorhits",//-
                              visitorerrors,@"visitorerrors",//-
                              pitc,@"pitchcount",//-
                              currentouts,@"currentouts",//-
                              homeTeam,@"ishometeam",//-
                              ami,@"amibatting",//-
                              top,@"istopofinning",//-
                              position,@"myteambattingpositionnumber",//-
                              oppPos,@"opponentbattingpositionnumber",
                              inn,@"currentinning",
                              
                              nil];
        
        NSLog(@"boxScoreDictionary: %@",boxScoreDictionary);
        
        
    }else{
            //not batting
            //Opponent
        
        if (loadedOpponentCurrentBatter > opponentTeamCount) {
            batterPositionNumber = 1;
        }
        
        if (loadedTemp == opponentTeamCount) {
            loadedTemp = 1;
        }else{
            loadedTemp++;
        }
        NSLog(@"addToBoxScoreDict: %i",batterPositionNumber);
        homeTeam = @(isHomeTeam);//
        NSNumber *currentouts = [NSNumber numberWithInt:currentOuts];//
        NSNumber *ami = @(batting);//
        NSNumber *top = @(isTopOfInning);//
        NSNumber *pitc = [NSNumber numberWithInt:currentPitchCount];//
        NSNumber *homerun = [NSNumber numberWithInt:homeRuns];//
        NSNumber *homehits = [NSNumber numberWithInt:homeHits];//
        NSNumber *homeerrors = [NSNumber numberWithInt:homeErrors];//
        NSNumber *visitorrun = [NSNumber numberWithInt:visitorRuns];//
        NSNumber *visitorhits = [NSNumber numberWithInt:visitorHits];//
        NSNumber *visitorerrors = [NSNumber numberWithInt:visitorErrors];//
        
        NSString *position = [NSString stringWithFormat:@"%d",loadedOpponentCurrentBatter];
        NSNumber *myPos = [NSNumber numberWithInt:loadedMyTeamCurrentBatter];
        
        NSNumber *inn = [NSNumber numberWithInt:currentInning];
        
        boxScoreDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              homerun,@"homeruns",//-
                              homehits,@"homehits",//-
                              homeerrors,@"homeerrors",//-
                              visitorrun,@"visitorruns",//-
                              visitorhits,@"visitorhits",//-
                              visitorerrors,@"visitorerrors",//-
                              pitc,@"pitchcount",//-
                              currentouts,@"currentouts",//-
                              homeTeam,@"ishometeam",//-
                              ami,@"amibatting",//-
                              top,@"istopofinning",//-
                              myPos,@"myteambattingpositionnumber",//-
                              position,@"opponentbattingpositionnumber",
                              inn,@"currentinning",
                              
                              nil];
        
        NSLog(@"boxScoreDictionary: %@",boxScoreDictionary);
        
    }
    
    if ([self DoesBoxScoreExist]) {
        NSLog(@"DoesBoxScoreExist = YES");
    }
    [self removeBoxScore];
    
    
}

#pragma mark - Add My Batting

- (void)addMyWalks{
    NSLog(@"addMyWalks");
    
    [self loadMyTeamDictionaryArray];
    
    
    int t1 = [wa intValue];
    t1++;
    strValue = [@(t1) stringValue];
    NSString *position = [@(batterPositionNumber) stringValue];
    
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                position,@"myteambattingpositionnumber",
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
    NSString *position = [@(currentBatterPosition) stringValue];
    
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                position,@"myteambattingpositionnumber",
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeTeamDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeTeamDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeTeamDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeTeamDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeTeamDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeTeamDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeTeamDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeTeamDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeTeamDictionaryFile];
    [self saveUpdatedMyTeamInfo];
    
    
    
}

#pragma mark - Add My Pitching

- (void)addMyBallThrown{
    NSLog(@"addMyBallThrown");
    
            [self loadMyTeamDictionaryArray];
    
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[myTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeTeamDictionaryFile];
    [self saveUpdatedMyTeamInfo];
    
}

- (void)addMyStrikeThrown{
        //my team
    
    
            [self loadMyTeamDictionaryArray];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [myTeamDictionaryArray replaceObjectAtIndex:myPitcherIndex withObject:tempdict];
    
        //saveback
    [self removeTeamDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myTeamPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
    [self removeOpponentDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myOpponentPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeOpponentDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myOpponentPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeOpponentDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myOpponentPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeOpponentDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myOpponentPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeOpponentDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myOpponentPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeOpponentDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myOpponentPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeOpponentDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myOpponentPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeOpponentDictionaryFile];
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myOpponentPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeOpponentDictionaryFile];
    [self saveUpdatedOpponentTeamInfo];
    
}

#pragma mark - Add My Pitching

- (void)addOpponentBallThrown{
    NSLog(@"addOpponentBallThrown");
    
    [self loadOpponentTeamDictionaryArray];
    
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
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myOpponentPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeOpponentDictionaryFile];
    [self saveUpdatedOpponentTeamInfo];
    
}

- (void)addOpponentStrikeThrown{
    NSLog(@"addOpponentStrikeThrown");
    
    [self loadOpponentTeamDictionaryArray];
    
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
                wa,@"walks",
                str,@"strikeouts",
                wap,@"walkspitched",
                strp,@"strikeoutspitched",
                pc,@"pitchingchart",
                hc,@"hittingchart",
                nil];
    
    [opponentTeamDictionaryArray replaceObjectAtIndex:batterPositionNumber withObject:tempdict];
    
    
        //update
    NSLog(@"myOpponentPlayerUpdated %i: %@",batterPositionNumber,[[opponentTeamDictionaryArray valueForKey:@"HR"] objectAtIndex:batterPositionNumber]);
    
        //saveback
    [self removeOpponentDictionaryFile];
    [self saveUpdatedOpponentTeamInfo];
    
}


@end
