//
//  PitchChartViewController.h
//  BBScorePlus
//
//  Created by Michael on 11/15/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HittingChartViewController.h"

@interface PitchChartViewController : UIViewController

{
    UIImage *baseballImage;
    int currentBatterBall;
    int currentBatterStrike;
    int currentOuts;
    int currentPitchCount;
    int currentBatterPosition;
    int homeRuns,homeHits,homeErrors,totalBallsThrown,totalStrikesThrown;
    int visitorRuns,visitorHits,visitorErrors;
    int gameTimeLimit,maxNumberOfPitches;
    NSMutableArray *currentPitchingChart;
    NSMutableArray *loadedGameDefaultsArray;
    BOOL isTopOfInning;
    BOOL batting;
    BOOL isMyTeamBatting;
    BOOL isDefaultsLoaded;
    BOOL isGameStarted;
    BOOL isHomeTeam, isContinousLineup;
    BOOL isTrackPitchCount;
    BOOL DoesBoxScoreExist, DoesGameFileExist;
    BOOL DoesGameVariablesFileExist, DoesMyTeamFileExist, DoesMyOpponentFileExist;
    NSString *maxPitches, *hoursRest, *timeLimit;
    
    
    
}
@property (weak, nonatomic) IBOutlet UILabel *currentBallsLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPitchCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStrikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentOutLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentBatLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentBatterLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPlayerNumberLabel;
@property (nonatomic, assign)int batterPositionNumber;


- (IBAction)stepper:(id)sender;

- (IBAction)onClick:(id)sender;


@end
