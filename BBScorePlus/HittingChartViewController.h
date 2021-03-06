//
//  HittingChartViewController.h
//  BBScorePlus
//
//  Created by Michael on 10/15/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "utilities.h"

@interface HittingChartViewController : UIViewController
{
    BOOL didHit,isHomeTeam,batting,isTopOfInning,isMyTeamBatting ;
    NSString *current,*firstname,*lastname;
    int homeRuns,homeHits,homeErrors,visitorRuns,visitorHits,visitorErrors, currentPitchCount, currentOuts, inningNumber,batterPositionNumber;
    NSNumber *playernumber;
    NSDictionary *boxScoreDictionary;

}
@property (weak, nonatomic) IBOutlet UILabel *currentHitterLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorRunsLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorHitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeRunsLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeHitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentInningLabel;
@property (weak, nonatomic) IBOutlet UILabel *topOfInningLabel;


@property (nonatomic, strong)NSString *currentHitter;
@property (nonatomic, strong)NSString *hit;
@property (nonatomic, strong)NSDictionary *pitcherPitchCountDictionary;
@property (nonatomic, strong)NSMutableArray *arrayOfDictionariesMutableArray;
@property (nonatomic, assign)BOOL isMyTeamBatting;
@property (nonatomic, assign)BOOL didHit;
@property (nonatomic, assign)BOOL batting;
@property (nonatomic, assign)BOOL isTopOfInning;
@property (nonatomic, assign)BOOL isGameStarted;

@property (nonatomic, assign)int batterPositionNumber;
@property (nonatomic, assign)int inningNumber;

@property (weak, nonatomic) IBOutlet UIButton *onClick;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *gameOverButton;



@end
