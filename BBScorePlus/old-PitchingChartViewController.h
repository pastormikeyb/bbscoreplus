//
//  PitchingChartViewController.h
//  BBScorePlus
//
//  Created by Michael on 10/15/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HittingChartViewController.h"

@interface old-PitchingChartViewController : UIViewController
{
    UIImage *baseballImage;
    int currentBatterBall;
    int currentBatterStrike;
    int currentOuts;
    int currentPitchCount;
    int currentBatterPosition;
    int homeRuns,homeHits,homeErrors,totalBallsThrown,totalStrikesThrown;
    int visitorRuns,visitorHits,visitorErrors;
    NSMutableArray *currentPitchingChart;
    NSMutableArray *loadedGameDefaultsArray;
    BOOL isTopOfInning;
    BOOL isBottomOfInning;
    BOOL isMyTeamPitching;
    BOOL isDefaultsLoaded;
    BOOL isGameStarted;
    BOOL isHomeTeam;
    BOOL isTrackPitchCount;
    BOOL DoesBoxScoreExist;
    BOOL doesGameVariablesFileExist;
    BOOL isHalfInningOver;
    NSString *maxPitches, *hoursRest, *timeLimit;

    UILabel *currentBatterNameLabel;
    UILabel *currentBatterHitPositionLabel;

    
}
@property (weak, nonatomic) IBOutlet UILabel *currentBallsLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPitchCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStrikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentOutLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentBat;
@property (weak, nonatomic) IBOutlet UILabel *currentBatter;
@property (weak, nonatomic) IBOutlet UILabel *currentPlayerNumberLabel;
@property (assign) BOOL isTopOfInning;
@property (assign) BOOL isBottomOfInning;
- (IBAction)stepper:(id)sender;

- (IBAction)onClick:(id)sender;

@end
