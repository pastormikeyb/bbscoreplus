//
//  HittingChartViewController.h
//  BBScorePlus
//
//  Created by Michael on 10/15/15.
//  Copyright © 2015 Michael Usry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HittingChartViewController : UIViewController
{
    BOOL didHit,isHomeTeam,batting,isTopOfInning,isMyTeamBatting ;
    NSString *current,*firstname,*lastname;
//    NSString *hr,*hh,*he;
//    NSString *vr,*vh,*ve;
    int homeRuns,homeHits,homeErrors,visitorRuns,visitorHits,visitorErrors, currentPitchCount, currentOuts, inningNumber;
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


@property (nonatomic, strong)NSString *currentHitter;
@property (nonatomic, strong)NSString *hit;
@property (nonatomic, strong)NSDictionary *pitcherPitchCountDictionary;
@property (nonatomic, strong)NSMutableArray *arrayOfDictionariesMutableArray;
@property (nonatomic, assign)int receivedBatterPositionNumber;
@property (nonatomic, assign)BOOL isMyTeamBatting;




@end
